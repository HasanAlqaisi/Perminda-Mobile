import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:moor_flutter/moor_flutter.dart';
import 'package:perminda/data/db/app_database/app_database.dart';
import 'package:perminda/data/db/models/review/review_table.dart';
import 'package:perminda/data/remote_models/reviews/results.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final reviewResult =
      ReviewsResult.fromJson(json.decode(fixture('review.json')));
  test('should convert reviewsResult to db model in a correct way', () {
    final result = ReviewTable.fromReviewsResult([reviewResult]);

    final expectedResult = [
      ReviewTableCompanion(
            id: Value('3fa85f64-5717-4562-b3fc-2c963f66afa6'),
            user: Value('3fa85f64-5717-4562-b3fc-2c963f66afa6'),
            rate: Value(0),
            product: Value('3fa85f64-5717-4562-b3fc-2c963f66afa6'),
            message: Value('string'),
            dateWrote: Value(DateTime.tryParse('2020-11-21T11:09:56.164Z')),
            lastUpdate: Value(DateTime.tryParse('2020-11-21T11:09:56.164Z')),
          ),
    ];

    expect(result, expectedResult);
  });
}
