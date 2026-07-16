abstract class LicenseVerificationException implements Exception {
  final String message;
  const LicenseVerificationException(this.message);

  @override
  String toString() => '$runtimeType: $message';
}

class InvalidFormatException extends LicenseVerificationException {
  const InvalidFormatException(super.message);
}

class InvalidSignatureException extends LicenseVerificationException {
  const InvalidSignatureException() : super('Invalid digital signature.');
}

class InvalidHeaderException extends LicenseVerificationException {
  const InvalidHeaderException(super.message);
}

class InvalidClaimsException extends LicenseVerificationException {
  const InvalidClaimsException(super.message);
}

class InvalidBindingException extends LicenseVerificationException {
  const InvalidBindingException(super.message);
}

class KeyNotFoundException extends LicenseVerificationException {
  const KeyNotFoundException()
    : super('No enabled trusted key matches the protected header.');
}
