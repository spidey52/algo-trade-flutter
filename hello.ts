type Trade = {
 symbol: string;
 price: number;
 qty: number;
};

type TickerConfig = {
 start: number;
 end: number;
 loop: number;
 qty: number;
};

type Ticker = {
 symbol: string;
 price: number;
 config: TickerConfig;
};

type Portfolio = {
 trades: Trade[];
 totalValue: number;
 currentValue: number;
 liquuidationPrice: number;
};

const generateTickers = (d: { symbol: string; start: number; loop: number; qty: number }[]): Ticker[] => {
 return d.map((item) => {
  const price = item.start;
  const config = {
   start: item.start,
   end: item.start * (1 - item.loop / 100),
   loop: item.loop,
   qty: item.qty,
  };
  return { symbol: item.symbol, price, config };
 });
};

const loopPercent = 40;
const loopInterval = 0.75;

const tickers = generateTickers([
 { symbol: "SOLUSDT", start: 165, loop: loopPercent, qty: 1 },
 //  { symbol: "BTCUSDT", start: 65000, loop: loopPercent, qty: 0.002 },
 //  { symbol: "ETHUSDT", start: 2800, loop: loopPercent, qty: 0.03 },
]);

const generateTrades = (tickers: Ticker[]): Trade[] => {
 const trades: Trade[] = [];

 for (const ticker of tickers) {
  while (ticker.price >= ticker.config.end) {
   trades.push({
    symbol: ticker.symbol,
    price: +ticker.price.toFixed(2),
    qty: ticker.config.qty,
   });

   ticker.price = ticker.price * (1 - loopInterval / 100);
  }
 }

 return trades;
};

const getCurrentPriceMap = (tickers: Ticker[]): Map<string, number> => {
 const currentPrices = tickers.reduce((acc, ticker) => {
  acc.set(ticker.symbol, ticker.price);
  return acc;
 }, new Map<string, number>());

 return currentPrices;
};

const calculatePortfolio = (trades: Trade[]): Portfolio => {
 const totalValue = trades.reduce((acc, trade) => acc + trade.price * trade.qty, 0);
 const currentPriceMap = getCurrentPriceMap(tickers);
 const currentValue = trades.reduce((acc, trade) => acc + (currentPriceMap.get(trade.symbol) || 0) * trade.qty, 0);

 const loss = totalValue - currentValue;

 return { trades, totalValue, currentValue, liquuidationPrice: loss };
};

const trades = generateTrades(tickers);

const portfolio = calculatePortfolio(trades);

// group by symbol

const groupBySymbol = (trades: Trade[]) => {
 const groupedTrades = trades.reduce((acc, trade) => {
  if (!acc.has(trade.symbol)) {
   acc.set(trade.symbol, { trades: [], totalValue: 0 });
  }

  const symbolTrades = acc.get(trade.symbol);
  if (symbolTrades) {
   symbolTrades.trades.push(trade);
   symbolTrades.totalValue += trade.price * trade.qty;
  }

  return acc;
 }, new Map<string, { trades: Trade[]; totalValue: number }>());

 return groupedTrades;
};

const groupedTrades = groupBySymbol(trades);

for (const [symbol, trades] of groupedTrades) {
 //  console.log(`\n${symbol}`);
 //  console.log(trades);

 let tradeCount = trades.trades.length;
 let totalValue = trades.totalValue;

 let firstTrade = trades.trades[0];
 let lastTrade = trades.trades[tradeCount - 1];
 console.log(`\n${symbol}`);
 console.log(`Trade Count: ${tradeCount}`);
 console.log(`Total Value: ${totalValue}`);
 console.log(`First Trade: ${firstTrade.price}`);
 console.log(`Last Trade: ${lastTrade.price}`);
}

console.log(`\nTotal Value: ${portfolio.totalValue}`);
console.log(`Current Value: ${portfolio.currentValue}`);
console.log(`Liquidation Price: ${portfolio.liquuidationPrice}`);

//

let total = 22000 + 14000 + 9000 + 15000 + 19000 + 15000 + 6000 + 10000;
