import 'package:web/web.dart' as web;

Future<bool> openPaymentUrl(String url) async {
  web.window.open(url, '_blank');
  return true;
}
