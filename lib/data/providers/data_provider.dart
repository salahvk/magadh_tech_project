import 'package:flutter/material.dart';
import 'package:magadh_tech/data/model/user_list.dart';

class DataProvider with ChangeNotifier {
  UsersListModel? usersListModel;

  void getUserData(UsersListModel value) {
    // if (employeesModel?.data != null && employeesModel?.data?.data != null) {
    //   for (var data in value.data!.data!) {
    //     employeesModel?.data?.data?.add(data);
    //   }
    // } else {
    usersListModel = value;
    // }
    notifyListeners();
  }
}
