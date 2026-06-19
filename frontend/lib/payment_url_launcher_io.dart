import 'package:url_launcher/url_launcher.dart';

Future<bool> openPaymentUrl(String url) async {
  final uri = Uri.tryParse(url);
  if (uri == null) {
    return false;
  }

  if (await launchUrl(uri, mode: LaunchMode.inAppBrowserView)) {
    return true;
  }

  return launchUrl(uri, mode: LaunchMode.externalApplication);
}
