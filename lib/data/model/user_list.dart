class UsersListModel {
  List<Users>? users;
  int? count;
  int? page;

  UsersListModel({this.users, this.count, this.page});

  UsersListModel.fromJson(Map<String, dynamic> json) {
    if (json['users'] != null) {
      users = <Users>[];
      json['users'].forEach((v) {
        users!.add(Users.fromJson(v));
      });
    }
    count = json['count'];
    page = json['page'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (users != null) {
      data['users'] = users!.map((v) => v.toJson()).toList();
    }
    data['count'] = count;
    data['page'] = page;
    return data;
  }
}

class Users {
  Location? location;
  String? sId;
  String? name;
  String? email;
  String? phone;
  int? iV;
  String? createdAt;
  String? updatedAt;
  String? token;
  String? image;

  Users(
      {this.location,
      this.sId,
      this.name,
      this.email,
      this.phone,
      this.iV,
      this.createdAt,
      this.updatedAt,
      this.token,
      this.image});

  Users.fromJson(Map<String, dynamic> json) {
    location =
        json['location'] != null ? Location.fromJson(json['location']) : null;
    sId = json['_id'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    iV = json['__v'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    token = json['token'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (location != null) {
      data['location'] = location!.toJson();
    }
    data['_id'] = sId;
    data['name'] = name;
    data['email'] = email;
    data['phone'] = phone;
    data['__v'] = iV;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['token'] = token;
    data['image'] = image;
    return data;
  }
}

class Location {
  dynamic latitude;
  dynamic longitude;

  Location({this.latitude, this.longitude});

  Location.fromJson(Map<String, dynamic> json) {
    latitude = json['latitude'];
    longitude = json['longitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    return data;
  }
}
