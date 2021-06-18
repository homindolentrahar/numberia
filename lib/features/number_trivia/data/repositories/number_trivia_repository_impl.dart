import 'package:dartz/dartz.dart';
import 'package:numberia/core/error/exceptions.dart';
import 'package:numberia/core/error/failures.dart';
import 'package:numberia/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:numberia/features/number_trivia/data/sources/number_trivia_local_data_source.dart';
import 'package:numberia/features/number_trivia/data/sources/number_trivia_remote_data_source.dart';
import 'package:numberia/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:numberia/features/number_trivia/domain/repositories/number_trivia_repository.dart';

typedef Future<NumberTrivia> _ConcreteOrRandomChooser();

class NumberTriviaRepositoryImpl implements NumberTriviaRepository {
  final NumberTriviaRemoteDataSource? remote;
  final NumberTriviaLocalDataSource? local;

  // final NetworkInfo networkInfo;

  NumberTriviaRepositoryImpl({
    required this.remote,
    required this.local,
    // @required this.networkInfo,
  });

  @override
  Future<Either<Failure, NumberTrivia>> getConcreteNumberTrivia(
      int number) async {
    return await _getTrivia(() => remote!.getConcreteNumberTrivia(number));
  }

  @override
  Future<Either<Failure, NumberTrivia>> getRandomNumberTrivia() async {
    return await _getTrivia(() => remote!.getRandomNumberTrivia());
  }

  Future<Either<Failure, NumberTrivia>> _getTrivia(
    _ConcreteOrRandomChooser getConcreteOrRandom,
  ) async {
    final isConnected = true;

    if (isConnected) {
      try {
        final remoteTrivia = await getConcreteOrRandom();
        local!.cacheNumberTrivia(remoteTrivia as NumberTriviaModel);
        return Right(remoteTrivia);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final localTrivia = await local!.getLastNumberTrivia();
        return Right(localTrivia);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }
}
