// import 'package:mockito/mockito.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:numberia/core/network/network_info.dart';
//
// class MockDataConnectionChecker extends Mock implements DataConnectionChecker {}
//
// void main() {
//   NetworkInfoImpl networkInfoImpl;
//   MockDataConnectionChecker mockDataConnectionChecker;
//
//   setUp(() {
//     mockDataConnectionChecker = MockDataConnectionChecker();
//     networkInfoImpl = NetworkInfoImpl(mockDataConnectionChecker);
//   });
//
//   group('isConnected', () {
//     test(
//       'should forward the call to DataConnectionChecker.hasConnection',
//       () async {
//         // Arrange
//         final testHasConnectionFuture = Future.value(true);
//
//         when(mockDataConnectionChecker.hasConnection)
//             .thenAnswer((_) => testHasConnectionFuture);
//         // Act
//         final result = networkInfoImpl.isConnected;
//         // Assert
//         verify(mockDataConnectionChecker.hasConnection);
//         expect(result, testHasConnectionFuture);
//       },
//     );
//   });
// }
