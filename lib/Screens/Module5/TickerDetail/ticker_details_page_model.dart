
import 'dart:convert';

TickerDetailsPageModel tickerDetailsPageModelFromJson(String str) => TickerDetailsPageModel.fromJson(json.decode(str));

String tickerDetailsPageModelToJson(TickerDetailsPageModel data) => json.encode(data.toJson());

class TickerDetailsPageModel {
  final bool status;
  final String message;
  final Response response;

  TickerDetailsPageModel({
    required this.status,
    required this.message,
    required this.response,
  });

  factory TickerDetailsPageModel.fromJson(Map<String, dynamic> json) => TickerDetailsPageModel(
    status: json["status"]??false,
    message: json["message"]??"",
    response: Response.fromJson(json["response"]??{}),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "response": response.toJson(),
  };
}

class Response {
  final String type;
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
  final Address address;
  final double changeP;
  final double close;
  final int previousClose;
  final double weekLow;
  final double weekHigh;
  final String webUrl;
  final double marketCapitalizationMln;
  final int circulatingSupply;
  final String epse;
  final double sharesMln;
  final int ebitDa;
  final double peRatio;
  final String pegRatio;
  final int revenueTtm;
  final String dividend;
  final String exdividendDate;
  final String dividendDate;
  final String forwardAnnualDividendYield;
  final List<Trading> trading;

  Response({
    required this.type,
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
    required this.address,
    required this.changeP,
    required this.close,
    required this.previousClose,
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
    required this.trading,
  });

  factory Response.fromJson(Map<String, dynamic> json) => Response(
    type: json["type"]??"",
    exchange: json["exchange"]??"",
    tvSymbol: json["tv_symbol"]??'',
    code: json["code"]??"",
    name: json["name"]??'',
    country: json["country"]??"",
    category: json["category"]??"",
    industry: json["industry"]??"",
    logoUrl: json["logo_url"]??"",
    tickerName: json["ticker_name"]??"",
    description: json["description"]??"",
    fullAddress: json["full_address"]??"",
    address: Address.fromJson(json["address"]??{}),
    changeP: json["change_p"]==null?0.0:json["change_p"].toDouble(),
    close: json["close"]==null?0.0:json["close"].toDouble(),
    previousClose: json["previous_close"]??0,
    weekLow: json["week_low"]==null?0.0:json["week_low"].toDouble(),
    weekHigh: json["week_high"]==null?0.0:json["week_high"].toDouble(),
    webUrl: json["web_url"]??"",
    marketCapitalizationMln: json["market_capitalization_mln"]==null?0.0:json["market_capitalization_mln"].toDouble(),
    circulatingSupply: json["circulating_supply"]??0,
    epse: json["epse"]??"",
    sharesMln: json["shares_mln"]==null?0.0:json["shares_mln"].toDouble(),
    ebitDa: json["ebit_da"]??0,
    peRatio: json["pe_ratio"]==null?0.0:json["pe_ratio"].toDouble(),
    pegRatio: json["peg_ratio"]??"",
    revenueTtm: json["revenue_ttm"]??0,
    dividend: json["dividend"]??"",
    exdividendDate: json["exdividend_date"]??"",
    dividendDate: json["dividend_date"]??"",
    forwardAnnualDividendYield: json["forward_annual_dividend_yield"]??"",
    trading: json["trading"]==null?[]:List<Trading>.from(json["trading"].map((x) => Trading.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "type": type,
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
    "address": address.toJson(),
    "change_p": changeP,
    "close": close,
    "previous_close": previousClose,
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
    "dividend_date": dividendDate,
    "forward_annual_dividend_yield": forwardAnnualDividendYield,
    "trading": List<dynamic>.from(trading.map((x) => x.toJson())),
  };
}

class Address {
  final String street;
  final String city;
  final String country;
  final String zip;

  Address({
    required this.street,
    required this.city,
    required this.country,
    required this.zip,
  });

  factory Address.fromJson(Map<String, dynamic> json) => Address(
    street: json["Street"]??"",
    city: json["City"]??"",
    country: json["Country"]??"",
    zip: json["ZIP"]??"",
  );

  Map<String, dynamic> toJson() => {
    "Street": street,
    "City": city,
    "Country": country,
    "ZIP": zip,
  };
}

class Trading {
  final String id;
  final double open;
  final double high;
  final double low;
  final double close;
  final String tradingDateTime;
  final double changeP;
  final double change;
  final String createdAt;

  Trading({
    required this.id,
    required this.open,
    required this.high,
    required this.low,
    required this.close,
    required this.tradingDateTime,
    required this.changeP,
    required this.change,
    required this.createdAt,
  });

  factory Trading.fromJson(Map<String, dynamic> json) => Trading(
    id: json["_id"]??"",
    open: json["open"]==null?0.0:json["open"].toDouble(),
    high: json["high"]==null?0.0:json["high"].toDouble(),
    low: json["low"]==null?0.0:json["low"].toDouble(),
    close: json["close"]==null?0.0:json["close"].toDouble(),
    tradingDateTime: json["trading_date_time"]??"",
    changeP: json["change_p"]==null?0.0:json["change_p"].toDouble(),
    change: json["change"]==null?0.0:json["change"].toDouble(),
    createdAt: json["createdAt"]??"",
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "open": open,
    "high": high,
    "low": low,
    "close": close,
    "trading_date_time": tradingDateTime,
    "change_p": changeP,
    "change": change,
    "createdAt": createdAt,
  };
}
