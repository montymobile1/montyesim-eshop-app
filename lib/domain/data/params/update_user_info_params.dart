class UpdateUserInfoRequest {
  UpdateUserInfoRequest({
    this.email,
    this.msisdn,
    this.firstName,
    this.lastName,
    this.bearerToken,
    this.currencyCode,
    this.languageCode,
  });

  final String? email;
  final String? msisdn;
  final String? firstName;
  final String? lastName;
  final String? bearerToken;
  final String? currencyCode;
  final String? languageCode;
}
