import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class PaymentService {
  final String? baseUrl = dotenv.env['BASE_URL'];

  Future<Map<String, dynamic>?> fetchSnapToken({
    required int shippingId,
    required String paymentType,
  }) async {
    final storage = FlutterSecureStorage();
    String? accessToken = await storage.read(key: 'accessToken');

    if (accessToken == null) {
      throw Exception('Access token is missing');
    }

    print("shipping id: ${shippingId}");
    print("payment typenya: ${paymentType}");

    final response = await http.post(
      Uri.parse("$baseUrl/transaction"),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode({
        'shipping_id': shippingId,
        'payment_type': paymentType,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to fetch Snap Token');
    }
  }

  Future<Map<String, dynamic>?> paymentSuccess({
    required Map<String, dynamic> transaction,
  }) async {
    final url = Uri.parse('$baseUrl/paymentSuccess');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'transaction': transaction,
        }),
      );

      if (response.statusCode == 200) {
        // Decode response
        final data = jsonDecode(response.body);
        // Return success data
        return data;
      } else {
        final data = jsonDecode(response.body);
        throw Exception(data['error'] ?? 'Failed to handle payment success');
      }
    } catch (e) {
      print('Error handling payment success: $e');
      return {'error': e.toString()};
    }
  }
}
