class UserInfoResponseModel {
  UserInfoResponseModel({
    this.isVerified,
    this.referralCode,
    this.userToken,
    this.roleName,
    this.balance,
    this.currencyCode,
    this.msisdn,
    this.firstName,
    this.lastName,
    this.language,
    this.country,
    this.countryCode,
    this.email,
  });

  // Factory constructor for JSON decoding
  factory UserInfoResponseModel.fromJson(Map<String, dynamic> json) {
    return UserInfoResponseModel(
      isVerified: json["is_verified"],
      referralCode: json["referral_code"],
      userToken: json["user_token"],
      roleName: json["role_name"],
      balance: (json["balance"] ?? 0.0).toDouble(),
      currencyCode: json["currency_code"],
      msisdn: json["msisdn"],
      firstName: json["first_name"],
      lastName: json["last_name"],
      language: json["language"],
      country: json["country"],
      countryCode: json["country_code"],
      email: json["email"],
    );
  }
  final bool? isVerified;
  final String? referralCode;
  final String? userToken;
  final String? roleName;
  final double? balance;
  final String? currencyCode;
  final String? msisdn;
  final String? firstName;
  final String? lastName;
  final String? language;
  final String? country;
  final String? countryCode;
  final String? email;

  // Method for JSON encoding
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      "is_verified": isVerified,
      "referral_code": referralCode,
      "user_token": userToken,
      "role_name": roleName,
      "balance": balance,
      "currency_code": currencyCode,
      "msisdn": msisdn,
      "first_name": firstName,
      "last_name": lastName,
      "language": language,
      "country": country,
      "country_code": countryCode,
      "email": email,
    };
  }
}
