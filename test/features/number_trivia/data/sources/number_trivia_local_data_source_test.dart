import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:matcher/matcher.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:numberia/core/error/exceptions.dart';
import 'package:numberia/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:numberia/features/number_trivia/data/sources/number_trivia_local_data_source.dart';

import '../../../../core/fixtures/fixture_reader.dart';

class MockBox extends Mock implements Box {}

void main() {
  MockBox? mockBox;
  late NumberTriviaLocalDataSourceImpl dataSource;

  setUp(() {
    mockBox = MockBox();
    dataSource = NumberTriviaLocalDataSourceImpl(mockBox);
  });

  group('getLastNumberTrivia', () {
    final testNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture('trivia_cache.json')));

    test(
      'should return NumberTriviaModel from Hive Box when there is one in the cache',
      () async {
        // Arrange
        when(mockBox!.get(any)).thenReturn(fixture('trivia_cache.json'));
        // Act
        final result = await dataSource.getLastNumberTrivia();
        // Assert
        verify(mockBox!.get(CACHED));
        expect(result, testNumberTriviaModel);
      },
    );

    test(
      'should throw CacheException when there is no a cached value',
      () async {
        // Arrange
        when(mockBox!.get(any)).thenReturn(null);
        // Act
        final call = dataSource.getLastNumberTrivia;
        // Assert
        expect(() => call(), throwsA(isA<CacheException>()));
      },
    );
  });

  group('cacheNumberTrivia', () {
    final testNumberTriviaModel =
        NumberTriviaModel(text: 'test text', number: 1);

    test(
      'should call Hive Box to cache the data',
      () async {
        // Act
        dataSource.cacheNumberTrivia(testNumberTriviaModel);
        // Assert
        final expectedValue = json.encode(testNumberTriviaModel.toJson());
        verify(mockBox!.put(CACHED, expectedValue));
      },
    );
  });
}
