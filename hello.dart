// String hello = "Hello, World!";

// ignore_for_file: avoid_print

class Trades {
  num buyPrice;
  num qty;

  Trades(this.buyPrice, this.qty);
}

logg(String message) {}

void main() {
  num initialPrice = 164.0;
  num currentPrice = initialPrice;
  num loopPercent = 2;
  num qty = 1;
  num leverage = 4;

  num initialMargin = 1900.0;
  num margin = initialMargin;

  List<Trades> trades = [];

  int i = 0;

  while (currentPrice < (margin * leverage)) {
    trades.add(Trades(currentPrice, qty));

    currentPrice = currentPrice - (currentPrice * loopPercent / 100);
    margin = margin - ((currentPrice * qty) / leverage);
    i++;
    print("$i Start Price: $currentPrice, Margin is: $margin");

    if (margin < (currentPrice * qty)) {
      break;
    }

    if (currentPrice < 100) {
      break;
    }
  }

  num totalLoss = 0.0;

  for (var trade in trades) {
    final totalBuyPrice = trade.buyPrice * trade.qty;
    final totalCurrentPrice = currentPrice * trade.qty;

    final loss = totalBuyPrice - totalCurrentPrice;

    totalLoss += loss;
  }

  final currentValue = initialMargin - totalLoss;

  final dropPercent = ((initialPrice - currentPrice) / initialPrice) * 100;

  print(
      "Total Loss: $totalLoss, Trades: ${trades.length}, currentValue: $currentValue, Initial Price: $initialPrice, Current Price: $currentPrice, Drop Percent: $dropPercent");
}
