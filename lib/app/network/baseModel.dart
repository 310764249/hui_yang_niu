class BaseModel {
  int? code;
  String? message;
  dynamic data;

  BaseModel({this.message, this.code, this.data});

  BaseModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    code = json['code'];
    data = json['data'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    data['code'] = code;
    data['data'] = this.data;
    return data;
  }
}
