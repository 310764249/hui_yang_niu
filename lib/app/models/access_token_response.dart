class AccessTokenResponse {
  final String accessToken;
  final int expiresIn;
  final TokenUser user;

  AccessTokenResponse({required this.accessToken, required this.expiresIn, required this.user});

  factory AccessTokenResponse.fromJson(Map<String, dynamic> json) {
    return AccessTokenResponse(
      accessToken: json['access_token'] as String,
      expiresIn: json['expires_in'] as int,
      user: TokenUser.fromJson(json['user']),
    );
  }

  Map<String, dynamic> toJson() => {
    'access_token': accessToken,
    'expires_in': expiresIn,
    'user': user.toJson(),
  };
}

class TokenUser {
  final String uuid;
  final String type;
  final int created;
  final int modified;
  final String username;
  final bool activated;

  TokenUser({
    required this.uuid,
    required this.type,
    required this.created,
    required this.modified,
    required this.username,
    required this.activated,
  });

  factory TokenUser.fromJson(Map<String, dynamic> json) {
    return TokenUser(
      uuid: json['uuid'] as String,
      type: json['type'] as String,
      created: json['created'] as int,
      modified: json['modified'] as int,
      username: json['username'] as String,
      activated: json['activated'] as bool,
    );
  }

  Map<String, dynamic> toJson() => {
    'uuid': uuid,
    'type': type,
    'created': created,
    'modified': modified,
    'username': username,
    'activated': activated,
  };
}
