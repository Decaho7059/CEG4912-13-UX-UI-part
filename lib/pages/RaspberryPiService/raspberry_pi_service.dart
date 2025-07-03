import 'dart:convert';
import 'package:http/http.dart' as http;

class RaspberryPiService {
  static const String raspberryPiIP = "192.168.215.16";
  static const int port = 5000;
  static String get baseUrl => "http://$raspberryPiIP:$port";
  static Future<String> getStatus() async {
    final url = Uri.parse("$baseUrl/status");
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data["status"] ?? "Unknown status";
      } else {
        return "Failed to connect: ${response.statusCode}";
      }
    } catch (e) {
      return "Error: $e";
    }
  }

  static Future<String> performAction(String action) async {
    final url = Uri.parse("$baseUrl/action");
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"action": action}),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data["message"] ?? "Action performed";
      } else {
        return "Failed to perform action: ${response.statusCode}";
      }
    } catch (e) {
      return "Error: $e";
    }
  }
}
