
import 'dart:convert';

CalculatorPageInitialModel calculatorPageInitialModelFromJson(String str) => CalculatorPageInitialModel.fromJson(json.decode(str));

String calculatorPageInitialModelToJson(CalculatorPageInitialModel data) => json.encode(data.toJson());

class CalculatorPageInitialModel {
  final bool status;
  final String message;
  final Response response;
  final CurrencyChange currencyChange;

  CalculatorPageInitialModel({
    required this.status,
    required this.message,
    required this.response,
    required this.currencyChange,
  });

  factory CalculatorPageInitialModel.fromJson(Map<String, dynamic> json) => CalculatorPageInitialModel(
    status: json["status"]??false,
    message: json["message"]??"",
    response: Response.fromJson(json["response"]??{}),
    currencyChange: CurrencyChange.fromJson(json["currency_change"]??{}),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "response": response.toJson(),
    "currency_change": currencyChange.toJson(),
  };
}

class CurrencyChange {
  final String id;
  final String code;
  final String name;
  final double close;

  CurrencyChange({
    required this.id,
    required this.code,
    required this.name,
    required this.close,
  });

  factory CurrencyChange.fromJson(Map<String, dynamic> json) => CurrencyChange(
    id: json["_id"]??"",
    code: json["code"]??"",
    name: json["name"]??"",
    close: json["close"]==null?0.0:json["close"].toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "code": code,
    "name": name,
    "close": close,
  };
}

class Response {
  final double amount;
  final String currency;
  final List<Ticker> tickers;

  Response({
    required this.amount,
    required this.currency,
    required this.tickers,
  });

  factory Response.fromJson(Map<String, dynamic> json) => Response(
    amount: json["amount"]==null?0.0:json["amount"].toDouble(),
    currency: json["currency"]??"",
    tickers: json["tickers"]==null?[]:List<Ticker>.from(json["tickers"].map((x) => Ticker.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "amount": amount,
    "currency": currency,
    "tickers": List<dynamic>.from(tickers.map((x) => x.toJson())),
  };
}

class Ticker {
  final String id;
  final String exchange;
  final String code;
  final String cryptoCode;
  final String name;
  final String country;
  final String currency;
  final String type;
  final String category;
  final String industry;
  final String logoUrl;
  final double changeP;
  final double close;

  Ticker({
    required this.id,
    required this.exchange,
    required this.code,
    required this.cryptoCode,
    required this.name,
    required this.country,
    required this.currency,
    required this.type,
    required this.category,
    required this.industry,
    required this.logoUrl,
    required this.changeP,
    required this.close,
  });

  factory Ticker.fromJson(Map<String, dynamic> json) => Ticker(
    id: json["_id"]??"",
    exchange: json["exchange"]??"",
    code: json["code"]??"",
    cryptoCode: json["crypto_code"]??"",
    name: json["name"]??'',
    country: json["country"]??"",
    currency: json["currency"]??"",
    type: json["type"]??"",
    category: json["category"]??"",
    industry: json["industry"]??"",
    logoUrl: json["logo_url"]??"",
    changeP: json["change_p"]==null?0.0:json["change_p"].toDouble(),
    close: json["close"]==null?0.0:json["close"].toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "exchange": exchange,
    "code": code,
    "crypto_code": cryptoCode,
    "name": name,
    "country": country,
    "currency": currency,
    "type": type,
    "category": category,
    "industry": industry,
    "logo_url": logoUrl,
    "change_p": changeP,
    "close": close,
  };
}
