/// Order status enum
enum OrderStatus {
  assigned('ASSIGNED', 'Assigned'),
  pickedUp('PICKED_UP', 'Picked Up'),
  outForDelivery('OUT_FOR_DELIVERY', 'Out for Delivery'),
  delivered('DELIVERED', 'Delivered'),
  cancelled('CANCELLED', 'Cancelled');

  final String value;
  final String displayName;
  const OrderStatus(this.value, this.displayName);

  static OrderStatus fromString(String value) => OrderStatus.values.firstWhere(
    (status) => status.value == value,
    orElse: () => OrderStatus.assigned,
  );
}

/// Payment type enum
enum PaymentType {
  cod('COD', 'Cash on Delivery', 'COD'),
  prepaid('PREPAID', 'Online / Paid', 'Paid');

  final String value;
  final String displayName;
  final String shortName;
  const PaymentType(this.value, this.displayName, this.shortName);

  static PaymentType fromString(String value) => PaymentType.values.firstWhere(
    (type) => type.value == value,
    orElse: () => PaymentType.cod,
  );
}

/// Issue type enum
enum IssueType {
  customerNotAvailable('CUSTOMER_NOT_AVAILABLE', 'Customer not available'),
  otpNotReceived('OTP_NOT_RECEIVED', 'OTP not received'),
  addressIssue('ADDRESS_ISSUE', 'Address issue'),
  other('OTHER', 'Other');

  final String value;
  final String displayName;
  const IssueType(this.value, this.displayName);

  static IssueType fromString(String value) => IssueType.values.firstWhere(
    (type) => type.value == value,
    orElse: () => IssueType.other,
  );
}
