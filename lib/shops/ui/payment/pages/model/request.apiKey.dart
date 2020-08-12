class TokenApiKey {
  int status;
  bool error;
  String token;

  TokenApiKey({this.status, this.error, this.token});

  /* factory TokenApiKey.fromJson(
      Map<String, dynamic> parsedJson, int status, bool error) {
    return TokenApiKey(
        status: parsedJson['long_name'],
        token: parsedJson['short_name'],
        error: streetsList);
  }*/
  factory TokenApiKey.fromJson(String token, int status, bool error) {
    return TokenApiKey(status: status, token: token, error: error);
  }
}
