class DeliveryModel {
  int? success;
  String? value;
  String? delivery;

  DeliveryModel({this.success, this.value, this.delivery});

  DeliveryModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    value = json['value'];
    delivery = json['delivery'];
  }
}
