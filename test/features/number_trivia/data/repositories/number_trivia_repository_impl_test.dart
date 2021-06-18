import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:numberia/core/error/exceptions.dart';
import 'package:numberia/core/error/failures.dart';
import 'package:numberia/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:numberia/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:numberia/features/number_trivia/data/sources/number_trivia_local_data_source.dart';
import 'package:numberia/features/number_trivia/data/sources/number_trivia_remote_data_source.dart';
import 'package:numberia/features/number_trivia/domain/entities/number_trivia.dart';

class MockRemoteDataSource extends Mock
    implements NumberTriviaRemoteDataSource {}

class MockLocalDataSource extends Mock implements NumberTriviaLocalDataSource {}

// class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  late NumberTriviaRepositoryImpl repository;
  late MockRemoteDataSource mockRemoteDataSource;
  late MockLocalDataSource mockLocalDataSource;
  // MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteDataSource = MockRemoteDataSource();
    mockLocalDataSource = MockLocalDataSource();
    // mockNetworkInfo = MockNetworkInfo();

    repository = NumberTriviaRepositoryImpl(
      remote: mockRemoteDataSource,
      local: mockLocalDataSource,
      // networkInfo: mockNetworkInfo,
    );
  });

  void runTestOnline(Function body) {
    group('device is online', () {
      setUp(() {
        // Scenario
        // when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      body();
    });
  }

  void runTestOffline(Function body) {
    group('device is online', () {
      setUp(() {
        // Scenario
        // when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      body();
    });
  }

  group('getConcreteNumberTrivia', () {
    final testNumber = 1;
    final testNumberTriviaModel = NumberTriviaModel(
      text: "test text",
      number: testNumber,
    );
    final NumberTrivia testNumberTrivia = testNumberTriviaModel;

    test(
      'should check if the device is online',
      () async {
        // Arrange
        // when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        // Act
        repository.getConcreteNumberTrivia(testNumber);
        // Assert
        // verify(mockNetworkInfo.isConnected);
      },
    );

    runTestOnline(() {
      test(
        'should return remote data when the call to remote data source is successful',
        () async {
          // Arrange
          when(mockRemoteDataSource.getConcreteNumberTrivia(any as int))
              .thenAnswer((_) async => testNumberTriviaModel);
          // Act
          final result = await repository.getConcreteNumberTrivia(testNumber);
          // Assert
          verify(mockRemoteDataSource.getConcreteNumberTrivia(testNumber));
          expect(result, equals(Right(testNumberTrivia)));
        },
      );

      test(
        'should cache the data locally when the call to remote data source is successful',
        () async {
          // Arrange
          when(mockRemoteDataSource.getConcreteNumberTrivia(any as int))
              .thenAnswer((_) async => testNumberTriviaModel);
          // Act
          await repository.getConcreteNumberTrivia(testNumber);
          // Assert
          verify(mockRemoteDataSource.getConcreteNumberTrivia(testNumber));
          verify(mockLocalDataSource.cacheNumberTrivia(testNumberTriviaModel));
        },
      );

      test(
        'should return ServerFailure when the call to remote data source is unsuccessful',
        () async {
          // Arrange
          when(mockRemoteDataSource.getConcreteNumberTrivia(any as int))
              .thenThrow(ServerException());
          // Act
          final result = await repository.getConcreteNumberTrivia(testNumber);
          // Assert
          verify(mockRemoteDataSource.getConcreteNumberTrivia(testNumber));
          verifyZeroInteractions(mockLocalDataSource);
          expect(result, equals(Left(ServerFailure())));
        },
      );
    });

    runTestOffline(() {
      test(
        'should return last locally cached data when the cached data is present',
        () async {
          // Arrange
          when(mockLocalDataSource.getLastNumberTrivia())
              .thenAnswer((_) async => testNumberTriviaModel);
          // Act
          final result = await repository.getConcreteNumberTrivia(testNumber);
          // Assert
          verifyZeroInteractions(mockRemoteDataSource);
          verify(mockLocalDataSource.getLastNumberTrivia());
          expect(result, equals(Right(testNumberTrivia)));
        },
      );

      test(
        'should return CacheFailure when there is no cached data present',
        () async {
          // Arrange
          when(mockLocalDataSource.getLastNumberTrivia())
              .thenThrow(CacheException());
          // Act
          final result = await repository.getConcreteNumberTrivia(testNumber);
          // Assert
          verifyZeroInteractions(mockRemoteDataSource);
          verify(mockLocalDataSource.getLastNumberTrivia());
          expect(result, equals(Left(CacheFailure())));
        },
      );
    });
  });

  group('getRandomNumberTrivia', () {
    final testNumberTriviaModel = NumberTriviaModel(
      text: "test text",
      number: 1,
    );
    final NumberTrivia testNumberTrivia = testNumberTriviaModel;

    test(
      'should check if the device is online',
      () async {
        // Arrange
        // when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        // Act
        repository.getRandomNumberTrivia();
        // Assert
        // verify(mockNetworkInfo.isConnected);
      },
    );

    runTestOnline(() {
      test(
        'should return remote data when the call to remote data source is successful',
        () async {
          // Arrange
          when(mockRemoteDataSource.getRandomNumberTrivia())
              .thenAnswer((_) async => testNumberTriviaModel);
          // Act
          final result = await repository.getRandomNumberTrivia();
          // Assert
          verify(mockRemoteDataSource.getRandomNumberTrivia());
          expect(result, equals(Right(testNumberTrivia)));
        },
      );

      test(
        'should cache the data locally when the call to remote data source is successful',
        () async {
          // Arrange
          when(mockRemoteDataSource.getRandomNumberTrivia())
              .thenAnswer((_) async => testNumberTriviaModel);
          // Act
          await repository.getRandomNumberTrivia();
          // Assert
          verify(mockRemoteDataSource.getRandomNumberTrivia());
          verify(mockLocalDataSource.cacheNumberTrivia(testNumberTriviaModel));
        },
      );

      test(
        'should return ServerFailure when the call to remote data source is unsuccessful',
        () async {
          // Arrange
          when(mockRemoteDataSource.getRandomNumberTrivia())
              .thenThrow(ServerException());
          // Act
          final result = await repository.getRandomNumberTrivia();
          // Assert
          verify(mockRemoteDataSource.getRandomNumberTrivia());
          verifyZeroInteractions(mockLocalDataSource);
          expect(result, equals(Left(ServerFailure())));
        },
      );
    });

    runTestOffline(() {
      test(
        'should return last locally cached data when the cached data is present',
        () async {
          // Arrange
          when(mockLocalDataSource.getLastNumberTrivia())
              .thenAnswer((_) async => testNumberTriviaModel);
          // Act
          final result = await repository.getRandomNumberTrivia();
          // Assert
          verifyZeroInteractions(mockRemoteDataSource);
          verify(mockLocalDataSource.getLastNumberTrivia());
          expect(result, equals(Right(testNumberTrivia)));
        },
      );

      test(
        'should return CacheFailure when there is no cached data present',
        () async {
          // Arrange
          when(mockLocalDataSource.getLastNumberTrivia())
              .thenThrow(CacheException());
          // Act
          final result = await repository.getRandomNumberTrivia();
          // Assert
          verifyZeroInteractions(mockRemoteDataSource);
          verify(mockLocalDataSource.getLastNumberTrivia());
          expect(result, equals(Left(CacheFailure())));
        },
      );
    });
  });
}
