
import 'package:flutter/material.dart';
import 'dart:convert' as convert;
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:tashkentsupermarket/common/constants.dart';

class AppModel with ChangeNotifier {

    Map<String, dynamic> appConfig;
    bool isLoading = true;
    String message;
    bool darkTheme = false;

    void updateTheme(bool theme){
      darkTheme = theme;
      notifyListeners();
    }

    void loadAppConfig() async {
      try {
        if (kAppConfig.indexOf('http') != -1) {
          // load on cloud config and update on air
          final appJson = await http.get(Uri.encodeFull(kAppConfig), headers: {"Accept": "application/json"});
          appConfig = convert.jsonDecode(appJson.body);
        } else {
          // load local config
          final appJson = await rootBundle.loadString(kAppConfig);
          appConfig = convert.jsonDecode(appJson);
        }

        isLoading = false;
        notifyListeners();
      } catch (err) {
        isLoading = false;
        message = err.toString();
        notifyListeners();
      }
    }
}

class App {
    Map<String, dynamic> appConfig;

    App(this.appConfig);
}
