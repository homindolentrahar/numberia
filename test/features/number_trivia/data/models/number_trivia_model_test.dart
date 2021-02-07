import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:numberia/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:numberia/features/number_trivia/data/models/number_trivia_model.dart';

import '../../../../core/fixtures/fixture_reader.dart';

void main() {
  final testNumberTriviaModel = NumberTriviaModel(number: 1, text: "test text");

  test(
    'should be a subclass of NumberTrivia entity',
    () async {
      // Assert
      expect(testNumberTriviaModel, isA<NumberTrivia>());
    },
  );

  group('fromJson', () {
    test(
      'should return a valid model when a JSON number is an integer',
      () async {
        // Arrange
        final Map<String, dynamic> jsonMap = jsonDecode(fixture('trivia.json'));
        // Act
        final result = NumberTriviaModel.fromJson(jsonMap);
        // Assert
        expect(result, testNumberTriviaModel);
      },
    );
    test(
      'should return a valid model when a JSON number is regarded as a double',
      () async {
        // Arrange
        final Map<String, dynamic> jsonMap = jsonDecode(fixture('trivia_double.json'));
        // Act
        final result = NumberTriviaModel.fromJson(jsonMap);
        // Assert
        expect(result, testNumberTriviaModel);
      },
    );
  });

  group('toJson', () {
    test(
      'should return a JSON map containing the proper data',
          () async {
        // Act
        final result = testNumberTriviaModel.toJson();
        // Assert
        final expectedMap = {
          "text":"test text",
          "number":1,
        };
        expect(result, expectedMap);
      },
    );
  });
}
