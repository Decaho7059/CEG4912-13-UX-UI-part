
class RaspberryPiConfig {
  static const String raspberryPiIP = "192.168.1.100"; // Remplacez par l'IP de votre Raspberry Pi
  static const int port = 5000;
  static String get baseUrl => "http://$raspberryPiIP:$port";
}
