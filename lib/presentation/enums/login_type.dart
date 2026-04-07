enum LoginType {
  email("email"),
  phoneNumber("phone"),
  emailAndPhone("email_phone"),
  emailAndPhoneAndEmailVerification("email_phone_email"),
  emailAndPhoneAndBothVerification("email_phone_both");

  const LoginType(this.type);

  final String type;

  static LoginType? fromValue({required String value}) {
    final String v = value.toLowerCase();

    for (final LoginType type in LoginType.values) {
      if (type.type.toLowerCase() == v) {
        return type;
      }
    }

    return null;
  }
}
