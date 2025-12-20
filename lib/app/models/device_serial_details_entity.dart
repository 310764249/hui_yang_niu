class DeviceSerialDetailsEntity {
  final String code;
  final String url;
  final String token;
  final String appKey;

  DeviceSerialDetailsEntity({
    required this.code,
    required this.url,
    required this.token,
    required this.appKey,
  });

  factory DeviceSerialDetailsEntity.fromJson(Map<String, dynamic> json) {
    return DeviceSerialDetailsEntity(
      code: json['code'] ?? '',
      url: json['url'] ?? '',
      token: json['token'] ?? '',
      appKey: json['appKey'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'code': code, 'url': url, 'token': token, 'appKey': appKey};
  }
}
