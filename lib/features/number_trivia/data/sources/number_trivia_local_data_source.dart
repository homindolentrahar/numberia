import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:numberia/core/error/exceptions.dart';
import 'package:numberia/features/number_trivia/data/models/number_trivia_model.dart';

abstract class NumberTriviaLocalDataSource {
  /// Get the cached [NumberTriviaModel] which was gotten the last time
  /// the user had an Internet connection
  ///
  /// Throws [CacheException] if no cached data is present.
  Future<NumberTriviaModel> getLastNumberTrivia();

  Future<void> cacheNumberTrivia(NumberTriviaModel model);
}

const CACHED = "CACHED";

class NumberTriviaLocalDataSourceImpl implements NumberTriviaLocalDataSource {
  final Box box;

  NumberTriviaLocalDataSourceImpl(this.box);

  @override
  Future<NumberTriviaModel> getLastNumberTrivia() {
    final jsonString = box.get(CACHED);
    if (jsonString != null) {
      return Future.value(NumberTriviaModel.fromJson(json.decode(jsonString)));
    } else {
      throw CacheException();
    }
  }

  @override
  Future<void> cacheNumberTrivia(NumberTriviaModel model) {
    final data = json.encode(model.toJson());
    return box.put(CACHED, data);
  }
}
