import 'package:flutter_test/flutter_test.dart';
import 'package:perminda/core/api_helpers/api.dart';

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
}
