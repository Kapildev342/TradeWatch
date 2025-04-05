import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:tradewatchfinal/Constants/API/api.dart';
import 'package:tradewatchfinal/Screens/Module1/bottom_navigation.dart';
import 'home_search_model.dart';
import 'home_search_ticker_model.dart';

class HomeScreenFunctions {
  getTickerValues() async {
    var url = Uri.parse(baseurl + versionHome + homeTickers);
    var response = await http.post(url, body: {'search': homeVariables.searchControllerMain.value.text});
    var responseData123 = jsonDecode(response.body);
    homeVariables.homeSearchTickerDataMain.value = HomeSearchTickerModel.fromJson(responseData123);
    homeVariables.homeSearchTickerDataMain.refresh();
  }

  getSearchValue({required String skipLimit}) async {
    var response = await http.post(
      Uri.parse(baseurl + versionHome + search),
      body: {
        'search': homeVariables.searchControllerMain.value.text,
        'type': homeVariables.searchTabType.value,
        'skip': skipLimit,
        'limit': "10",
      },
    );
    Map<String, dynamic> responseData = jsonDecode(response.body);
    homeVariables.homeSearchDataMain = (HomeSearchModel.fromJson(responseData)).obs;
  }

  /* getIdDataSearch({required String id,
    required StateSetter modelSetState,
    required String type}) async {
    Map<String, dynamic> data = {};
    var url = Uri.parse(baseurl + versionLocker + idGetData);
    data = {"id": id,
      "type": type,
      "search_key": homeVariables.searchControllerMain.value.text};
    var response = await http.post(url, headers: {'Authorization': kToken}, body: data);
    var responseData = json.decode(response.body);
    if (responseData["status"]) {
      modelSetState(() {
        forumCategory = responseData["response"]["category"];
      });
    }
  }*/

  /*getIdData({
    required String id,
    required StateSetter modelSetState,
    required String type}) async {
    var url = Uri.parse(baseurl + versionLocker + idGetData);
    var response = await http.post(url, headers: {
      'Authorization': kToken
    }, body: {
      "id": id,
      "type": type,
    });
    var responseData = json.decode(response.body);
    if (responseData["status"]) {
      modelSetState(() {
        forumCategory = responseData["response"]["category"];
      });
    }
  }*/

  getStatusFunc({required String surveyId}) async {
    var url = Uri.parse(baseurl + versionSurvey + surveyStatusCheck);
    var response = await http.post(url, headers: {
      'Authorization': kToken
    }, body: {
      'survey_id': surveyId,
    });
    var responseData = json.decode(response.body);
    if (responseData["status"]) {
      homeVariables.activeStatusMain.value = responseData["response"]["status"];

      if (homeVariables.activeStatusMain.value == "active") {
        var url = Uri.parse(baseurl + versionSurvey + checkAnswer);
        var response = await http.post(url, headers: {
          'Authorization': kToken
        }, body: {
          'survey_id': surveyId,
        });
        var responseData = json.decode(response.body);
        if (responseData["status"]) {
          homeVariables.answerStatusMain.value = responseData["response"][0]["final_question"];
          homeVariables.answeredQuestionMain.value = responseData["response"][0]["question_number"];
        } else {
          homeVariables.answerStatusMain.value = false;
          homeVariables.answeredQuestionMain.value = 0;
        }
      }
    }
  }
}
