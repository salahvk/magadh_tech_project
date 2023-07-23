import 'package:flutter/material.dart';
import 'package:magadh_tech/data/model/user_list.dart';

class DataProvider with ChangeNotifier {
  UsersListModel? usersListModel;

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
}
