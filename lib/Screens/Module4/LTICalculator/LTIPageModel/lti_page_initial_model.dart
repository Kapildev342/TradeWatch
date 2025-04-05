import 'dart:convert';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:get/get.dart';

LTIPageInitialModel ltiTickerDataApiModelFromJson(String str) => LTIPageInitialModel.fromJson(json.decode(str));

String ltiTickerDataApiModelToJson(LTIPageInitialModel data) => json.encode(data.toJson());

class LTIPageInitialModel {
  Rx<DateTime> selectedDate;
  RxString category;
  RxString tickerId;
  RxString tickerName;
  Rx<double> purchaseValue;
  Rx<double> purchaseDateCloseValue;
  Rx<double> shares;
  Rx<double> sliderValue;
  Rx<TickerDetails> tickerDetails;
  Rx<LTIValues> ltiValues;
  RxList<SplitsList> splitsList;
  RxList<DividendList> dividendList;
  CalendarController calController;

  LTIPageInitialModel({
    required this.selectedDate,
    required this.category,
    required this.tickerId,
    required this.tickerName,
    required this.purchaseValue,
    required this.purchaseDateCloseValue,
    required this.shares,
    required this.sliderValue,
    required this.tickerDetails,
    required this.ltiValues,
    required this.splitsList,
    required this.dividendList,
    required this.calController,
  });

  factory LTIPageInitialModel.fromJson(Map<String, dynamic> json) => LTIPageInitialModel(
        selectedDate: DateTime.parse("${json["selected_date"] ?? DateTime.now()}").obs,
        category: "${json["category"] ?? ""}".obs,
        tickerId: "${json["ticker_id"] ?? ""}".obs,
        tickerName: "${json["ticker_name"] ?? ""}".obs,
        purchaseValue: double.parse("${json["purchase_value"] ?? 0.0}").obs,
        purchaseDateCloseValue: double.parse("${json["purchase_date_close_value"] ?? 0.0}").obs,
        shares: double.parse("${json["shares"] ?? 0.0}").obs,
        sliderValue: double.parse("${json["slider_value"] ?? 0.0}").obs,
        tickerDetails: TickerDetails.fromJson(json["ticker_details"] ?? {}).obs,
        ltiValues: LTIValues.fromJson(json["lti_values"] ?? {}).obs,
        splitsList: RxList<SplitsList>.from((json["splits_list"] ?? []).map((x) => SplitsList.fromJson(x))),
        dividendList: RxList<DividendList>.from((json["dividend_list"] ?? []).map((x) => DividendList.fromJson(x))),
        calController: json["cal_controller"] ?? CalendarController(),
      );

  Map<String, dynamic> toJson() => {
        "selected_date": selectedDate,
        "category": category,
        "ticker_id": tickerId,
        "ticker_name": tickerName,
        "purchase_value": purchaseValue,
        "purchase_date_close_value": purchaseDateCloseValue,
        "shares": shares,
        "slider_value": sliderValue,
        "ticker_details": tickerDetails.toJson(),
        "lti_values": ltiValues.toJson(),
        "splits_list": List<dynamic>.from(splitsList.map((x) => x.toJson())),
        "dividend_list": List<dynamic>.from(dividendList.map((x) => x.toJson())),
        "cal_controller": calController,
      };
}

class DividendList {
  RxString id;
  RxString code;
  RxString name;
  RxString category;
  RxString exchange;
  RxString industry;
  RxString exchangeId;
  RxString categoryId;
  RxString industryId;
  RxString tickerId;
  Rx<DateTime> date;
  Rx<double> value;
  Rx<double> unadjustedValue;
  RxString currency;
  Rx<int> status;
  RxString createdAt;
  RxString updatedAt;

  DividendList({
    required this.id,
    required this.code,
    required this.name,
    required this.category,
    required this.exchange,
    required this.industry,
    required this.exchangeId,
    required this.categoryId,
    required this.industryId,
    required this.tickerId,
    required this.date,
    required this.value,
    required this.unadjustedValue,
    required this.currency,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory DividendList.fromJson(Map<String, dynamic> json) => DividendList(
        id: "${json["_id"] ?? ""}".obs,
        code: "${json["code"] ?? ""}".obs,
        name: "${json["name"] ?? ""}".obs,
        category: "${json["category"] ?? ""}".obs,
        exchange: "${json["exchange"] ?? ""}".obs,
        industry: "${json["industry"] ?? ""}".obs,
        exchangeId: "${json["exchange_id"] ?? ""}".obs,
        categoryId: "${json["category_id"] ?? ""}".obs,
        industryId: "${json["industry_id"] ?? ""}".obs,
        tickerId: "${json["ticker_id"] ?? ""}".obs,
        date: DateTime.parse("${json["date"] ?? ""}").obs,
        value: double.parse("${json["value"] ?? 0.0}").obs,
        unadjustedValue: double.parse("${json["unadjustedValue"] ?? 0.0}").obs,
        currency: "${json["currency"] ?? ""}".obs,
        status: int.parse("${json["status"] ?? 0}").obs,
        createdAt: "${json["createdAt"] ?? ""}".obs,
        updatedAt: "${json["updatedAt"] ?? ""}".obs,
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "code": code,
        "name": name,
        "category": category,
        "exchange": exchange,
        "industry": industry,
        "exchange_id": exchangeId,
        "category_id": categoryId,
        "industry_id": industryId,
        "ticker_id": tickerId,
        "date": date,
        "value": value,
        "unadjustedValue": unadjustedValue,
        "currency": currency,
        "status": status,
        "createdAt": createdAt,
        "updatedAt": updatedAt,
      };
}

class LTIValues {
  Rx<double> totalInvestmentValue;
  Rx<double> totalInvestmentPercent;
  Rx<bool> totalInvestmentPercentStatus;
  Rx<double> noOfShares;
  Rx<double> noOfSharesPercent;
  Rx<bool> noOfSharesPercentStatus;
  Rx<bool> isSplitsAvailable;
  Rx<double> totalDividendEarnings;
  Rx<bool> isDividendsAvailable;

  LTIValues({
    required this.totalInvestmentValue,
    required this.totalInvestmentPercent,
    required this.totalInvestmentPercentStatus,
    required this.noOfShares,
    required this.noOfSharesPercent,
    required this.noOfSharesPercentStatus,
    required this.isSplitsAvailable,
    required this.totalDividendEarnings,
    required this.isDividendsAvailable,
  });

  factory LTIValues.fromJson(Map<String, dynamic> json) => LTIValues(
        totalInvestmentValue: double.parse("${json["total_investment_value"] ?? 0.0}").obs,
        totalInvestmentPercent: double.parse("${json["total_investment_percent"] ?? 0.0}").obs,
        totalInvestmentPercentStatus: (json["total_investment_percent_status"] == null
                ? false
                : json["total_investment_percent_status"] == true
                    ? true
                    : false)
            .obs,
        noOfShares: double.parse("${json["no_of_shares"] ?? 0.0}").obs,
        noOfSharesPercent: double.parse("${json["no_of_shares_percent"] ?? 0.0}").obs,
        noOfSharesPercentStatus: (json["no_of_shares_percent_status"] == null
                ? false
                : json["no_of_shares_percent_status"] == true
                    ? true
                    : false)
            .obs,
        isSplitsAvailable: (json["is_splits_available"] == null
                ? false
                : json["is_splits_available"] == true
                    ? true
                    : false)
            .obs,
        totalDividendEarnings: double.parse("${json["total_dividend_earnings"] ?? 0.0}").obs,
        isDividendsAvailable: (json["is_dividend_available"] == null
                ? false
                : json["is_dividend_available"] == true
                    ? true
                    : false)
            .obs,
      );

  Map<String, dynamic> toJson() => {
        "total_investment_value": totalInvestmentValue,
        "total_investment_percent": totalInvestmentPercent,
        "total_investment_percent_status": totalInvestmentPercentStatus,
        "no_of_shares": noOfShares,
        "no_of_shares_percent": noOfSharesPercent,
        "no_of_shares_percent_status": noOfSharesPercentStatus,
        "is_splits_available": isSplitsAvailable,
        "total_dividend_earnings": totalDividendEarnings,
        "is_dividend_available": isDividendsAvailable,
      };
}

class SplitsList {
  RxString id;
  RxString code;
  RxString name;
  RxString category;
  RxString exchange;
  RxString industry;
  RxString exchangeId;
  RxString categoryId;
  RxString industryId;
  RxString tickerId;
  Rx<DateTime> splitDate;
  RxString optionCount;
  Rx<int> oldShares;
  Rx<int> newShares;
  Rx<int> status;
  RxString createdAt;
  RxString updatedAt;

  SplitsList({
    required this.id,
    required this.code,
    required this.name,
    required this.category,
    required this.exchange,
    required this.industry,
    required this.exchangeId,
    required this.categoryId,
    required this.industryId,
    required this.tickerId,
    required this.splitDate,
    required this.optionCount,
    required this.oldShares,
    required this.newShares,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory SplitsList.fromJson(Map<String, dynamic> json) => SplitsList(
        id: "${json["_id"] ?? ""}".obs,
        code: "${json["code"] ?? ""}".obs,
        name: "${json["name"] ?? ""}".obs,
        category: "${json["category"] ?? ""}".obs,
        exchange: "${json["exchange"] ?? ""}".obs,
        industry: "${json["industry"] ?? ""}".obs,
        exchangeId: "${json["exchange_id"] ?? ""}".obs,
        categoryId: "${json["category_id"] ?? ""}".obs,
        industryId: "${json["industry_id"] ?? ""}".obs,
        tickerId: "${json["ticker_id"] ?? ""}".obs,
        splitDate: DateTime.parse("${json["split_date"] ?? ""}").obs,
        optionCount: "${json["optionable"] ?? ""}".obs,
        oldShares: int.parse("${json["old_shares"] ?? 0.0}").obs,
        newShares: int.parse("${json["new_shares"] ?? 0.0}").obs,
        status: int.parse("${json["status"] ?? 0.0}").obs,
        createdAt: "${json["createdAt"] ?? ""}".obs,
        updatedAt: "${json["updatedAt"] ?? ""}".obs,
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "code": code,
        "name": name,
        "category": category,
        "exchange": exchange,
        "industry": industry,
        "exchange_id": exchangeId,
        "category_id": categoryId,
        "industry_id": industryId,
        "ticker_id": tickerId,
        "split_date": splitDate,
        "optionable": optionCount,
        "old_shares": oldShares,
        "new_shares": newShares,
        "status": status,
        "createdAt": createdAt,
        "updatedAt": updatedAt,
      };
}

class TickerDetails {
  RxString id;
  RxString exchange;
  RxString code;
  RxString cryptoCode;
  RxString name;
  RxString country;
  RxString currency;
  RxString type;
  RxString category;
  RxString industry;
  RxString logoUrl;
  Rx<double> changeP;
  Rx<double> close;

  TickerDetails({
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

  factory TickerDetails.fromJson(Map<String, dynamic> json) => TickerDetails(
        id: "${json["_id"] ?? ""}".obs,
        exchange: "${json["exchange"] ?? ""}".obs,
        code: "${json["code"] ?? ""}".obs,
        cryptoCode: "${json["crypto_code"] ?? ""}".obs,
        name: "${json["name"] ?? ""}".obs,
        country: "${json["country"] ?? ""}".obs,
        currency: "${json["currency"] ?? ""}".obs,
        type: "${json["type"] ?? ""}".obs,
        category: "${json["category"] ?? ""}".obs,
        industry: "${json["industry"] ?? ""}".obs,
        logoUrl: "${json["logo_url"] ?? ""}".obs,
        changeP: double.parse("${json["change_p"] ?? 0.0}").obs,
        close: double.parse("${json["close"] ?? 0.0}").obs,
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
