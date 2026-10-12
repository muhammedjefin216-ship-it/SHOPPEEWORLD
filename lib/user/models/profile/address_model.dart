/// A saved delivery address.
/// Place at: lib/user/models/address/address_model.dart
class AddressModel {
  final String id;
  final String label; // Home / Work / Other
  final String fullName;
  final String phone;
  final String pincode;
  final String addressLine; // House / flat / building
  final String area; // Street / area / locality
  final String? landmark;
  final String city;
  final String state;
  final bool isDefault;

  const AddressModel({
    required this.id,
    required this.label,
    required this.fullName,
    required this.phone,
    required this.pincode,
    required this.addressLine,
    required this.area,
    required this.landmark,
    required this.city,
    required this.state,
    required this.isDefault,
  });

  factory AddressModel.fromMap(Map<String, dynamic> map) {
    return AddressModel(
      id: map['id'].toString(),
      label: map['label']?.toString() ?? 'Home',
      fullName: map['full_name']?.toString() ?? '',
      phone: map['phone']?.toString() ?? '',
      pincode: map['pincode']?.toString() ?? '',
      addressLine: map['address_line']?.toString() ?? '',
      area: map['area']?.toString() ?? '',
      landmark: map['landmark']?.toString(),
      city: map['city']?.toString() ?? '',
      state: map['state']?.toString() ?? '',
      isDefault: map['is_default'] == true,
    );
  }

  /// Fields written on insert / update. The default flag is changed only
  /// through the `set_default_address` database function.
  Map<String, dynamic> toMap() {
    final landmarkText = landmark?.trim() ?? '';

    return {
      'label': label,
      'full_name': fullName,
      'phone': phone,
      'pincode': pincode,
      'address_line': addressLine,
      'area': area,
      'landmark': landmarkText.isEmpty ? null : landmarkText,
      'city': city,
      'state': state,
    };
  }

  /// Address formatted for display, over two lines.
  String get fullAddress {
    final landmarkText = landmark?.trim() ?? '';

    final firstLine = [
      addressLine,
      area,
      if (landmarkText.isNotEmpty) landmarkText,
    ].join(', ');

    return '$firstLine\n$city, $state $pincode';
  }
}