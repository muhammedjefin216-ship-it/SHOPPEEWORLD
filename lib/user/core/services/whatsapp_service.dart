import 'package:url_launcher/url_launcher.dart';

class WhatsAppService {
  static Future<void> sendOrder({
  required String phoneNumber,
  required String customerName,
  required String customerPhone,
  required String address,
  required String city,
  required String state,
  required String pincode,
  required List<Map<String, dynamic>> products,
  required double subtotal,
  required double deliveryCharge,
  required double total,
}) async {
  final message = _createOrderMessage(
    customerName: customerName,
    customerPhone: customerPhone,
    address: address,
    city: city,
    state: state,
    pincode: pincode,
    products: products,
    subtotal: subtotal,
    deliveryCharge: deliveryCharge,
    total: total,
  );

  final encodedMessage = Uri.encodeComponent(message);

  final whatsappUrl = Uri.parse(
    'https://wa.me/$phoneNumber?text=$encodedMessage',
  );

  try {
    final launched = await launchUrl(
      whatsappUrl,
      mode: LaunchMode.externalApplication,
    );

    if (!launched) {
      throw Exception('Could not open WhatsApp');
    }
  } catch (e) {
    throw Exception('Could not open WhatsApp: $e');
  }
}


  static String _createOrderMessage({
    required String customerName,
    required String customerPhone,
    required String address,
    required String city,
    required String state,
    required String pincode,
    required List<Map<String, dynamic>> products,
    required double subtotal,
    required double deliveryCharge,
    required double total,
  }) {
    final buffer =
        StringBuffer();

    

    buffer.writeln(
      'Hello, I would like to place an order.',
    );

    buffer.writeln();

    // ==============================================================
    // ORDER DETAILS
    // ==============================================================

    buffer.writeln(
      '🛍️ *ORDER DETAILS*',
    );

    buffer.writeln(
      '━━━━━━━━━━━━━━━━',
    );

    for (int i = 0;
        i < products.length;
        i++) {
      final product =
          products[i];

      final name =
          product['name'];

      final price =
          product['price'];

      final quantity =
          product['quantity'];

      final size =
          product['size'];

      final color =
          product['color'];

      final itemTotal =
          price * quantity;

      buffer.writeln();

      buffer.writeln(
        '${i + 1}. $name',
      );

      // ============================================================
      // SIZE
      // ============================================================

      if (size != null &&
          size
              .toString()
              .isNotEmpty) {
        buffer.writeln(
          'Size: $size',
        );
      }

      // ============================================================
      // COLOR
      // ============================================================

      if (color != null &&
          color
              .toString()
              .isNotEmpty) {
        buffer.writeln(
          'Color: $color',
        );
      }

      // ============================================================
      // QUANTITY
      // ============================================================

      buffer.writeln(
        'Quantity: $quantity',
      );

      // ============================================================
      // PRICE
      // ============================================================

      buffer.writeln(
        'Price: ₹$price',
      );

      // ============================================================
      // ITEM TOTAL
      // ============================================================

      buffer.writeln(
        'Item Total: ₹$itemTotal',
      );
    }

    // ==============================================================
    // PRICE SUMMARY
    // ==============================================================

    buffer.writeln();

    buffer.writeln(
      '━━━━━━━━━━━━━━━━',
    );

    buffer.writeln(
      'Subtotal: ₹$subtotal',
    );

    buffer.writeln(
      'Delivery: ₹$deliveryCharge',
    );

    buffer.writeln(
      'Total: ₹$total',
    );

    // ==============================================================
    // CUSTOMER DETAILS
    // ==============================================================

    buffer.writeln();

    buffer.writeln(
      '👤 *CUSTOMER DETAILS*',
    );

    buffer.writeln(
      '━━━━━━━━━━━━━━━━',
    );

    buffer.writeln(
      'Name: $customerName',
    );

    buffer.writeln(
      'Phone: $customerPhone',
    );

    // ==============================================================
    // DELIVERY ADDRESS
    // ==============================================================

    buffer.writeln();

    buffer.writeln(
      '📍 *DELIVERY ADDRESS*',
    );

    buffer.writeln(
      '━━━━━━━━━━━━━━━━',
    );

    buffer.writeln(
      address,
    );

    buffer.writeln(
      '$city, $state',
    );

    buffer.writeln(
      'Pincode: $pincode',
    );

    // ==============================================================
    // END MESSAGE
    // ==============================================================

    buffer.writeln();

    buffer.writeln(
      'Thank you!',
    );

    return buffer.toString();
  }
}