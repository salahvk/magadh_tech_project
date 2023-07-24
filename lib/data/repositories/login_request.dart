// ignore_for_file: await_only_futures, use_build_context_synchronously

import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:magadh_tech/controllers/text_controllers.dart';
import 'package:magadh_tech/data/endpoint.dart';
import 'package:magadh_tech/data/failures/main_failures.dart';
import 'package:magadh_tech/data/model/login_request.dart';
import 'package:magadh_tech/data/model/login_verify_model.dart';
import 'package:magadh_tech/data/model/user_list.dart';
import 'package:magadh_tech/data/providers/data_provider.dart';
import 'package:magadh_tech/data/services/login_services.dart';
import 'package:magadh_tech/utils/convert_image.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

@LazySingleton(as: MagadhServices)
class LoginImp implements MagadhServices {
  BuildContext? context;
  LoginImp({this.context});
  @override
  Future<Either<MainFailure, LoginRequestModel>> userLogin() async {
    try {
      final uri = ApiEndPoint.login;
      final url = Uri.parse(uri);
      final headers = {'Content-Type': 'application/json'};
      final body = jsonEncode({
        'phone': PhoneNoController.phoneController.text,
      });

      final response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        final result = LoginRequestModel.fromJson(jsonResponse);
        // final accessToken = jsonResponse["data"]["access_token"];
        // print(accessToken);
        // final SharedPreferences prefs = await SharedPreferences.getInstance();
        // await prefs.setString('access_token', accessToken);
        // await FetchEmployeesData.getData(context);
        // await FetchDesignations.getData(context);
        log(response.body);
        return Right(result);
      } else {
        return const Left(MainFailure.serverFailure());
      }
    } on Exception catch (_) {
      return const Left(MainFailure.clientFailure());
    }
  }

  @override
  Future<Either<MainFailure, UsersListModel>> getUsers() async {
    try {
      final pageNo = HomeController.pageController.text;
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? accessToken = prefs.getString('access_token');

      final url = Uri.parse("$users?page=$pageNo");
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      };

      final response = await http.get(
        url,
        headers: headers,
      );
      if (response.statusCode == 200) {
        final provider = Provider.of<DataProvider>(context!, listen: false);
        var jsonResponse = jsonDecode(response.body);
        log(response.body);
        final result = UsersListModel.fromJson(jsonResponse);
        provider.getUserData(result);
        // final accessToken = jsonResponse["data"]["access_token"];
        // print(accessToken);
        // final SharedPreferences prefs = await SharedPreferences.getInstance();
        // await prefs.setString('access_token', accessToken);
        // await FetchEmployeesData.getData(context);
        // await FetchDesignations.getData(context);
        log(response.body);
        return Right(result);
      } else {
        return const Left(MainFailure.serverFailure());
      }
    } on Exception catch (_) {
      return const Left(MainFailure.clientFailure());
    }
  }

  @override
  Future<Either<MainFailure, LoginVerifyModel>> loginVerify() async {
    try {
      final uri = ApiEndPoint.loginVerify;
      final url = Uri.parse(uri);
      final headers = {'Content-Type': 'application/json'};
      final body = jsonEncode({
        'phone': PhoneNoController.phoneController.text,
        'otp': PhoneNoController.otpController.text,
      });

      final response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        final result = LoginVerifyModel.fromJson(jsonResponse);
        final accessToken = result.token;
        // print(accessToken);
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('access_token', accessToken ?? '');
        // await FetchEmployeesData.getData(context);
        // await FetchDesignations.getData(context);
        log(response.body);
        return Right(result);
      } else {
        return const Left(MainFailure.serverFailure());
      }
    } on Exception catch (_) {
      return const Left(MainFailure.clientFailure());
    }
  }

  @override
  Future<Either<MainFailure, LoginVerifyModel>> verifyToken() async {
    try {
      final uri = ApiEndPoint.loginVerify;
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? accessToken = prefs.getString('access_token');
      final url = Uri.parse(uri);
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      };

      final response = await http.get(
        url,
        headers: headers,
      );
      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        final result = LoginVerifyModel.fromJson(jsonResponse);
        final provider = Provider.of<DataProvider>(context!, listen: false);
        provider.getProfileData(result);
        log(response.body);
        return Right(result);
      } else {
        return const Left(MainFailure.serverFailure());
      }
    } on Exception catch (_) {
      return const Left(MainFailure.clientFailure());
    }
  }

  @override
  Future<Either<MainFailure, LoginVerifyModel>> updateProfile() async {
    try {
      final provider = Provider.of<DataProvider>(context!, listen: false);
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? accessToken = prefs.getString('access_token');
      final url = Uri.parse(users);
      String base64Image =
          await convertImageToBase64(File(provider.imageFile?.path ?? ''));

      Map<String, dynamic> data = {
        "image": base64Image,
        "location": {
          "location": {"latitude": 0, "longitude": 0}
        }
        // Add other data you want to send in the request body
      };
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      };

      final response =
          await http.patch(url, headers: headers, body: jsonEncode(data));
      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        final result = LoginVerifyModel.fromJson(jsonResponse);

        provider.getProfileData(result);
        log(response.body);
        return Right(result);
      } else {
        return const Left(MainFailure.serverFailure());
      }
    } on Exception catch (_) {
      return const Left(MainFailure.clientFailure());
    }
  }
}
