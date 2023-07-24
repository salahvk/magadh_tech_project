import 'package:dartz/dartz.dart';
import 'package:magadh_tech/data/failures/main_failures.dart';
import 'package:magadh_tech/data/model/login_request.dart';
import 'package:magadh_tech/data/model/login_verify_model.dart';
import 'package:magadh_tech/data/model/user_list.dart';

abstract class MagadhServices {
  Future<Either<MainFailure, LoginRequestModel>> userLogin();
  Future<Either<MainFailure, UsersListModel>> getUsers();
  Future<Either<MainFailure, LoginVerifyModel>> loginVerify();
  Future<Either<MainFailure, LoginVerifyModel>> verifyToken();
  Future<Either<MainFailure, LoginVerifyModel>> updateProfile();
}
