import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:numberia/core/network/network_info.dart';
import 'package:numberia/core/util/input_converter.dart';
import 'package:numberia/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:numberia/features/number_trivia/data/sources/number_trivia_local_data_source.dart';
import 'package:numberia/features/number_trivia/data/sources/number_trivia_remote_data_source.dart';
import 'package:numberia/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:numberia/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:numberia/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:numberia/features/number_trivia/presentation/bloc/number_trivia_cubit.dart';
import 'package:numberia/main.dart';

final locator = GetIt.instance;

void init() {
  //! Features - Number Trivia
  initFeatures();
  //! Core
  initCore();
  //! External
  initExternal();
}

void initFeatures() {
  // Bloc
  locator.registerFactory<NumberTriviaCubit>(
    () => NumberTriviaCubit(
      inputConverter: locator<InputConverter>(),
      concrete: locator<GetConcreteNumberTrivia>(),
      random: locator<GetRandomNumberTrivia>(),
    ),
  );
  // Use cases
  locator.registerLazySingleton<GetConcreteNumberTrivia>(
      () => GetConcreteNumberTrivia(locator<NumberTriviaRepository>()));
  locator.registerLazySingleton<GetRandomNumberTrivia>(
      () => GetRandomNumberTrivia(locator<NumberTriviaRepository>()));
  // Repositories
  locator.registerLazySingleton<NumberTriviaRepository>(
    () => NumberTriviaRepositoryImpl(
      remote: locator<NumberTriviaRemoteDataSource>(),
      local: locator<NumberTriviaLocalDataSource>(),
      networkInfo: locator<NetworkInfo>(),
    ),
  );
  // Data Sources
  locator.registerLazySingleton<NumberTriviaRemoteDataSource>(
      () => NumberTriviaRemoteDataSourceImpl(locator<http.Client>()));
  locator.registerLazySingleton<NumberTriviaLocalDataSource>(
      () => NumberTriviaLocalDataSourceImpl(locator<Box>()));
}

void initCore() {
  locator.registerLazySingleton<InputConverter>(() => InputConverter());

  locator.registerLazySingleton<NetworkInfo>(
      () => NetworkInfoImpl(locator<DataConnectionChecker>()));
}

void initExternal() {
  locator.registerLazySingleton<Box>(() => Hive.box(CACHE_BOX));
  locator.registerLazySingleton<http.Client>(() => http.Client());
  locator.registerLazySingleton<DataConnectionChecker>(
      () => DataConnectionChecker());
}
