class BinanceBalance {
  Info? info;
  BTC? bTC;
  BTC? xRP;
  BTC? tUSD;
  BNB? bNB;
  BTC? eTH;
  USDT? uSDT;
  BTC? uSDP;
  BTC? uSDC;
  BTC? bUSD;
  Free? free;
  Used? used;
  Free? total;

  BinanceBalance(
      {this.info,
      this.bTC,
      this.xRP,
      this.tUSD,
      this.bNB,
      this.eTH,
      this.uSDT,
      this.uSDP,
      this.uSDC,
      this.bUSD,
      this.free,
      this.used,
      this.total});

  BinanceBalance.fromJson(Map<String, dynamic> json) {
    info = json['info'] != null ? Info.fromJson(json['info']) : null;
    bTC = json['BTC'] != null ? BTC.fromJson(json['BTC']) : null;
    xRP = json['XRP'] != null ? BTC.fromJson(json['XRP']) : null;
    tUSD = json['TUSD'] != null ? BTC.fromJson(json['TUSD']) : null;
    bNB = json['BNB'] != null ? BNB.fromJson(json['BNB']) : null;
    eTH = json['ETH'] != null ? BTC.fromJson(json['ETH']) : null;
    uSDT = json['USDT'] != null ? USDT.fromJson(json['USDT']) : null;
    uSDP = json['USDP'] != null ? BTC.fromJson(json['USDP']) : null;
    uSDC = json['USDC'] != null ? BTC.fromJson(json['USDC']) : null;
    bUSD = json['BUSD'] != null ? BTC.fromJson(json['BUSD']) : null;
    free = json['free'] != null ? Free.fromJson(json['free']) : null;
    used = json['used'] != null ? Used.fromJson(json['used']) : null;
    total = json['total'] != null ? Free.fromJson(json['total']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (info != null) {
      data['info'] = info!.toJson();
    }
    if (bTC != null) {
      data['BTC'] = bTC!.toJson();
    }
    if (xRP != null) {
      data['XRP'] = xRP!.toJson();
    }
    if (tUSD != null) {
      data['TUSD'] = tUSD!.toJson();
    }
    if (bNB != null) {
      data['BNB'] = bNB!.toJson();
    }
    if (eTH != null) {
      data['ETH'] = eTH!.toJson();
    }
    if (uSDT != null) {
      data['USDT'] = uSDT!.toJson();
    }
    if (uSDP != null) {
      data['USDP'] = uSDP!.toJson();
    }
    if (uSDC != null) {
      data['USDC'] = uSDC!.toJson();
    }
    if (bUSD != null) {
      data['BUSD'] = bUSD!.toJson();
    }
    if (free != null) {
      data['free'] = free!.toJson();
    }
    if (used != null) {
      data['used'] = used!.toJson();
    }
    if (total != null) {
      data['total'] = total!.toJson();
    }
    return data;
  }
}

class Info {
  String? feeTier;
  bool? canTrade;
  bool? canDeposit;
  bool? canWithdraw;
  String? tradeGroupId;
  String? updateTime;
  bool? multiAssetsMargin;
  String? totalInitialMargin;
  String? totalMaintMargin;
  String? totalWalletBalance;
  String? totalUnrealizedProfit;
  String? totalMarginBalance;
  String? totalPositionInitialMargin;
  String? totalOpenOrderInitialMargin;
  String? totalCrossWalletBalance;
  String? totalCrossUnPnl;
  String? availableBalance;
  String? maxWithdrawAmount;
  List<Assets>? assets;
  List<Positions>? positions;

  Info(
      {this.feeTier,
      this.canTrade,
      this.canDeposit,
      this.canWithdraw,
      this.tradeGroupId,
      this.updateTime,
      this.multiAssetsMargin,
      this.totalInitialMargin,
      this.totalMaintMargin,
      this.totalWalletBalance,
      this.totalUnrealizedProfit,
      this.totalMarginBalance,
      this.totalPositionInitialMargin,
      this.totalOpenOrderInitialMargin,
      this.totalCrossWalletBalance,
      this.totalCrossUnPnl,
      this.availableBalance,
      this.maxWithdrawAmount,
      this.assets,
      this.positions});

  Info.fromJson(Map<String, dynamic> json) {
    feeTier = json['feeTier'];
    canTrade = json['canTrade'];
    canDeposit = json['canDeposit'];
    canWithdraw = json['canWithdraw'];
    tradeGroupId = json['tradeGroupId'];
    updateTime = json['updateTime'];
    multiAssetsMargin = json['multiAssetsMargin'];
    totalInitialMargin = json['totalInitialMargin'];
    totalMaintMargin = json['totalMaintMargin'];
    totalWalletBalance = json['totalWalletBalance'];
    totalUnrealizedProfit = json['totalUnrealizedProfit'];
    totalMarginBalance = json['totalMarginBalance'];
    totalPositionInitialMargin = json['totalPositionInitialMargin'];
    totalOpenOrderInitialMargin = json['totalOpenOrderInitialMargin'];
    totalCrossWalletBalance = json['totalCrossWalletBalance'];
    totalCrossUnPnl = json['totalCrossUnPnl'];
    availableBalance = json['availableBalance'];
    maxWithdrawAmount = json['maxWithdrawAmount'];
    if (json['assets'] != null) {
      assets = <Assets>[];
      json['assets'].forEach((v) {
        assets!.add(Assets.fromJson(v));
      });
    }
    if (json['positions'] != null) {
      positions = <Positions>[];
      json['positions'].forEach((v) {
        positions!.add(Positions.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['feeTier'] = feeTier;
    data['canTrade'] = canTrade;
    data['canDeposit'] = canDeposit;
    data['canWithdraw'] = canWithdraw;
    data['tradeGroupId'] = tradeGroupId;
    data['updateTime'] = updateTime;
    data['multiAssetsMargin'] = multiAssetsMargin;
    data['totalInitialMargin'] = totalInitialMargin;
    data['totalMaintMargin'] = totalMaintMargin;
    data['totalWalletBalance'] = totalWalletBalance;
    data['totalUnrealizedProfit'] = totalUnrealizedProfit;
    data['totalMarginBalance'] = totalMarginBalance;
    data['totalPositionInitialMargin'] = totalPositionInitialMargin;
    data['totalOpenOrderInitialMargin'] = totalOpenOrderInitialMargin;
    data['totalCrossWalletBalance'] = totalCrossWalletBalance;
    data['totalCrossUnPnl'] = totalCrossUnPnl;
    data['availableBalance'] = availableBalance;
    data['maxWithdrawAmount'] = maxWithdrawAmount;
    if (assets != null) {
      data['assets'] = assets!.map((v) => v.toJson()).toList();
    }
    if (positions != null) {
      data['positions'] = positions!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Assets {
  String? asset;
  String? walletBalance;
  String? unrealizedProfit;
  String? marginBalance;
  String? maintMargin;
  String? initialMargin;
  String? positionInitialMargin;
  String? openOrderInitialMargin;
  String? maxWithdrawAmount;
  String? crossWalletBalance;
  String? crossUnPnl;
  String? availableBalance;
  bool? marginAvailable;
  String? updateTime;

  Assets(
      {this.asset,
      this.walletBalance,
      this.unrealizedProfit,
      this.marginBalance,
      this.maintMargin,
      this.initialMargin,
      this.positionInitialMargin,
      this.openOrderInitialMargin,
      this.maxWithdrawAmount,
      this.crossWalletBalance,
      this.crossUnPnl,
      this.availableBalance,
      this.marginAvailable,
      this.updateTime});

  Assets.fromJson(Map<String, dynamic> json) {
    asset = json['asset'];
    walletBalance = json['walletBalance'];
    unrealizedProfit = json['unrealizedProfit'];
    marginBalance = json['marginBalance'];
    maintMargin = json['maintMargin'];
    initialMargin = json['initialMargin'];
    positionInitialMargin = json['positionInitialMargin'];
    openOrderInitialMargin = json['openOrderInitialMargin'];
    maxWithdrawAmount = json['maxWithdrawAmount'];
    crossWalletBalance = json['crossWalletBalance'];
    crossUnPnl = json['crossUnPnl'];
    availableBalance = json['availableBalance'];
    marginAvailable = json['marginAvailable'];
    updateTime = json['updateTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['asset'] = asset;
    data['walletBalance'] = walletBalance;
    data['unrealizedProfit'] = unrealizedProfit;
    data['marginBalance'] = marginBalance;
    data['maintMargin'] = maintMargin;
    data['initialMargin'] = initialMargin;
    data['positionInitialMargin'] = positionInitialMargin;
    data['openOrderInitialMargin'] = openOrderInitialMargin;
    data['maxWithdrawAmount'] = maxWithdrawAmount;
    data['crossWalletBalance'] = crossWalletBalance;
    data['crossUnPnl'] = crossUnPnl;
    data['availableBalance'] = availableBalance;
    data['marginAvailable'] = marginAvailable;
    data['updateTime'] = updateTime;
    return data;
  }
}

class Positions {
  String? symbol;
  double? initialMargin;
  double? maintMargin;
  double? unrealizedProfit;
  double? positionInitialMargin;
  double? openOrderInitialMargin;
  double? leverage;
  bool? isolated;
  double? entryPrice;
  double? breakEvenPrice;
  String? maxNotional;
  String? positionSide;
  double? positionAmt;
  String? notional;
  String? isolatedWallet;
  String? updateTime;
  String? bidNotional;
  String? askNotional;

  Positions(
      {this.symbol,
      this.initialMargin,
      this.maintMargin,
      this.unrealizedProfit,
      this.positionInitialMargin,
      this.openOrderInitialMargin,
      this.leverage,
      this.isolated,
      this.entryPrice,
      this.breakEvenPrice,
      this.maxNotional,
      this.positionSide,
      this.positionAmt,
      this.notional,
      this.isolatedWallet,
      this.updateTime,
      this.bidNotional,
      this.askNotional});

  Positions.fromJson(Map<String, dynamic> json) {
    symbol = json['symbol'];
    initialMargin = double.tryParse(json['initialMargin'].toString());
    maintMargin = double.tryParse(json['maintMargin'].toString());
    unrealizedProfit = double.tryParse(json['unrealizedProfit'].toString());
    positionInitialMargin =
        double.tryParse(json['positionInitialMargin'].toString());
    openOrderInitialMargin =
        double.tryParse(json['openOrderInitialMargin'].toString());
    leverage = double.tryParse(json['leverage'].toString());
    isolated = json['isolated'];
    entryPrice = double.tryParse(json['entryPrice'].toString());
    breakEvenPrice = double.tryParse(json['breakEvenPrice'].toString());
    maxNotional = json['maxNotional'];
    positionSide = json['positionSide'];
    positionAmt = double.tryParse(json['positionAmt'].toString());
    notional = json['notional'];
    isolatedWallet = json['isolatedWallet'];
    updateTime = json['updateTime'];
    bidNotional = json['bidNotional'];
    askNotional = json['askNotional'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['symbol'] = symbol;
    data['initialMargin'] = initialMargin;
    data['maintMargin'] = maintMargin;
    data['unrealizedProfit'] = unrealizedProfit;
    data['positionInitialMargin'] = positionInitialMargin;
    data['openOrderInitialMargin'] = openOrderInitialMargin;
    data['leverage'] = leverage;
    data['isolated'] = isolated;
    data['entryPrice'] = entryPrice;
    data['breakEvenPrice'] = breakEvenPrice;
    data['maxNotional'] = maxNotional;
    data['positionSide'] = positionSide;
    data['positionAmt'] = positionAmt;
    data['notional'] = notional;
    data['isolatedWallet'] = isolatedWallet;
    data['updateTime'] = updateTime;
    data['bidNotional'] = bidNotional;
    data['askNotional'] = askNotional;
    return data;
  }
}

class BTC {
  double? free;
  double? used;
  double? total;

  BTC({this.free, this.used, this.total});

  BTC.fromJson(Map<String, dynamic> json) {
    free = double.tryParse(json['free'].toString());
    used = double.tryParse(json['used'].toString());
    total = double.tryParse(json['total'].toString());
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['free'] = free;
    data['used'] = used;
    data['total'] = total;
    return data;
  }
}

class BNB {
  double? free;
  double? used;
  double? total;

  BNB({this.free, this.used, this.total});

  BNB.fromJson(Map<String, dynamic> json) {
    free = double.tryParse(json['free'].toString());
    used = double.tryParse(json['used'].toString());
    total = double.tryParse(json['total'].toString());
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['free'] = free;
    data['used'] = used;
    data['total'] = total;
    return data;
  }
}

class USDT {
  double? free;
  double? used;
  double? total;

  USDT({this.free, this.used, this.total});

  USDT.fromJson(Map<String, dynamic> json) {
    free = json['free'];
    used = json['used'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['free'] = free;
    data['used'] = used;
    data['total'] = total;
    return data;
  }
}

class Free {
  double? bTC;
  double? xRP;
  double? tUSD;
  double? bNB;
  double? eTH;
  double? uSDT;
  double? uSDP;
  double? uSDC;
  double? bUSD;

  Free(
      {this.bTC,
      this.xRP,
      this.tUSD,
      this.bNB,
      this.eTH,
      this.uSDT,
      this.uSDP,
      this.uSDC,
      this.bUSD});

  Free.fromJson(Map<String, dynamic> json) {
    bTC = double.tryParse(json['BTC'].toString());
    xRP = double.tryParse(json['XRP'].toString());
    tUSD = double.tryParse(json['TUSD'].toString());
    bNB = double.tryParse(json['BNB'].toString());
    eTH = double.tryParse(json['ETH'].toString());
    uSDT = double.tryParse(json['USDT'].toString());
    uSDP = double.tryParse(json['USDP'].toString());
    uSDC = double.tryParse(json['USDC'].toString());
    bUSD = double.tryParse(json['BUSD'].toString());
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['BTC'] = bTC;
    data['XRP'] = xRP;
    data['TUSD'] = tUSD;
    data['BNB'] = bNB;
    data['ETH'] = eTH;
    data['USDT'] = uSDT;
    data['USDP'] = uSDP;
    data['USDC'] = uSDC;
    data['BUSD'] = bUSD;
    return data;
  }
}

class Used {
  double? bTC;
  double? xRP;
  double? tUSD;
  double? bNB;
  double? eTH;
  double? uSDT;
  double? uSDP;
  double? uSDC;
  double? bUSD;

  Used(
      {this.bTC,
      this.xRP,
      this.tUSD,
      this.bNB,
      this.eTH,
      this.uSDT,
      this.uSDP,
      this.uSDC,
      this.bUSD});

  Used.fromJson(Map<String, dynamic> json) {
    bTC = double.tryParse(json['BTC'].toString());
    xRP = double.tryParse(json['XRP'].toString());
    tUSD = double.tryParse(json['TUSD'].toString());
    bNB = double.tryParse(json['BNB'].toString());
    eTH = double.tryParse(json['ETH'].toString());
    uSDT = double.tryParse(json['USDT'].toString());
    uSDP = double.tryParse(json['USDP'].toString());
    uSDC = double.tryParse(json['USDC'].toString());
    bUSD = double.tryParse(json['BUSD'].toString());
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['BTC'] = bTC;
    data['XRP'] = xRP;
    data['TUSD'] = tUSD;
    data['BNB'] = bNB;
    data['ETH'] = eTH;
    data['USDT'] = uSDT;
    data['USDP'] = uSDP;
    data['USDC'] = uSDC;
    data['BUSD'] = bUSD;
    return data;
  }
}
