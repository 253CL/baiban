import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shanyan/shanyan.dart';

void main() {
  const MethodChannel channel = MethodChannel('shanyan');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await ClShanyan.getShanyanVersion(), '42');
  });
}
