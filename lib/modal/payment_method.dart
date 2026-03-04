class PaymentMethod {
  final String brand;
  final String number;
  final String expiry;
  final int colorHex;
  final bool isDefault;

  const PaymentMethod({
    required this.brand,
    required this.number,
    required this.expiry,
    required this.colorHex,
    required this.isDefault,
  });

  PaymentMethod copyWith({bool? isDefault}) {
    return PaymentMethod(
      brand: brand,
      number: number,
      expiry: expiry,
      colorHex: colorHex,
      isDefault: isDefault ?? this.isDefault,
    );
  }
}
