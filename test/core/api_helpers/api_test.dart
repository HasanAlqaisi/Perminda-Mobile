import 'package:flutter_test/flutter_test.dart';
import 'package:perminda/core/api_helpers/api.dart';
import 'package:perminda/core/constants/sensetive_constants.dart';
import 'package:perminda/data/remote_models/orders/order_params.dart';

void main() {
  final url = 'http://api.example.org/accounts/?offset=400&limit=100';

  group('offsetExtractor', () {
    test('should return [null] if url is null', () {
      final result = API.offsetExtractor(null);
      expect(result, null);
    });

    test('should return [int]offset if url is valid', () {
      final result = API.offsetExtractor(url);
      expect(result, 400);
    });
  });

  group('orderUrlProvider', () {
    test('should provide correct url if list has no items', () {
      final correctUrl = '$baseUrl/api/order/';
      List<OrderParams> orderParams = [];

      final result = API.orderUrlProvider(orderParams);

      expect(result, correctUrl);
    });

    test('should provide correct url if list has one item', () {
      final correctUrl = '$baseUrl/api/order/?product0=1&quantity0=50';
      var orderParams = [OrderParams(productid: '1', quantity: 50)];

      final result = API.orderUrlProvider(orderParams);

      expect(result, correctUrl);
    });

    test('should provide correct url if list has more than item', () {
      final correctUrl =
          '$baseUrl/api/order/?product0=1&quantity0=50&product1=2&quantity1=10';
      var orderParams = [
        OrderParams(productid: '1', quantity: 50),
        OrderParams(productid: '2', quantity: 10),
      ];

      final result = API.orderUrlProvider(orderParams);

      expect(result, correctUrl);
    });
  });
}
