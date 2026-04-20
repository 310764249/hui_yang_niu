class DeviceSerialEntity {
  final String code;
  final String name;
  final String address;
  final String phone;
  final int liveStock;
  final int status;
  final String stateName;
  final int channelNo;

  DeviceSerialEntity({
    required this.code,
    required this.name,
    required this.address,
    required this.phone,
    required this.liveStock,
    required this.status,
    required this.stateName,
    required this.channelNo,
  });

  factory DeviceSerialEntity.fromJson(Map<String, dynamic> json) {
    return DeviceSerialEntity(
      code: json['code'] ?? '',
      name: json['name'] ?? '',
      address: json['address'] ?? '',
      phone: json['phone'] ?? '',
      liveStock: json['liveStock'] ?? 0,
      status: json['status'] ?? 0,
      stateName: json['stateName'] ?? '',
      channelNo: json['channelNo'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'name': name,
      'address': address,
      'phone': phone,
      'liveStock': liveStock,
      'status': status,
      'stateName': stateName,
      'channelNo': channelNo,
    };
  }
}
