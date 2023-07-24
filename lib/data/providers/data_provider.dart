import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:magadh_tech/data/model/login_verify_model.dart';
import 'package:magadh_tech/data/model/user_list.dart';

class DataProvider with ChangeNotifier {
  UsersListModel? usersListModel;
  LoginVerifyModel? loginVerifyModel;
  XFile? imageFile;

  void getUserData(UsersListModel value) {
    if (usersListModel?.users != null) {
      for (var data in value.users!) {
        usersListModel?.users?.add(data);
      }
    } else {
      usersListModel = value;
    }
    notifyListeners();
  }

  void getProfileData(LoginVerifyModel value) {
    loginVerifyModel = value;

    notifyListeners();
  }
}
