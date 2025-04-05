import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:tradewatchfinal/Constants/API/api.dart';
import 'language_list_model.dart';
import 'package:http/http.dart' as http;

class LanguageFunction {
  Future<LanguageListModel> getData({required String type}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String mainUserToken = prefs.getString('newUserToken') ?? "";
    var url = Uri.parse(baseurl + versionHome + language);
    var response = await http.post(url, headers: {'Authorization': mainUserToken}, body: {"type": type});
    var responseData = json.decode(response.body);

    return LanguageListModel.fromJson(responseData);
  }

  defaultLanguage({required LanguageResponse responseSelected, required String type}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String mainUserToken = prefs.getString('newUserToken') ?? "";
    var url = Uri.parse(baseurl + versions + languageSet);
    await http.post(url, headers: {'Authorization': mainUserToken}, body: {"language": responseSelected.code, "type": type});
  }
}
