
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:whatsapp_share_plus/whatsapp_share_plus.dart';
class WhatsAppService {

  static const String preferredWhatsAppNumber =
      '917592088952';

  static Future<void> sendOrder({
    required String phoneNumber,
    required String customerName,
    required String customerPhone,
    required String address,
    required String place,
    required String landmark,
    required String district,
    required String state,
    required String pincode,
    required List<Map<String, dynamic>> products,
    required double subtotal,
    required double deliveryCharge,
    required double total,
    required List<String> productImages,
  }) async {

    final message = _createOrderMessage(
      customerName: customerName,
      customerPhone: customerPhone,
      address: address,
      place: place,
      landmark: landmark,
      district: district,
      state: state,
      pincode: pincode,
      products: products,
      subtotal: subtotal,
      total: total,
    );

    final files = <ShareFile>[];

    for (int i = 0; i < productImages.length; i++) {
      try {
        final imageUrl = productImages[i];

        final response = await http.get(
          Uri.parse(imageUrl),
        );

        if (response.statusCode == 200) {
          final Uint8List imageBytes = response.bodyBytes;

          files.add(
            ShareFile.fromBytes(
              imageBytes,
              name: 'product_${i + 1}.jpg',
            ),
          );
        }
      } catch (e) {
        print(
          'Failed to download image ${i + 1}: $e',
        );
      }
    }

    try {
      // Share directly to the preferred WhatsApp number.
      final result = await WhatsAppShare.share(
  text: message,
  files: files,
  phone: preferredWhatsAppNumber,
);

      print(
        'WhatsApp share result: ${result.status}',
      );
    } catch (e) {
      throw Exception(
        'Could not send order to WhatsApp: $e',
      );
    }
  }

  static String _createOrderMessage({
    required String customerName,
    required String customerPhone,
    required String address,
    required String place,
    required String landmark,
    required String district,
    required String state,
    required String pincode,
    required List<Map<String, dynamic>> products,
    required double subtotal,
    required double total,
  }) {
    final buffer = StringBuffer();

    buffer.writeln(
      'Hello, I would like to place an order.',
    );

    buffer.writeln();

    buffer.writeln(
      '🛍️ *ORDER DETAILS*',
    );


    for (int i = 0; i < products.length; i++) {
      final product = products[i];

      final name = product['name'];
      final price = product['price'];
      final quantity = product['quantity'];
      final size = product['size'];
      final color = product['color'];

      final itemTotal = price * quantity;

      buffer.writeln();

      buffer.writeln(
        '${i + 1}. $name',
      );

      if (size != null &&
          size.toString().isNotEmpty) {
        buffer.writeln(
          'Size: $size',
        );
      }

      if (color != null &&
          color.toString().isNotEmpty) {
        buffer.writeln(
          'Color: $color',
        );
      }

      buffer.writeln(
        'Quantity: $quantity',
      );

      buffer.writeln(
        'Price: ₹$price',
      );

      buffer.writeln(
        'Item Total: ₹$itemTotal',
      );
    }

    buffer.writeln();

    buffer.writeln(
      'Subtotal: ₹$subtotal',
    );

  

    buffer.writeln(
      'Total: ₹$total',
    );

    buffer.writeln();

    buffer.writeln(
      '👤 *CUSTOMER DETAILS*',
    );


    buffer.writeln(
      'Name: $customerName',
    );

    buffer.writeln(
      'Phone: $customerPhone',
    );

    buffer.writeln();

    buffer.writeln(
      '📍 *DELIVERY ADDRESS*',
    );


    buffer.writeln(
      'Address: $address',
    );

    buffer.writeln(
      'Place: $place',
    );

    buffer.writeln(
      'Landmark: $landmark',
    );

    buffer.writeln(
      'District: $district',
    );

    buffer.writeln(
      'State: $state',
    );

    buffer.writeln(
      'Pincode: $pincode',
    );

    buffer.writeln();

    if (products.isNotEmpty) {
      buffer.writeln(
        '📸 Selected product images are attached.',
      );

      buffer.writeln();
    }

    buffer.writeln(
      'Thank you!',
    );

    return buffer.toString();
  }
}



