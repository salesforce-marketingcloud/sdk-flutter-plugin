import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sfmc/sfmc_method_channel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  MethodChannelSfmc platform = MethodChannelSfmc();
  const MethodChannel channel = MethodChannel('sfmc');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      channel,
      (MethodCall methodCall) async {
        switch (methodCall.method) {
          case 'getSystemToken':
            return 'token_123';
          case 'isPushEnabled':
            return true;
          case 'getDeviceId':
            return 'device_123';
          default:
            return null;
        }
      },
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  test('getSystemToken', () async {
    expect(await platform.getSystemToken(), 'token_123');
  });

  test('isPushEnabled', () async {
    expect(await platform.isPushEnabled(), true);
  });

  test('getDeviceId', () async {
    expect(await platform.getDeviceId(), 'device_123');
  });

  test('enablePush', () async {
    bool methodCalled = false;
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
      if (methodCall.method == 'enablePush') {
        methodCalled = true;
      }
    });

    await platform.enablePush();
    expect(methodCalled, true);
  });

  test('disablePush', () async {
    bool methodCalled = false;
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
      if (methodCall.method == 'disablePush') {
        methodCalled = true;
      }
    });

    await platform.disablePush();
    expect(methodCalled, true);
  });

  test('enableLogging', () async {
    bool methodCalled = false;
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
      if (methodCall.method == 'enableLogging') {
        methodCalled = true;
      }
    });

    await platform.enableLogging();
    expect(methodCalled, true);
  });

  test('disableLogging', () async {
    bool methodCalled = false;
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
      if (methodCall.method == 'disableLogging') {
        methodCalled = true;
      }
    });

    await platform.disableLogging();
    expect(methodCalled, true);
  });

  test('logSdkState', () async {
    bool methodCalled = false;
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
      if (methodCall.method == 'logSdkState') {
        methodCalled = true;
      }
    });

    await platform.logSdkState();
    expect(methodCalled, true);
  });
}
