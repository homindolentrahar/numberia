import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:numberia/core/error/exceptions.dart';
import 'package:numberia/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:numberia/features/number_trivia/data/sources/number_trivia_remote_data_source.dart';
import 'package:http/http.dart' as http;

import '../../../../core/fixtures/fixture_reader.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  NumberTriviaRemoteDataSourceImpl dataSource;
  MockHttpClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockHttpClient();
    dataSource = NumberTriviaRemoteDataSourceImpl(mockHttpClient);
  });

  void setupMockHttpClientSuccess200() {
    when(mockHttpClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response(fixture('trivia.json'), 200));
  }

  void setupMockHttpClientFailure404() {
    when(mockHttpClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response('Something went wrong', 404));
  }

  group('getConcreteNumberTrivia', () {
    final testNumber = 1;
    final testNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));

    test(
      'should perform a GET request on a URL with number being the endpoint and with application/json header',
      () async {
        // Arrange
        setupMockHttpClientSuccess200();
        // Act
        dataSource.getConcreteNumberTrivia(testNumber);
        // Assert
        verify(mockHttpClient.get(
          'http://numbersapi.com/$testNumber',
          headers: {'Content-Type': 'application/json'},
        ));
      },
    );

    test(
      'should return NumberTriviaModel when the response code is 200 / Success',
      () async {
        // Arrange
        setupMockHttpClientSuccess200();
        // Act
        final result = await dataSource.getConcreteNumberTrivia(testNumber);
        // Assert
        expect(result, testNumberTriviaModel);
      },
    );

    test(
      'should throw ServerException when the response code is 404 or other',
      () async {
        // Arrange
        setupMockHttpClientFailure404();
        // Act
        final call = dataSource.getConcreteNumberTrivia;
        // Assert
        expect(() => call(testNumber), throwsA(isA<ServerException>()));
      },
    );
  });

  group('getRandomNumberTrivia', () {
    final testNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));

    test(
      'should perform a GET request on a URL with number being the endpoint and with application/json header',
      () async {
        // Arrange
        setupMockHttpClientSuccess200();
        // Act
        dataSource.getRandomNumberTrivia();
        // Assert
        verify(mockHttpClient.get(
          'http://numbersapi.com/random',
          headers: {'Content-Type': 'application/json'},
        ));
      },
    );

    test(
      'should return NumberTriviaModel when the response code is 200 / Success',
      () async {
        // Arrange
        setupMockHttpClientSuccess200();
        // Act
        final result = await dataSource.getRandomNumberTrivia();
        // Assert
        expect(result, testNumberTriviaModel);
      },
    );

    test(
      'should throw ServerException when the response code is 404 or other',
      () async {
        // Arrange
        setupMockHttpClientFailure404();
        // Act
        final call = dataSource.getRandomNumberTrivia;
        // Assert
        expect(() => call(), throwsA(isA<ServerException>()));
      },
    );
  });
}
