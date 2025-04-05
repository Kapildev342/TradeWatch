
import 'dart:convert';

OverViewModel overViewModelFromJson(String str) => OverViewModel.fromJson(json.decode(str));

String overViewModelToJson(OverViewModel data) => json.encode(data.toJson());

class OverViewModel {
  final bool status;
  final String message;
  final BusinessOverviewResponse response;

  OverViewModel({
    required this.status,
    required this.message,
    required this.response,
  });

  factory OverViewModel.fromJson(Map<String, dynamic> json) => OverViewModel(
    status: json["status"]??false,
    message: json["message"]??"",
    response: BusinessOverviewResponse.fromJson(json["response"]??{}),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "response": response.toJson(),
  };
}

class BusinessOverviewResponse {
  final bool status;
  final String type;
  final String userId;
  final String exchange;
  final String tvSymbol;
  final String code;
  final String name;
  final String country;
  final String category;
  final String industry;
  final String logoUrl;
  final String tickerName;
  final String description;
  final String fullAddress;
  final String phone;
  final String state;
  final Address address;
  final String changeP;
  final String close;
  final String previousClose;
  final String changeValue;
  final String weekLow;
  final String weekHigh;
  final String webUrl;
  final String marketCapitalizationMln;
  final String circulatingSupply;
  final String epse;
  final String sharesMln;
  final String ebitDa;
  final String peRatio;
  final String pegRatio;
  final String revenueTtm;
  final String dividend;
  final String exdividendDate;
  final String dividendDate;
  final String forwardAnnualDividendYield;
  final bool marketAvailable;
  final String updatedTime;
  final bool watchlist;
  final bool believed;
  final bool bookmark;
  final List<WatchlistNotification> watchlistNotification;
  final String dividendYield;
  final String payoutRatio;
  final String sharesOutStanding;
  final String sharesFloat;
  final String percentInsiders;
  final String percentInstitutions;
  final String beta;
  final String fiftyDayMa;
  final String twoHundredDayMa;
  final String forwardAnnualDividendRate;
  final String lastSplitFactor;
  final String lastSplitDate;
  final Highlights highlights;
  final Valuation valuation;
  final Earnings earnings;
  final BalanceSheet balanceSheet;
  final CashFlow cashFlow;
  final IncomeStatement incomeStatement;
  final int billBoardCount;
  final int believedCount;
  int believersCount;
  final int usersView;
  final int reportCount;
  final int blockCount;
  final String coverImage;

  BusinessOverviewResponse({
    required this.status,
    required this.type,
    required this.userId,
    required this.exchange,
    required this.tvSymbol,
    required this.code,
    required this.name,
    required this.country,
    required this.category,
    required this.industry,
    required this.logoUrl,
    required this.tickerName,
    required this.description,
    required this.fullAddress,
    required this.phone,
    required this.state,
    required this.address,
    required this.changeP,
    required this.close,
    required this.previousClose,
    required this.changeValue,
    required this.weekLow,
    required this.weekHigh,
    required this.webUrl,
    required this.marketCapitalizationMln,
    required this.circulatingSupply,
    required this.epse,
    required this.sharesMln,
    required this.ebitDa,
    required this.peRatio,
    required this.pegRatio,
    required this.revenueTtm,
    required this.dividend,
    required this.exdividendDate,
    required this.dividendDate,
    required this.forwardAnnualDividendYield,
    required this.marketAvailable,
    required this.updatedTime,
    required this.watchlist,
    required this.believed,
    required this.bookmark,
    required this.watchlistNotification,
    required this.dividendYield,
    required this.payoutRatio,
    required this.sharesOutStanding,
    required this.sharesFloat,
    required this.percentInsiders,
    required this.percentInstitutions,
    required this.beta,
    required this.fiftyDayMa,
    required this.twoHundredDayMa,
    required this.forwardAnnualDividendRate,
    required this.lastSplitFactor,
    required this.lastSplitDate,
    required this.highlights,
    required this.valuation,
    required this.earnings,
    required this.balanceSheet,
    required this.cashFlow,
    required this.incomeStatement,
    required this.billBoardCount,
    required this.believedCount,
    required this.believersCount,
    required this.usersView,
    required this.reportCount,
    required this.blockCount,
    required this.coverImage,
  });

  factory BusinessOverviewResponse.fromJson(Map<String, dynamic> json) => BusinessOverviewResponse(
    status:json.isEmpty?false:true,
    type: json["type"]??"",
    userId: json["user_id"]??"",
    exchange: json["exchange"]??"",
    tvSymbol: json["tv_symbol"]??"",
    code: json["code"]??"",
    name: json["name"]??"",
    country: json["country"]??"",
    category: json["category"]??"",
    industry: json["industry"]??"",
    logoUrl: json["logo_url"]??"",
    tickerName: json["ticker_name"]??"",
    description: json["description"]??"",
    fullAddress: json["full_address"]??"",
    phone: json["phone"]??"",
    state: json["state"]??"",
    address: Address.fromJson(json["address"]??{}),
    changeP: json["change_p"]=="-"?json["change_p"].toString():json["change_p"].toDouble()<0.01?json["change_p"].toDouble()==0.00?json["change_p"].toString():json["change_p"].toStringAsExponential(2):json["change_p"].toStringAsFixed(2),
    close: json["close"]=="-"?json["close"].toString():json["close"].toDouble()<0.01? json["close"].toDouble()==0.00?json["close"].toString():json["close"].toStringAsExponential(2):json["close"].toStringAsFixed(2),
    previousClose: json["previous_close"]=="-"?json["previous_close"].toString():json["previous_close"].toDouble()<0.01? json["previous_close"].toDouble()==0.00?json["previous_close"].toString():json["previous_close"].toStringAsExponential(2):json["previous_close"].toStringAsFixed(2),
    changeValue: json["change_value"]=="-"?json["change_value"].toString():json["change_value"].toDouble()<0.01? json["change_value"].toDouble()==0.00?json["change_value"].toString(): json["change_value"].toStringAsExponential(2):json["change_value"].toStringAsFixed(2),
    weekLow: roundOffValue(selectedNum: json["week_low"]=="-"?json["week_low"].toString():json["week_low"].toDouble()<0.01? json["week_low"].toDouble()==0.00?json["week_low"].toString(): json["week_low"].toStringAsExponential(2):json["week_low"].toStringAsFixed(2)),
    weekHigh:roundOffValue(selectedNum:  json["week_high"]=="-"?json["week_high"].toString():json["week_high"].toDouble()<0.01? json["week_high"].toDouble()==0.00?json["week_high"].toString(): json["week_high"].toStringAsExponential(2):json["week_high"].toStringAsFixed(2)),
    webUrl: json["web_url"]??"",
    marketCapitalizationMln: json["market_capitalization_mln"]=="-"?json["market_capitalization_mln"].toString():json["market_capitalization_mln"].toDouble()<0.01? json["market_capitalization_mln"].toDouble()==0.00?json["market_capitalization_mln"].toString(): json["market_capitalization_mln"].toStringAsExponential(2):json["market_capitalization_mln"].toStringAsFixed(2),
    circulatingSupply: json["circulating_supply"]=="-"?json["circulating_supply"].toString():json["circulating_supply"].toDouble()<0.01? json["circulating_supply"].toDouble()==0.00?json["circulating_supply"].toString(): json["circulating_supply"].toStringAsExponential(2):json["circulating_supply"].toStringAsFixed(2),
    epse: roundOffValue(selectedNum: json["epse"]=="-"?json["epse"].toString():json["epse"].toDouble()<0.01? json["epse"].toDouble()==0.00?json["epse"].toString(): json["epse"].toStringAsExponential(2):json["epse"].toStringAsFixed(2)),
    sharesMln:json["shares_mln"]=="-"?json["shares_mln"].toString():json["shares_mln"].toDouble()<0.01? json["shares_mln"].toDouble()==0.00?json["shares_mln"].toString(): json["shares_mln"].toStringAsExponential(2): json["shares_mln"].toStringAsFixed(2),
    ebitDa:json["ebit_da"]=="-"?json["ebit_da"].toString():json["ebit_da"].toDouble()<0.01? json["ebit_da"].toDouble()==0.00?json["ebit_da"].toString(): json["ebit_da"].toStringAsExponential(2): json["ebit_da"].toStringAsFixed(2),
    peRatio: json["pe_ratio"]=="-"?json["pe_ratio"].toString():json["pe_ratio"].toDouble()<0.01? json["pe_ratio"].toDouble()==0.00?json["pe_ratio"].toString(): json["pe_ratio"].toStringAsExponential(2):json["pe_ratio"].toStringAsFixed(2),
    pegRatio:json["peg_ratio"]=="-"?json["peg_ratio"].toString():json["peg_ratio"].toDouble()<0.01? json["peg_ratio"].toDouble()==0.00?json["peg_ratio"].toString(): json["peg_ratio"].toStringAsExponential(2):json["peg_ratio"].toStringAsFixed(2),
    revenueTtm:json["revenue_ttm"]=="-"? json["revenue_ttm"].toString():json["revenue_ttm"].toDouble()<0.01? json["revenue_ttm"].toDouble()==0.00?json["revenue_ttm"].toString(): json["revenue_ttm"].toStringAsExponential(2): json["revenue_ttm"].toStringAsFixed(2),
    dividend: json["dividend"]??"",
    exdividendDate: json["dividend_date"]=="-"? json["dividend_date"].toString():json["exdividend_date"].toString().length>10?json["exdividend_date"].toString().substring(0,10):json["exdividend_date"].toString(),
    dividendDate:json["dividend_date"]=="-"? json["dividend_date"].toString():json["dividend_date"].toString().substring(0,10),
    forwardAnnualDividendYield: roundOffValue(selectedNum: json["forward_annual_dividend_yield"]=="-"? json["forward_annual_dividend_yield"].toString():json["forward_annual_dividend_yield"].toDouble()<0.01? json["forward_annual_dividend_yield"].toDouble()==0.00?json["forward_annual_dividend_yield"].toString(): json["forward_annual_dividend_yield"].toStringAsExponential(2): json["forward_annual_dividend_yield"].toStringAsFixed(2)),
    marketAvailable: json["market_available"]??false,
    updatedTime: json["updated_time"]??"",
    watchlist: json["watchlist"]??false,
    believed: json["believed"]??false,
    bookmark: json["bookmark"]??false,
    watchlistNotification:List<WatchlistNotification>.from(json["watchlist_notification"].map((x) => WatchlistNotification.fromJson(x))),
    dividendYield: json["dividend_yield"]=="-"?json["dividend_yield"].toString():json["dividend_yield"].toDouble()<0.01? json["dividend_yield"].toDouble()==0.00?json["dividend_yield"].toString(): json["dividend_yield"].toStringAsExponential(2):json["dividend_yield"].toStringAsFixed(2),
    payoutRatio: roundOffValue(selectedNum: json["payout_ratio"]=="-"?json["payout_ratio"].toString():json["payout_ratio"].toDouble()<0.01? json["payout_ratio"].toDouble()==0.00?json["payout_ratio"].toString(): json["payout_ratio"].toStringAsExponential(2):json["payout_ratio"].toStringAsFixed(2)),
    sharesOutStanding: roundOffValue(selectedNum: json["shares_out_standing"]=="-"?json["shares_out_standing"].toString():json["shares_out_standing"].toDouble()<0.01? json["shares_out_standing"].toDouble()==0.00?json["shares_out_standing"].toString(): json["shares_out_standing"].toStringAsExponential(2):json["shares_out_standing"].toStringAsFixed(2)),
    sharesFloat: roundOffValue(selectedNum: json["shares_float"]=="-"?json["shares_float"].toString():json["shares_float"].toDouble()<0.01? json["shares_float"].toDouble()==0.00?json["shares_float"].toString(): json["shares_float"].toStringAsExponential(2):json["shares_float"].toStringAsFixed(2)),
    percentInsiders: roundOffValue(selectedNum: json["percent_insiders"]=="-"?json["percent_insiders"].toString():json["percent_insiders"].toDouble()<0.01? json["percent_insiders"].toDouble()==0.00?json["percent_insiders"].toString(): json["percent_insiders"].toStringAsExponential(2):json["percent_insiders"].toStringAsFixed(2)),
    percentInstitutions: roundOffValue(selectedNum: json["percent_institutions"]=="-"?json["percent_institutions"].toString():json["percent_institutions"].toDouble()<0.01? json["percent_institutions"].toDouble()==0.00?json["percent_institutions"].toString(): json["percent_institutions"].toStringAsExponential(2):json["percent_institutions"].toStringAsFixed(2)),
    beta:roundOffValue(selectedNum:  json["beta"]=="-"?json["beta"].toString():json["beta"].toDouble()<0.01? json["beta"].toDouble()==0.00?json["beta"].toString(): json["beta"].toStringAsExponential(2):json["beta"].toStringAsFixed(2)),
    fiftyDayMa: roundOffValue(selectedNum:  json["fifty_day_ma"]=="-"?json["fifty_day_ma"].toString():json["fifty_day_ma"].toDouble()<0.01? json["fifty_day_ma"].toDouble()==0.00?json["fifty_day_ma"].toString(): json["fifty_day_ma"].toStringAsExponential(2):json["fifty_day_ma"].toStringAsFixed(2)),
    twoHundredDayMa: roundOffValue(selectedNum:  json["twohundred_day_ma"]=="-"?json["twohundred_day_ma"].toString():json["twohundred_day_ma"].toDouble()<0.01? json["twohundred_day_ma"].toDouble()==0.00?json["twohundred_day_ma"].toString(): json["twohundred_day_ma"].toStringAsExponential(2):json["twohundred_day_ma"].toStringAsFixed(2)),
    forwardAnnualDividendRate: roundOffValue(selectedNum:  json["forward_annual_dividend_rate"]=="-"?json["forward_annual_dividend_rate"].toString():json["forward_annual_dividend_rate"].toDouble()<0.01? json["forward_annual_dividend_rate"].toDouble()==0.00?json["forward_annual_dividend_rate"].toString(): json["forward_annual_dividend_rate"].toStringAsExponential(2):json["forward_annual_dividend_rate"].toStringAsFixed(2)),
    lastSplitFactor: json["last_split_factor"]??"",
    lastSplitDate: json["last_split_date"]??"",
    highlights:Highlights.fromJson(json["Highlights"]??{}),
    valuation:Valuation.fromJson(json["Valuation"]??{}),
    earnings:Earnings.fromJson(json["Earnings"]??{}),
    balanceSheet: BalanceSheet.fromJson(json["Balance_Sheet"]??{}),
    cashFlow:CashFlow.fromJson(json["Cash_Flow"]??{}),
    incomeStatement:IncomeStatement.fromJson(json["Income_Statement"]??{}),
    billBoardCount:json["billboard_count"]??0,
    believedCount:json["believed_count"]??0,
    believersCount:json["believers_count"]??0,
    usersView:json["users_view"]??0,
    reportCount:json["report_count"]??0,
    blockCount:json["block_count"]??0,
    coverImage:json["cover_image"]??"",
  );

  Map<String, dynamic> toJson() => {
    "type": type,
    "user_id": userId,
    "exchange": exchange,
    "tv_symbol": tvSymbol,
    "code": code,
    "name": name,
    "country": country,
    "category": category,
    "industry": industry,
    "logo_url": logoUrl,
    "ticker_name": tickerName,
    "description": description,
    "full_address": fullAddress,
    "believed": believed,
    "bookmark": bookmark,
    "phone": phone,
    "state": state,
    "address": address.toJson(),
    "change_p": changeP,
    "close": close,
    "previous_close": previousClose,
    "change_value": changeValue,
    "week_low": weekLow,
    "week_high": weekHigh,
    "web_url": webUrl,
    "market_capitalization_mln": marketCapitalizationMln,
    "circulating_supply": circulatingSupply,
    "epse": epse,
    "shares_mln": sharesMln,
    "ebit_da": ebitDa,
    "pe_ratio": peRatio,
    "peg_ratio": pegRatio,
    "revenue_ttm": revenueTtm,
    "dividend": dividend,
    "exdividend_date": exdividendDate,
    "dividend_date":dividendDate,// dividendDate.toIso8601String(),
    "forward_annual_dividend_yield": forwardAnnualDividendYield,
    "market_available": marketAvailable,
    "updated_time": updatedTime,
    "dividend_yield": dividendYield,
    "payout_ratio": payoutRatio,
    "shares_out_standing": sharesOutStanding,
    "shares_float": sharesFloat,
    "percent_insiders": percentInsiders,
    "percent_institutions": percentInstitutions,
    "beta": beta,
    "fifty_day_ma": fiftyDayMa,
    "twohundred_day_ma": twoHundredDayMa,
    "forward_annual_dividend_rate": forwardAnnualDividendRate,
    "last_split_factor": lastSplitFactor,
    "last_split_date": lastSplitDate,
    "Highlights": highlights.toJson(),
    "Valuation": valuation.toJson(),
    "Earnings": earnings.toJson(),
    "Balance_Sheet": balanceSheet.toJson(),
    "Cash_Flow": cashFlow.toJson(),
    "Income_Statement": incomeStatement.toJson(),
    "billboard_count":billBoardCount,
    "believed_count":believedCount,
    "believers_count":believersCount,
    "users_view":usersView,
    "report_count":reportCount,
    "block_count":blockCount,
    "cover_image":coverImage,
  };
}

class Address {
  final bool status;
  final String street;
  final String city;
  final String country;
  final dynamic zip;

  Address({
    required this.status,
    required this.street,
    required this.city,
    required this.country,
    required this.zip,
  });

  factory Address.fromJson(Map<String, dynamic> json) => Address(
    status:json.isEmpty?false:true,
    street: json["Street"]??"",
    city: json["City"]??"",
    country: json["Country"]??"",
    zip: json["Zip"]??"",
  );

  Map<String, dynamic> toJson() => {
    "Street": street,
    "City": city,
    "Country": country,
    "Zip": zip,
  };
}

class WatchlistNotification {
  final bool statusNew;
  final String id;
  final String userId;
  final String categoryId;
  final String tickerId;
  final double minValue;
  final double maxValue;
  final String notes;
  final int status;
  final String createdAt;
  final String updatedAt;

  WatchlistNotification({
    required this.statusNew,
    required this.id,
    required this.userId,
    required this.categoryId,
    required this.tickerId,
    required this.minValue,
    required this.maxValue,
    required this.notes,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory WatchlistNotification.fromJson(Map<String, dynamic> json) => WatchlistNotification(
    statusNew:json.isEmpty?false:true,
    id: json["_id"]??"",
    userId: json["user_id"]??"",
    categoryId: json["category_id"]??"",
    tickerId: json["ticker_id"]??"",
    minValue: json["min_value"]?.toDouble()??0.0,
    maxValue: json["max_value"]?.toDouble()??0.0,
    notes: json["notes"]??"",
    status: json["status"]??0,
    createdAt: json["createdAt"]??"",
    updatedAt: json["updatedAt"]??"",
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "user_id": userId,
    "category_id": categoryId,
    "ticker_id": tickerId,
    "min_value": minValue,
    "max_value": maxValue,
    "notes": notes,
    "status": status,
    "createdAt": createdAt,
    "updatedAt": updatedAt,
  };
}

class Highlights {
  /*int marketCapitalization;
  double marketCapitalizationMln;
  int ebitda;
  double peRatio;
  dynamic pegRatio;
  double wallStreetTargetPrice;
  double bookValue;
  int dividendShare;
  double dividendYield;
  double earningsShare;
  double epsEstimateCurrentYear;
  double epsEstimateNextYear;
  double epsEstimateNextQuarter;
  double epsEstimateCurrentQuarter;
  DateTime mostRecentQuarter;
  double profitMargin;
  double operatingMarginTtm;
  double returnOnAssetsTtm;
  double returnOnEquityTtm;
  int revenueTtm;
  double revenuePerShareTtm;
  double quarterlyRevenueGrowthYoy;
  int grossProfitTtm;
  double dilutedEpsTtm;
  double quarterlyEarningsGrowthYoy;
*/
  final bool status;
  final String marketCapitalization;
  final String marketCapitalizationMln;
  final String ebitda;
  final String peRatio;
  final String pegRatio;
  final String wallStreetTargetPrice;
  final String bookValue;
  final String dividendShare;
  final String dividendYield;
  final String earningsShare;
  final String epsEstimateCurrentYear;
  final String epsEstimateNextYear;
  final String epsEstimateNextQuarter;
  final String epsEstimateCurrentQuarter;
  final DateTime mostRecentQuarter;
  final String profitMargin;
  final String operatingMarginTtm;
  final String returnOnAssetsTtm;
  final String returnOnEquityTtm;
  final String revenueTtm;
  final String revenuePerShareTtm;
  final String quarterlyRevenueGrowthYoy;
  final String grossProfitTtm;
  final String dilutedEpsTtm;
  final String quarterlyEarningsGrowthYoy;

  Highlights({
    required this.status,
    required this.marketCapitalization,
    required this.marketCapitalizationMln,
    required this.ebitda,
    required this.peRatio,
    required this.pegRatio,
    required this.wallStreetTargetPrice,
    required this.bookValue,
    required this.dividendShare,
    required this.dividendYield,
    required this.earningsShare,
    required this.epsEstimateCurrentYear,
    required this.epsEstimateNextYear,
    required this.epsEstimateNextQuarter,
    required this.epsEstimateCurrentQuarter,
    required this.mostRecentQuarter,
    required this.profitMargin,
    required this.operatingMarginTtm,
    required this.returnOnAssetsTtm,
    required this.returnOnEquityTtm,
    required this.revenueTtm,
    required this.revenuePerShareTtm,
    required this.quarterlyRevenueGrowthYoy,
    required this.grossProfitTtm,
    required this.dilutedEpsTtm,
    required this.quarterlyEarningsGrowthYoy,
  });

  factory Highlights.fromJson(Map<String, dynamic> json) => Highlights(
    status:json.isEmpty?false:true,
    marketCapitalization: "${json["MarketCapitalization"]??"-"}",
    marketCapitalizationMln:roundOffValue(selectedNum: "${json["MarketCapitalizationMln"] ?? "-"}"),
    ebitda:roundOffValue(selectedNum:  "${json["EBITDA"] ?? "-"}"),
    peRatio: roundOffValue(selectedNum:  "${json["PERatio"] ?? "-"}"),
    pegRatio: roundOffValue(selectedNum:  "${json["PEGRatio"] ?? "-"}"),
    wallStreetTargetPrice: roundOffValue(selectedNum:  "${json["WallStreetTargetPrice"] ?? "-"}"),
    bookValue: roundOffValue(selectedNum:  "${json["BookValue"] ?? "-"}"),
    dividendShare:roundOffValue(selectedNum:   "${json["DividendShare"] ?? "-"}"),
    dividendYield:roundOffValue(selectedNum:   "${json["DividendYield"] ?? "-"}"),
    earningsShare:roundOffValue(selectedNum:   "${json["EarningsShare"] ?? "-"}"),
    epsEstimateCurrentYear: roundOffValue(selectedNum:  "${json["EPSEstimateCurrentYear"] ?? "-"}"),
    epsEstimateNextYear: roundOffValue(selectedNum:  "${json["EPSEstimateNextYear"]?? "-"}"),
    epsEstimateNextQuarter: roundOffValue(selectedNum:  "${json["EPSEstimateNextQuarter"] ?? "-"}"),
    epsEstimateCurrentQuarter: roundOffValue(selectedNum:  "${json["EPSEstimateCurrentQuarter"] ?? "-"}"),
    mostRecentQuarter: json["MostRecentQuarter"]==null?DateTime.now():DateTime.parse(json["MostRecentQuarter"]),
    profitMargin: roundOffValue(selectedNum:  "${json["ProfitMargin"] ?? "-"}"),
    operatingMarginTtm:roundOffValue(selectedNum:   "${json["OperatingMarginTTM"] ?? "-"}"),
    returnOnAssetsTtm:roundOffValue(selectedNum:   "${json["ReturnOnAssetsTTM"] ?? "-"}"),
    returnOnEquityTtm: roundOffValue(selectedNum:  "${json["ReturnOnEquityTTM"] ?? "-"}"),
    revenueTtm: roundOffValue(selectedNum:  "${json["RevenueTTM"] ?? "-"}"),
    revenuePerShareTtm: roundOffValue(selectedNum:  "${json["RevenuePerShareTTM"]??"-"}"),
    quarterlyRevenueGrowthYoy: roundOffValue(selectedNum:  "${json["QuarterlyRevenueGrowthYOY"] ?? "-"}"),
    grossProfitTtm: roundOffValue(selectedNum:  "${json["GrossProfitTTM"] ?? "-"}"),
    dilutedEpsTtm: roundOffValue(selectedNum:  "${json["DilutedEpsTTM"] ?? "-"}"),
    quarterlyEarningsGrowthYoy:roundOffValue(selectedNum:   "${json["QuarterlyEarningsGrowthYOY"] ?? "-"}"),
  );

  Map<String, dynamic> toJson() => {
    "MarketCapitalization": marketCapitalization,
    "MarketCapitalizationMln": marketCapitalizationMln,
    "EBITDA": ebitda,
    "PERatio": peRatio,
    "PEGRatio": pegRatio,
    "WallStreetTargetPrice": wallStreetTargetPrice,
    "BookValue": bookValue,
    "DividendShare": dividendShare,
    "DividendYield": dividendYield,
    "EarningsShare": earningsShare,
    "EPSEstimateCurrentYear": epsEstimateCurrentYear,
    "EPSEstimateNextYear": epsEstimateNextYear,
    "EPSEstimateNextQuarter": epsEstimateNextQuarter,
    "EPSEstimateCurrentQuarter": epsEstimateCurrentQuarter,
    "MostRecentQuarter": "${mostRecentQuarter.year.toString().padLeft(4, '0')}-${mostRecentQuarter.month.toString().padLeft(2, '0')}-${mostRecentQuarter.day.toString().padLeft(2, '0')}",
    "ProfitMargin": profitMargin,
    "OperatingMarginTTM": operatingMarginTtm,
    "ReturnOnAssetsTTM": returnOnAssetsTtm,
    "ReturnOnEquityTTM": returnOnEquityTtm,
    "RevenueTTM": revenueTtm,
    "RevenuePerShareTTM": revenuePerShareTtm,
    "QuarterlyRevenueGrowthYOY": quarterlyRevenueGrowthYoy,
    "GrossProfitTTM": grossProfitTtm,
    "DilutedEpsTTM": dilutedEpsTtm,
    "QuarterlyEarningsGrowthYOY": quarterlyEarningsGrowthYoy,
  };
}

class Valuation {
  /*double trailingPe;
  int forwardPe;
  double priceSalesTtm;
  double priceBookMrq;
  int enterpriseValue;
  double enterpriseValueRevenue;
  double enterpriseValueEbitda;*/
  final bool status;
  final String trailingPe;
  final String forwardPe;
  final String priceSalesTtm;
  final String priceBookMrq;
  final String enterpriseValue;
  final String enterpriseValueRevenue;
  final String enterpriseValueEbitda;


  Valuation({
    required this.status,
    required this.trailingPe,
    required this.forwardPe,
    required this.priceSalesTtm,
    required this.priceBookMrq,
    required this.enterpriseValue,
    required this.enterpriseValueRevenue,
    required this.enterpriseValueEbitda,
  });

  factory Valuation.fromJson(Map<String, dynamic> json) => Valuation(
    status:json.isEmpty?false:true,
    trailingPe:roundOffValue(selectedNum:    "${json["TrailingPE"] ?? "-"}"),
    forwardPe: roundOffValue(selectedNum:   "${json["ForwardPE"] ?? "-"}"),
    priceSalesTtm: roundOffValue(selectedNum:   "${json["PriceSalesTTM"] ?? "-"}"),
    priceBookMrq: roundOffValue(selectedNum:   "${json["PriceBookMRQ"] ?? "-"}"),
    enterpriseValue: roundOffValue(selectedNum:   "${json["EnterpriseValue"] ?? "-"}"),
    enterpriseValueRevenue: roundOffValue(selectedNum:   "${json["EnterpriseValueRevenue"] ?? "-"}"),
    enterpriseValueEbitda:roundOffValue(selectedNum:    "${json["EnterpriseValueEbitda"] ?? "-"}"),
  );

  Map<String, dynamic> toJson() => {
    "TrailingPE": trailingPe,
    "ForwardPE": forwardPe,
    "PriceSalesTTM": priceSalesTtm,
    "PriceBookMRQ": priceBookMrq,
    "EnterpriseValue": enterpriseValue,
    "EnterpriseValueRevenue": enterpriseValueRevenue,
    "EnterpriseValueEbitda": enterpriseValueEbitda,
  };
}

class Earnings {
  final bool status;
  final DateTime date;
  //double epsActual;
  final String epsActual;

  Earnings({
    required this.status,
    required this.date,
    required this.epsActual,
  });

  factory Earnings.fromJson(Map<String, dynamic> json) => Earnings(
    status:json.isEmpty?false:true,
    date: json["date"]==null?DateTime.now():DateTime.parse(json["date"]),
    epsActual: roundOffValue(selectedNum:"${json["epsActual"] ?? "-"}" ),
  );

  Map<String, dynamic> toJson() => {
    "date": "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
    "epsActual": epsActual,
  };
}

class BalanceSheet {
  final bool status;
  final DateTime date;
  final Assets assets;
  final Liabilities liabilities;
  final Equity equity;
  final OthersBalanceSheet others;

  BalanceSheet({
    required this.status,
    required this.date,
    required this.assets,
    required this.liabilities,
    required this.equity,
    required this.others,
  });

  factory BalanceSheet.fromJson(Map<String, dynamic> json) => BalanceSheet(
    status:json.isEmpty?false:true,
    date: json["date"]==null?DateTime.now():DateTime.parse(json["date"]),
    assets: Assets.fromJson(json["Assets"]??{}),
    liabilities: Liabilities.fromJson(json["Liabilities"]??{}),
    equity: Equity.fromJson(json["Equity"]??{}),
    others: OthersBalanceSheet.fromJson(json["Others"]??{}),
  );

  Map<String, dynamic> toJson() => {
    "date": "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
    "Assets": assets.toJson(),
    "Liabilities": liabilities.toJson(),
    "Equity": equity.toJson(),
    "Others": others.toJson(),
  };
}

class Assets {
  final bool status;
  final String totalAssets;
  final String intangibleAssets;
  final String otherCurrentAssets;
  final String totalCurrentAssets;
  final String shortTermInvestments;
  final String netReceivables;
  final String inventory;
  final String nonCurrentAssetsOther;
  final String propertyPlantAndEquipmentNet;
  final String cashAndShortTermInvestments;

  Assets({
    required this.status,
    required this.totalAssets,
    required this.intangibleAssets,
    required this.otherCurrentAssets,
    required this.totalCurrentAssets,
    required this.shortTermInvestments,
    required this.netReceivables,
    required this.inventory,
    required this.nonCurrentAssetsOther,
    required this.propertyPlantAndEquipmentNet,
    required this.cashAndShortTermInvestments,
  });

  factory Assets.fromJson(Map<String, dynamic> json) => Assets(
    status:json.isEmpty?false:true,
    totalAssets: roundOffValue(selectedNum:json["totalAssets"]??"-"),
    intangibleAssets: roundOffValue(selectedNum:json["intangibleAssets"]??"-"),
    otherCurrentAssets: roundOffValue(selectedNum:json["otherCurrentAssets"]??"-"),
    totalCurrentAssets: roundOffValue(selectedNum:json["totalCurrentAssets"]??"-"),
    shortTermInvestments:roundOffValue(selectedNum:json["shortTermInvestments"]??"-"),
    netReceivables: roundOffValue(selectedNum:json["netReceivables"]??"-"),
    inventory:roundOffValue(selectedNum: json["inventory"]??"-"),
    nonCurrentAssetsOther: roundOffValue(selectedNum:json["nonCurrrentAssetsOther"]??"-"),
    propertyPlantAndEquipmentNet: roundOffValue(selectedNum:json["propertyPlantAndEquipmentNet"]??"-"),
    cashAndShortTermInvestments: roundOffValue(selectedNum:json["cashAndShortTermInvestments"]??"-"),
  );

  Map<String, dynamic> toJson() => {
    "totalAssets": totalAssets,
    "intangibleAssets": intangibleAssets,
    "otherCurrentAssets": otherCurrentAssets,
    "totalCurrentAssets": totalCurrentAssets,
    "shortTermInvestments": shortTermInvestments,
    "netReceivables": netReceivables,
    "inventory": inventory,
    "nonCurrrentAssetsOther": nonCurrentAssetsOther,
    "propertyPlantAndEquipmentNet": propertyPlantAndEquipmentNet,
    "cashAndShortTermInvestments": cashAndShortTermInvestments,
  };
}

class Equity {
  final bool status;
  final String totalStockholderEquity;
  final String commonStock;
  final String otherStockholderEquity;
  final String liabilitiesAndStockholdersEquity;

  Equity({
    required this.status,
    required this.totalStockholderEquity,
    required this.commonStock,
    required this.otherStockholderEquity,
    required this.liabilitiesAndStockholdersEquity,
  });

  factory Equity.fromJson(Map<String, dynamic> json) => Equity(
    status:json.isEmpty?false:true,
    totalStockholderEquity: roundOffValue(selectedNum:json["totalStockholderEquity"]??"-"),
    commonStock: roundOffValue(selectedNum:json["commonStock"]??"-"),
    otherStockholderEquity: roundOffValue(selectedNum:json["otherStockholderEquity"]??"-"),
    liabilitiesAndStockholdersEquity: roundOffValue(selectedNum:json["liabilitiesAndStockholdersEquity"]??"-"),
  );

  Map<String, dynamic> toJson() => {
    "totalStockholderEquity": totalStockholderEquity,
    "commonStock": commonStock,
    "otherStockholderEquity": otherStockholderEquity,
    "liabilitiesAndStockholdersEquity": liabilitiesAndStockholdersEquity,
  };
}

class Liabilities {
  final bool status;
  final String totalLiab;
  final String otherCurrentLiab;
  final String totalCurrentLiabilities;
  final String netDebt;
  final String shortTermDebt;
  final String shortLongTermDebtTotal;
  final String longTermDebt;
  final String accountsPayable;
  final String capitalLeaseObligations;
  final String nonCurrentLiabilitiesTotal;

  Liabilities({
    required this.status,
    required this.totalLiab,
    required this.otherCurrentLiab,
    required this.totalCurrentLiabilities,
    required this.netDebt,
    required this.shortTermDebt,
    required this.shortLongTermDebtTotal,
    required this.longTermDebt,
    required this.accountsPayable,
    required this.capitalLeaseObligations,
    required this.nonCurrentLiabilitiesTotal,
  });

  factory Liabilities.fromJson(Map<String, dynamic> json) => Liabilities(
    status:json.isEmpty?false:true,
    totalLiab: roundOffValue(selectedNum:json["totalLiab"]??"-"),
    otherCurrentLiab: roundOffValue(selectedNum:json["otherCurrentLiab"]??"-"),
    totalCurrentLiabilities: roundOffValue(selectedNum:json["totalCurrentLiabilities"]??"-"),
    netDebt: roundOffValue(selectedNum:json["netDebt"]??"-"),
    shortTermDebt: roundOffValue(selectedNum:json["shortTermDebt"]??"-"),
    shortLongTermDebtTotal: roundOffValue(selectedNum:json["shortLongTermDebtTotal"]??"-"),
    longTermDebt: roundOffValue(selectedNum:json["longTermDebt"]??"-"),
    accountsPayable: roundOffValue(selectedNum:json["accountsPayable"]??"-"),
    capitalLeaseObligations: roundOffValue(selectedNum:json["capitalLeaseObligations"]??"-"),
    nonCurrentLiabilitiesTotal: roundOffValue(selectedNum:json["nonCurrentLiabilitiesTotal"]??"-"),
  );

  Map<String, dynamic> toJson() => {
    "totalLiab": totalLiab,
    "otherCurrentLiab": otherCurrentLiab,
    "totalCurrentLiabilities": totalCurrentLiabilities,
    "netDebt": netDebt,
    "shortTermDebt": shortTermDebt,
    "shortLongTermDebtTotal": shortLongTermDebtTotal,
    "longTermDebt": longTermDebt,
    "accountsPayable": accountsPayable,
    "capitalLeaseObligations": capitalLeaseObligations,
    "nonCurrentLiabilitiesTotal": nonCurrentLiabilitiesTotal,
  };
}

class OthersBalanceSheet {
  final bool status;
  final String netWorkingCapital;
  final String netInvestedCapital;
  final String commonStockSharesOutstanding;

  OthersBalanceSheet({
    required this.status,
    required this.netWorkingCapital,
    required this.netInvestedCapital,
    required this.commonStockSharesOutstanding,
  });

  factory OthersBalanceSheet.fromJson(Map<String, dynamic> json) => OthersBalanceSheet(
    status:json.isEmpty?false:true,
    netWorkingCapital: json["netWorkingCapital"]??"-",
    netInvestedCapital: json["netInvestedCapital"]??"-",
    commonStockSharesOutstanding: json["commonStockSharesOutstanding"]??"-",
  );

  Map<String, dynamic> toJson() => {
    "netWorkingCapital": netWorkingCapital,
    "netInvestedCapital": netInvestedCapital,
    "commonStockSharesOutstanding": commonStockSharesOutstanding,
  };
}

class CashFlow {
  final bool status;
  final DateTime date;
  final Operating operating;
  final Investing investing;
  final Financing financing;
  final OthersCashFlow othersCashFlow;

  CashFlow({
    required this.status,
    required this.date,
    required this.operating,
    required this.investing,
    required this.financing,
    required this.othersCashFlow,
  });

  factory CashFlow.fromJson(Map<String, dynamic> json) => CashFlow(
    status:json.isEmpty?false:true,
    date: json["date"]==null?DateTime.now():DateTime.parse(json["date"]),
    operating: Operating.fromJson(json["Operating"]??{}),
    investing: Investing.fromJson(json["Investing"]??{}),
    financing: Financing.fromJson(json["Financing"]??{}),
    othersCashFlow: OthersCashFlow.fromJson(json["OthersCashFlow"]??{}),
  );

  Map<String, dynamic> toJson() => {
    "date": "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
    "Operating": operating.toJson(),
    "Investing": investing.toJson(),
    "Financing": financing.toJson(),
    "OthersCashFlow": othersCashFlow.toJson(),
  };
}

class Financing {
  final bool status;
  final String dividendsPaid;
  final String issuanceOfCapitalStock;
  final String salePurchaseOfStock;
  final String netBorrowings;
  final String totalCashFromFinancingActivities;

  Financing({
    required this.status,
    required this.dividendsPaid,
    required this.issuanceOfCapitalStock,
    required this.salePurchaseOfStock,
    required this.netBorrowings,
    required this.totalCashFromFinancingActivities,
  });

  factory Financing.fromJson(Map<String, dynamic> json) => Financing(
    status:json.isEmpty?false:true,
    dividendsPaid: roundOffValue(selectedNum:json["dividendsPaid"]??"-"),
    issuanceOfCapitalStock: roundOffValue(selectedNum:json["issuanceOfCapitalStock"]??"-"),
    salePurchaseOfStock: roundOffValue(selectedNum:json["salePurchaseOfStock"]??"-"),
    netBorrowings: roundOffValue(selectedNum:"${json["netBorrowings"]??"-"}"),
    totalCashFromFinancingActivities: roundOffValue(selectedNum:json["totalCashFromFinancingActivities"]??"-"),
  );

  Map<String, dynamic> toJson() => {
    "dividendsPaid": dividendsPaid,
    "issuanceOfCapitalStock": issuanceOfCapitalStock,
    "salePurchaseOfStock": salePurchaseOfStock,
    "netBorrowings": netBorrowings,
    "totalCashFromFinancingActivities": totalCashFromFinancingActivities,
  };
}

class Investing {
  final bool status;
  final String investments;
  final String capitalExpenditures;
  final String totalCashFlowsFromInvestingActivities;

  Investing({
    required this.status,
    required this.investments,
    required this.capitalExpenditures,
    required this.totalCashFlowsFromInvestingActivities,
  });

  factory Investing.fromJson(Map<String, dynamic> json) => Investing(
    status:json.isEmpty?false:true,
    investments: roundOffValue(selectedNum:json["investments"]??"-"),
    capitalExpenditures: roundOffValue(selectedNum:json["capitalExpenditures"]??"-"),
    totalCashFlowsFromInvestingActivities: roundOffValue(selectedNum:json["totalCashflowsFromInvestingActivities"]??"-"),
  );

  Map<String, dynamic> toJson() => {
    "investments": investments,
    "capitalExpenditures": capitalExpenditures,
    "totalCashflowsFromInvestingActivities": totalCashFlowsFromInvestingActivities,
  };
}

class Operating {
  final bool status;
  final String netIncome;
  final String depreciation;
  final String changeInWorkingCapital;
  final String totalCashFromOperatingActivities;

  Operating({
    required this.status,
    required this.netIncome,
    required this.depreciation,
    required this.changeInWorkingCapital,
    required this.totalCashFromOperatingActivities,
  });

  factory Operating.fromJson(Map<String, dynamic> json) => Operating(
    status:json.isEmpty?false:true,
    netIncome: roundOffValue(selectedNum:json["netIncome"]??"-"),
    depreciation:roundOffValue(selectedNum: json["depreciation"]??"-"),
    changeInWorkingCapital: roundOffValue(selectedNum:json["changeInWorkingCapital"]??"-"),
    totalCashFromOperatingActivities: roundOffValue(selectedNum:json["totalCashFromOperatingActivities"]??"-"),
  );

  Map<String, dynamic> toJson() => {
    "netIncome": netIncome,
    "depreciation": depreciation,
    "changeInWorkingCapital": changeInWorkingCapital,
    "totalCashFromOperatingActivities": totalCashFromOperatingActivities,
  };
}

class OthersCashFlow {
  final bool status;
  final String changeInCash;
  final String beginPeriodCashFlow;
  final String endPeriodCashFlow;
  final String freeCashFlow;

  OthersCashFlow({
    required this.status,
    required this.changeInCash,
    required this.beginPeriodCashFlow,
    required this.endPeriodCashFlow,
    required this.freeCashFlow,
  });

  factory OthersCashFlow.fromJson(Map<String, dynamic> json) => OthersCashFlow(
    status:json.isEmpty?false:true,
    changeInCash: json["changeInCash"]??'-',
    beginPeriodCashFlow: json["beginPeriodCashFlow"]??"-",
    endPeriodCashFlow: json["endPeriodCashFlow"]??"-",
    freeCashFlow: json["freeCashFlow"]??"-",
  );

  Map<String, dynamic> toJson() => {
    "changeInCash": changeInCash,
    "beginPeriodCashFlow": beginPeriodCashFlow,
    "endPeriodCashFlow": endPeriodCashFlow,
    "freeCashFlow": freeCashFlow,
  };
}

class IncomeStatement {
  final bool status;
  final DateTime date;
  final RevenueCostOfRevenue revenueCostOfRevenue;
  final OperatingExpenses operatingExpenses;
  final NonOperatingExpenses nonOperatingExpenses;
  final Profitability profitability;

  IncomeStatement({
    required this.status,
    required this.date,
    required this.revenueCostOfRevenue,
    required this.operatingExpenses,
    required this.nonOperatingExpenses,
    required this.profitability,
  });

  factory IncomeStatement.fromJson(Map<String, dynamic> json) => IncomeStatement(
    status:json.isEmpty?false:true,
    date: json["date"]==null?DateTime.now():DateTime.parse(json["date"]),
    revenueCostOfRevenue: RevenueCostOfRevenue.fromJson(json["Revenue__Cost_of_Revenue"]??{}),
    operatingExpenses: OperatingExpenses.fromJson(json["Operating_Expenses"]??{}),
    nonOperatingExpenses: NonOperatingExpenses.fromJson(json["Non_Operating_Expenses"]??{}),
    profitability: Profitability.fromJson(json["Profitability"]??{}),
  );

  Map<String, dynamic> toJson() => {
    "date": "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
    "Revenue__Cost_of_Revenue": revenueCostOfRevenue.toJson(),
    "Operating_Expenses": operatingExpenses.toJson(),
    "Non_Operating_Expenses": nonOperatingExpenses.toJson(),
    "Profitability": profitability.toJson(),
  };
}

class NonOperatingExpenses {
  final bool status;
  final String interestExpense;
  final String totalOtherIncomeExpenseNet;

  NonOperatingExpenses({
    required this.status,
    required this.interestExpense,
    required this.totalOtherIncomeExpenseNet,
  });

  factory NonOperatingExpenses.fromJson(Map<String, dynamic> json) => NonOperatingExpenses(
    status:json.isEmpty?false:true,
    interestExpense: roundOffValue(selectedNum:json["interestExpense"]??"-"),
    totalOtherIncomeExpenseNet: roundOffValue(selectedNum:json["totalOtherIncomeExpenseNet"]??"-"),
  );

  Map<String, dynamic> toJson() => {
    "interestExpense": interestExpense,
    "totalOtherIncomeExpenseNet": totalOtherIncomeExpenseNet,
  };
}

class OperatingExpenses {
  final bool status;
  final String sellingGeneralAdministrative;
  final String totalOperatingExpenses;
  final String operatingIncome;

  OperatingExpenses({
    required this.status,
    required this.sellingGeneralAdministrative,
    required this.totalOperatingExpenses,
    required this.operatingIncome,
  });

  factory OperatingExpenses.fromJson(Map<String, dynamic> json) => OperatingExpenses(
    status:json.isEmpty?false:true,
    sellingGeneralAdministrative: roundOffValue(selectedNum:json["sellingGeneralAdministrative"]??"-"),
    totalOperatingExpenses:roundOffValue(selectedNum: json["totalOperatingExpenses"]??'-'),
    operatingIncome: roundOffValue(selectedNum:json["operatingIncome"]??"-"),
  );

  Map<String, dynamic> toJson() => {
    "sellingGeneralAdministrative": sellingGeneralAdministrative,
    "totalOperatingExpenses": totalOperatingExpenses,
    "operatingIncome": operatingIncome,
  };
}

class Profitability {
  final bool status;
  final String ebit;
  final String ebitda;
  final String incomeBeforeTax;
  final String incomeTaxExpense;
  final String netIncomeFromContinuingOps;
  final String netIncome;

  Profitability({
    required this.status,
    required this.ebit,
    required this.ebitda,
    required this.incomeBeforeTax,
    required this.incomeTaxExpense,
    required this.netIncomeFromContinuingOps,
    required this.netIncome,
  });

  factory Profitability.fromJson(Map<String, dynamic> json) => Profitability(
    status:json.isEmpty?false:true,
    ebit: roundOffValue(selectedNum:json["ebit"]??"-"),
    ebitda: roundOffValue(selectedNum:json["ebitda"]??"-"),
    incomeBeforeTax: roundOffValue(selectedNum:json["incomeBeforeTax"]??"-"),
    incomeTaxExpense: roundOffValue(selectedNum:json["incomeTaxExpense"]??"-"),
    netIncomeFromContinuingOps: roundOffValue(selectedNum:json["netIncomeFromContinuingOps"]??"-"),
    netIncome:roundOffValue(selectedNum: json["netIncome"]??"-"),
  );

  Map<String, dynamic> toJson() => {
    "ebit": ebit,
    "ebitda": ebitda,
    "incomeBeforeTax": incomeBeforeTax,
    "incomeTaxExpense": incomeTaxExpense,
    "netIncomeFromContinuingOps": netIncomeFromContinuingOps,
    "netIncome": netIncome,
  };
}

class RevenueCostOfRevenue {
  final bool status;
  final String totalRevenue;
  final String costOfRevenue;
  final String grossProfit;

  RevenueCostOfRevenue({
    required this.status,
    required this.totalRevenue,
    required this.costOfRevenue,
    required this.grossProfit,
  });

  factory RevenueCostOfRevenue.fromJson(Map<String, dynamic> json) => RevenueCostOfRevenue(
    status:json.isEmpty?false:true,
    totalRevenue: roundOffValue(selectedNum:json["totalRevenue"]??"-"),
    costOfRevenue: roundOffValue(selectedNum:json["costOfRevenue"]??"-"),
    grossProfit: roundOffValue(selectedNum:json["grossProfit"]??"-"),
  );

  Map<String, dynamic> toJson() => {
    "totalRevenue": totalRevenue,
    "costOfRevenue": costOfRevenue,
    "grossProfit": grossProfit,
  };
}





String roundOffValue({required String selectedNum}) {
  String finalValue="";
  if(selectedNum=="-"){
    finalValue=selectedNum;
  }else{
    String referenceNum=((num.parse(selectedNum)).toInt()).toString();
    int lengthValue=referenceNum.length;
    if(lengthValue>=5&&lengthValue<=7){
      selectedNum=((num.parse(selectedNum)).toInt()).toString();
      String x=(int.parse(selectedNum)/100000).toStringAsFixed(0);
      finalValue="$x Lakhs";
    }
    else if(lengthValue>7){
      selectedNum=((num.parse(selectedNum)).toInt()).toString();
      String x=(int.parse(selectedNum)/10000000).toStringAsFixed(0);
      finalValue="$x Crores";
    }
    else{
      finalValue=selectedNum;
    }
  }
  return finalValue;
}






