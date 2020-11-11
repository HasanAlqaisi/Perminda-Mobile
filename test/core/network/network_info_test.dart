import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:perminda/core/network/network_info.dart';

class MockConnectionChecker extends Mock implements DataConnectionChecker {}

void main() {
  MockConnectionChecker connectionChecker;
  NetWorkInfoImpl netWorkInfo;

  setUp(() {
    connectionChecker = MockConnectionChecker();
    netWorkInfo = NetWorkInfoImpl(connectionChecker: connectionChecker);
  });

  test('should return true if user has connection', () async{
    when(connectionChecker.hasConnection).thenAnswer((_) async => true);

    final result = await netWorkInfo.isConnected();

    expect(result, true);
  });


  test('should return false if user has NO connection', () async{
    when(connectionChecker.hasConnection).thenAnswer((_) async => false);

    final result = await netWorkInfo.isConnected();

    expect(result, false);
  });
}
