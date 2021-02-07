import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:numberia/core/usescases/use_case.dart';
import 'package:numberia/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:numberia/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:numberia/features/number_trivia/domain/usecases/get_random_number_trivia.dart';

class MockNumberTriviaRepository extends Mock
    implements NumberTriviaRepository {}

void main() {
  GetRandomNumberTrivia useCase;
  MockNumberTriviaRepository mockRepository;

  setUp(() {
    mockRepository = MockNumberTriviaRepository();
    useCase = GetRandomNumberTrivia(mockRepository);
  });

  final testNumberTrivia = NumberTrivia(text: "test", number: 1);

  test(
    'should get trivia from the repository',
        () async {
      // Arrange
      when(mockRepository.getRandomNumberTrivia())
          .thenAnswer((_) async => Right(testNumberTrivia));
      // Act
      final result = await useCase(NoParams());
      // Assert
      expect(result, Right(testNumberTrivia));
      verify(mockRepository.getRandomNumberTrivia());
      verifyNoMoreInteractions(mockRepository);
    },
  );
}
