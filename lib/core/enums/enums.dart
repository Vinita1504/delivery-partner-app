/// Order status enum matching API values
enum OrderStatus {
  pending('PENDING', 'Pending'),
  confirmed('CONFIRMED', 'Confirmed'),
  processing('PROCESSING', 'Processing'),
  packed('PACKED', 'Packed'),
  assigned('ASSIGNED', 'Assigned'),
  pickedUp('PICKED_UP', 'Picked Up'),
  outForDelivery('OUT_FOR_DELIVERY', 'Out for Delivery'),
  delivered('DELIVERED', 'Delivered'),
  cancelled('CANCELLED', 'Cancelled'),
  returned('RETURNED', 'Returned'),
  returnRequested('RETURN_REQUESTED', 'Return Requested'),
  returnPickedUp('RETURN_PICKED_UP', 'Return Picked Up');

  final String value;
  final String displayName;
  const OrderStatus(this.value, this.displayName);

  static OrderStatus fromString(String value) => OrderStatus.values.firstWhere(
    (status) => status.value.toUpperCase() == value.toUpperCase(),
    orElse: () => OrderStatus.pending,
  );

  /// Check if status allows pickup action
  bool get canPickUp => this == OrderStatus.assigned;

  /// Check if status allows out for delivery action
  bool get canStartDelivery => this == OrderStatus.pickedUp;

  /// Check if status allows completion
  bool get canComplete => this == OrderStatus.outForDelivery;

  /// Check if order is in terminal state
  bool get isTerminal =>
      this == OrderStatus.delivered ||
      this == OrderStatus.cancelled ||
      this == OrderStatus.returned;
}

/// Payment status enum matching API values
enum PaymentStatus {
  pending('PENDING', 'Pending'),
  completed('COMPLETED', 'Completed'),
  failed('FAILED', 'Failed'),
  refunded('REFUNDED', 'Refunded');

  final String value;
  final String displayName;
  const PaymentStatus(this.value, this.displayName);

  static PaymentStatus fromString(String value) =>
      PaymentStatus.values.firstWhere(
        (status) => status.value.toUpperCase() == value.toUpperCase(),
        orElse: () => PaymentStatus.pending,
      );

  /// Check if payment is successful
  bool get isSuccessful => this == PaymentStatus.completed;

  /// Check if payment requires collection (COD)
  bool get requiresCollection => this == PaymentStatus.pending;
}

/// Payment method enum matching API values
enum PaymentMethod {
  cod('cod', 'Cash on Delivery', 'COD'),
  online('online', 'Online Payment', 'Paid'),
  upi('upi', 'UPI', 'UPI'),
  wallet('wallet', 'Wallet', 'Wallet');

  final String value;
  final String displayName;
  final String shortName;
  const PaymentMethod(this.value, this.displayName, this.shortName);

  static PaymentMethod fromString(String value) =>
      PaymentMethod.values.firstWhere(
        (method) => method.value.toLowerCase() == value.toLowerCase(),
        orElse: () => PaymentMethod.cod,
      );

  /// Check if this is cash on delivery
  bool get isCod => this == PaymentMethod.cod;

  /// Check if this is prepaid (any non-COD method)
  bool get isPrepaid => this != PaymentMethod.cod;
}

/// Payment type enum (legacy support)
enum PaymentType {
  cod('COD', 'Cash on Delivery', 'COD'),
  prepaid('PREPAID', 'Online / Paid', 'Paid');

  final String value;
  final String displayName;
  final String shortName;
  const PaymentType(this.value, this.displayName, this.shortName);

  static PaymentType fromString(String value) => PaymentType.values.firstWhere(
    (type) => type.value.toUpperCase() == value.toUpperCase(),
    orElse: () => PaymentType.cod,
  );
}

/// Issue type enum for reporting problems
enum IssueType {
  customerNotAvailable('CUSTOMER_NOT_AVAILABLE', 'Customer not available'),
  otpNotReceived('OTP_NOT_RECEIVED', 'OTP not received'),
  addressIssue('ADDRESS_ISSUE', 'Address issue'),
  paymentIssue('PAYMENT_ISSUE', 'Payment issue'),
  productDamaged('PRODUCT_DAMAGED', 'Product damaged'),
  customerRefused('CUSTOMER_REFUSED', 'Customer refused'),
  other('OTHER', 'Other');

  final String value;
  final String displayName;
  const IssueType(this.value, this.displayName);

  static IssueType fromString(String value) => IssueType.values.firstWhere(
    (type) => type.value.toUpperCase() == value.toUpperCase(),
    orElse: () => IssueType.other,
  );
}

/// Order history filter enum
enum OrderHistoryFilter {
  all('all', 'All'),
  delivered('delivered', 'Delivered'),
  cancelled('cancelled', 'Cancelled'),
  returned('returned', 'Returned');

  final String value;
  final String displayName;
  const OrderHistoryFilter(this.value, this.displayName);
}
