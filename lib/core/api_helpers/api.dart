import 'package:perminda/core/constants/sensetive_constants.dart';
import 'package:perminda/data/remote_models/orders/order_params.dart';

class API {
  static int offsetExtractor(String url) {
    if (url != null) {
      final uri = Uri.parse(url);
      final offestString = uri.queryParameters['offset'];
      return int.tryParse(offestString);
    }
    return null;
  }

  static String orderUrlProvider(List<OrderParams> items) {
    var url = StringBuffer()..write('$baseUrl/api/order/');
    int length = items.length;

    if (items.isNotEmpty) {
      url.write(
        '?product0=${items[0].productid}&quantity0=${items[0].quantity}',
      );

      if (length > 1) {
        for (var i = 2; i <= length; i++) {
          url.write(
              '&product${i - 1}=${items[i - 1].productid}&quantity${i - 1}=${items[i - 1].quantity}');
        }
        return url.toString();
      } else {
        return url.toString();
      }
    }
    return url.toString();
  }
}
