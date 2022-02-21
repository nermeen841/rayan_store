class CheckPhoneModel {
  int? status;
  Data? data;

  CheckPhoneModel({this.status, this.data});

  CheckPhoneModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
}

class Data {
  int? id;
  String? name;
  String? email;
  String? phone;

  Data({
    this.id,
    this.name,
    this.email,
    this.phone,
  });

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
  }
}
