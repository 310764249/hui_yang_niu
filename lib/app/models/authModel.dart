class AuthModel {
  AuthModel({
    required this.accessToken,
    required this.tokenType,
    required this.grantType,
    required this.expiresIn,
    required this.refreshToken,
  });
  late final String accessToken;
  late final String tokenType;
  late final String grantType;
  late final String expiresIn;
  late final String refreshToken;

  AuthModel.fromJson(Map<String, dynamic> json) {
    accessToken = json['access_token'];
    tokenType = json['token_type'];
    grantType = json['grantType'];
    expiresIn = json['expires_in'];
    refreshToken = json['refresh_token'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['access_token'] = accessToken;
    data['token_type'] = tokenType;
    data['grantType'] = grantType;
    data['expires_in'] = expiresIn;
    data['refresh_token'] = refreshToken;
    return data;
  }
}
