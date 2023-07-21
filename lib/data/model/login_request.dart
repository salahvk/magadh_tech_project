class LoginRequestModel {
  String? message;
  int? otp;

  LoginRequestModel({this.message, this.otp});

  LoginRequestModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    otp = json['otp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    data['otp'] = otp;
    return data;
  }
}
