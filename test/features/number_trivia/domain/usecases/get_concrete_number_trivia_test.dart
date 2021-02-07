import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:numberia/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:numberia/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:numberia/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';

class MockNumberTriviaRepository extends Mock
    implements NumberTriviaRepository {}

void main() {
  GetConcreteNumberTrivia useCase;
  MockNumberTriviaRepository mockRepository;

  setUp(() {
    mockRepository = MockNumberTriviaRepository();
    useCase = GetConcreteNumberTrivia(mockRepository);
  });

  final testNumber = 1;
  final testNumberTrivia = NumberTrivia(text: "test", number: testNumber);

  test(
    'should get trivia for the number from the repository',
    () async {
      // Arrange
      when(mockRepository.getConcreteNumberTrivia(any))
          .thenAnswer((_) async => Right(testNumberTrivia));
      // Act
      final result = await useCase(Params(number: testNumber));
      // Assert
      expect(result, Right(testNumberTrivia));
      verify(mockRepository.getConcreteNumberTrivia(testNumber));
      verifyNoMoreInteractions(mockRepository);
    },
  );
}
