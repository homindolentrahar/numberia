import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:numberia/core/error/failures.dart';
import 'package:numberia/core/usescases/use_case.dart';
import 'package:numberia/core/util/input_converter.dart';
import 'package:numberia/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:numberia/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:numberia/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:numberia/features/number_trivia/presentation/bloc/number_trivia_cubit.dart';

class MockInputConverter extends Mock implements InputConverter {}

class MockGetConcreteNumberTrivia extends Mock
    implements GetConcreteNumberTrivia {}

class MockGetRandomNumberTrivia extends Mock implements GetRandomNumberTrivia {}

void main() {
  MockInputConverter mockInputConverter;
  MockGetConcreteNumberTrivia mockConcrete;
  MockGetRandomNumberTrivia mockRandom;
  NumberTriviaCubit cubit;

  setUp(() {
    mockInputConverter = MockInputConverter();
    mockConcrete = MockGetConcreteNumberTrivia();
    mockRandom = MockGetRandomNumberTrivia();

    cubit = NumberTriviaCubit(
      inputConverter: mockInputConverter,
      concrete: mockConcrete,
      random: mockRandom,
    );
  });

  test('initialState should bbe Empty', () {
    //  assert
    expect(cubit.state, Empty());
  });

  group('GetTriviaForConcreteNumber', () {
    final testNumberString = "1";
    final testNumberParsed = 1;
    final testNumberTrivia = NumberTrivia(text: 'test text', number: 1);

    void setupMockInputConverterSuccess() =>
        when(mockInputConverter.stringToUnsignedInteger(any))
            .thenReturn(Right(testNumberParsed));

    void setupMockInputConverterFailure() =>
        when(mockInputConverter.stringToUnsignedInteger(any))
            .thenReturn(Left(InvalidInputFailure()));

    test(
      'should call the InputConverter to validate and convert the string to unsigned integer',
      () async {
        // Arrange
        setupMockInputConverterSuccess();
        // Act
        cubit.getTriviaForConcreteNumber(testNumberString);
        await untilCalled(mockInputConverter.stringToUnsignedInteger(any));
        // Assert
        verify(mockInputConverter.stringToUnsignedInteger(testNumberString));
      },
    );

    test(
      'should emit [Error] when the input is invalid',
      () async {
        // Arrange
        setupMockInputConverterFailure();
        // Assert later
        final emittedState = [Error(message: INVALID_INPUT_FAILURE_MESSAGE)];
        expectLater(cubit, emitsInOrder(emittedState));
        // Act
        cubit.getTriviaForConcreteNumber(testNumberString);
      },
    );

    test(
      'should get data from the concrete use case',
      () async {
        // Arrange
        setupMockInputConverterSuccess();
        when(mockConcrete(any))
            .thenAnswer((_) async => Right(testNumberTrivia));
        // Act
        cubit.getTriviaForConcreteNumber(testNumberString);
        await untilCalled(mockConcrete(any));
        // Assert
        verify(mockConcrete(Params(number: testNumberParsed)));
      },
    );

    test(
      'should emit [Loading, Loaded] when data is gotten successfully',
      () async {
        // Arrange
        setupMockInputConverterSuccess();
        when(mockConcrete(any))
            .thenAnswer((_) async => Right(testNumberTrivia));
        // Assert later
        final emittedState = [
          Loading(),
          Loaded(trivia: testNumberTrivia),
        ];
        expectLater(cubit, emitsInOrder(emittedState));
        // Act
        cubit.getTriviaForConcreteNumber(testNumberString);
      },
    );

    test(
      'should emit [Loading, Error] when getting data fails',
      () async {
        // Arrange
        setupMockInputConverterSuccess();
        when(mockConcrete(any)).thenAnswer((_) async => Left(ServerFailure()));
        // Assert later
        final emittedState = [
          Loading(),
          Error(message: SERVER_FAILURE_MESSAGE),
        ];
        expectLater(cubit, emitsInOrder(emittedState));
        // Assert
        cubit.getTriviaForConcreteNumber(testNumberString);
      },
    );

    test(
      'should emit [Loading, Error] with proper message for the error when getting data fails',
      () async {
        // Arrange
        setupMockInputConverterSuccess();
        when(mockConcrete(any)).thenAnswer((_) async => Left(CacheFailure()));
        // Assert later
        final emittedState = [
          Loading(),
          Error(message: CACHE_FAILURE_MESSAGE),
        ];
        expectLater(cubit, emitsInOrder(emittedState));
        // Assert
        cubit.getTriviaForConcreteNumber(testNumberString);
      },
    );
  });

  group('GetTriviaForRandomNumber', () {
    final testNumberTrivia = NumberTrivia(text: 'test text', number: 1);

    test(
      'should get data from the random use case',
      () async {
        // Arrange
        when(mockRandom(any)).thenAnswer((_) async => Right(testNumberTrivia));
        // Act
        cubit.getTriviaForRandomNumber();
        await untilCalled(mockRandom(any));
        // Assert
        verify(mockRandom(NoParams()));
      },
    );

    test(
      'should emit [Loading, Loaded] when data is gotten successfully',
      () async {
        // Arrange
        when(mockRandom(any))
            .thenAnswer((_) async => Right(testNumberTrivia));
        // Assert later
        final emittedState = [
          Loading(),
          Loaded(trivia: testNumberTrivia),
        ];
        expectLater(cubit, emitsInOrder(emittedState));
        // Act
        cubit.getTriviaForRandomNumber();
      },
    );

    test(
      'should emit [Loading, Error] when getting data fails',
      () async {
        // Arrange
        when(mockRandom(any)).thenAnswer((_) async => Left(ServerFailure()));
        // Assert later
        final emittedState = [
          Loading(),
          Error(message: SERVER_FAILURE_MESSAGE),
        ];
        expectLater(cubit, emitsInOrder(emittedState));
        // Assert
        cubit.getTriviaForRandomNumber();
      },
    );

    test(
      'should emit [Loading, Error] with proper message for the error when getting data fails',
      () async {
        // Arrange
        when(mockRandom(any)).thenAnswer((_) async => Left(CacheFailure()));
        // Assert later
        final emittedState = [
          Loading(),
          Error(message: CACHE_FAILURE_MESSAGE),
        ];
        expectLater(cubit, emitsInOrder(emittedState));
        // Assert
        cubit.getTriviaForRandomNumber();
      },
    );
  });
}
