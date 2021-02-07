import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:numberia/core/error/failures.dart';
import 'package:numberia/core/usescases/use_case.dart';
import 'package:numberia/core/util/input_converter.dart';
import 'package:numberia/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:numberia/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:numberia/features/number_trivia/domain/usecases/get_random_number_trivia.dart';

part 'number_trivia_state.dart';

const String SERVER_FAILURE_MESSAGE = 'Server Failure';
const String CACHE_FAILURE_MESSAGE = 'Cache Failure';
const String INVALID_INPUT_FAILURE_MESSAGE = 'Invalid Input - The number must be a positive integer or zero.';

class NumberTriviaCubit extends Cubit<NumberTriviaState> {
  final InputConverter _inputConverter;
  final GetConcreteNumberTrivia _getConcreteNumberTrivia;
  final GetRandomNumberTrivia _getRandomNumberTrivia;

  NumberTriviaCubit({
    @required InputConverter inputConverter,
    @required GetConcreteNumberTrivia concrete,
    @required GetRandomNumberTrivia random,
  })  : assert(inputConverter != null),
        assert(concrete != null),
        assert(random != null),
        _inputConverter = inputConverter,
        _getConcreteNumberTrivia = concrete,
        _getRandomNumberTrivia = random,
        super(Empty());

  void getTriviaForConcreteNumber(String numberString) {
    final inputEither = _inputConverter.stringToUnsignedInteger(numberString);

    inputEither.fold(
      (failure) => emit(Error(message: INVALID_INPUT_FAILURE_MESSAGE)),
      (integer) async {
        emit(Loading());
        final failureOrTrivia =
            await _getConcreteNumberTrivia(Params(number: integer));

        _eitherLoadedOrErrorState(failureOrTrivia);
      },
    );
  }

  void getTriviaForRandomNumber() async {
    emit(Loading());
    final failureOrTrivia = await _getRandomNumberTrivia(NoParams());

    _eitherLoadedOrErrorState(failureOrTrivia);
  }

  void _eitherLoadedOrErrorState(
    Either<Failure, NumberTrivia> either,
  ) {
    either.fold(
      (failure) => emit(Error(message: _mapFailureToMessage(failure))),
      (trivia) => emit(Loaded(trivia: trivia)),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;
      case CacheFailure:
        return CACHE_FAILURE_MESSAGE;
      default:
        return 'Unexpected Error';
    }
  }
}
