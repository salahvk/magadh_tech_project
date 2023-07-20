// ignore_for_file: await_only_futures, use_build_context_synchronously

import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:magadh_tech/controllers/text_controllers.dart';
import 'package:magadh_tech/data/endpoint.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserLoginApi {
  static Future<bool> login(BuildContext context) async {
    try {
      final uri =
         ApiEndPoint.login;            
      final url = Uri.parse(uri);
      final headers = {'Content-Type': 'application/json'};
      final body = jsonEncode({
        'phone': PhoneNoController.phoneController.text,
        
      });

      final response = await http.post(url, headers: headers, body: body);      
      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        final accessToken = jsonResponse["data"]["access_token"];
        print(accessToken);
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('access_token', accessToken);
        // await FetchEmployeesData.getData(context);
        // await FetchDesignations.getData(context);
        log(response.body);
        return true;
      } else {
        log("Something Went Wrong50");
        return false;
      }
    } on Exception catch (_) {
      log("Something Went Wrong50");
    }

    return false;
  }
}