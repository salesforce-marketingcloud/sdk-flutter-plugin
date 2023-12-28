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

  test('getAttributes', () async {
    const testAttributes = {"key1": "value1", "key2": "value2"};
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
      if (methodCall.method == 'getAttributes') {
        return testAttributes;
      }
    });

    expect(await platform.getAttributes(), testAttributes);
  });

  test('setAttribute', () async {
    bool methodCalled = false;
    const String key = "testKey";
    const String value = "testValue";

    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
      if (methodCall.method == 'setAttribute' &&
          methodCall.arguments["key"] == key &&
          methodCall.arguments["value"] == value) {
        methodCalled = true;
      }
    });

    await platform.setAttribute(key, value);
    expect(methodCalled, true);
  });

  test('clearAttribute', () async {
    bool methodCalled = false;
    const String key = "testKey";

    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
      if (methodCall.method == 'clearAttribute' &&
          methodCall.arguments["key"] == key) {
        methodCalled = true;
      }
    });

    await platform.clearAttribute(key);
    expect(methodCalled, true);
  });

  test('addTag', () async {
    bool methodCalled = false;
    const String tag = "testTag";

    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
      if (methodCall.method == 'addTag' && methodCall.arguments["tag"] == tag) {
        methodCalled = true;
      }
    });

    await platform.addTag(tag);
    expect(methodCalled, true);
  });

  test('removeTag', () async {
    bool methodCalled = false;
    const String tag = "testTag";

    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
      if (methodCall.method == 'removeTag' &&
          methodCall.arguments["tag"] == tag) {
        methodCalled = true;
      }
    });

    await platform.removeTag(tag);
    expect(methodCalled, true);
  });

  test('getTags', () async {
    const testTags = ["tag1", "tag2"];
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
      if (methodCall.method == 'getTags') {
        return testTags;
      }
    });

    expect(await platform.getTags(), testTags);
  });

  test('setContactKey', () async {
    bool methodCalled = false;
    const String contactKey = "testContactKey";

    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
      if (methodCall.method == 'setContactKey' &&
          methodCall.arguments["contactKey"] == contactKey) {
        methodCalled = true;
      }
    });

    await platform.setContactKey(contactKey);
    expect(methodCalled, true);
  });

  test('getContactKey', () async {
    const String testContactKey = "contactKey_123";
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
      if (methodCall.method == 'getContactKey') {
        return testContactKey;
      }
    });

    expect(await platform.getContactKey(), testContactKey);
  });
}
