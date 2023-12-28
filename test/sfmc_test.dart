import 'package:flutter_test/flutter_test.dart';
import 'package:sfmc/sfmc.dart';
import 'package:sfmc/sfmc_platform_interface.dart';
import 'package:sfmc/sfmc_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockSfmcPlatform with MockPlatformInterfaceMixin implements SfmcPlatform {
  String recentCalledMethod = '';
  final Map<Object?, Object?> mockAttributes = {};
  final List<Object?> mockTags = [];
  String? mockContactKey;

  void _logCall(String methodName) {
    recentCalledMethod = methodName;
  }

  @override
  Future<String?> getSystemToken() {
    _logCall('getSystemToken');
    return Future.value('mock_token');
  }

  @override
  Future<bool?> isPushEnabled() {
    _logCall('isPushEnabled');
    return Future.value(true);
  }

  @override
  Future<void> enablePush() async {
    _logCall('enablePush');
  }

  @override
  Future<void> disablePush() async {
    _logCall('disablePush');
  }

  @override
  Future<void> enableLogging() async {
    _logCall('enableLogging');
  }

  @override
  Future<void> disableLogging() async {
    _logCall('disableLogging');
  }

  @override
  Future<void> logSdkState() async {
    _logCall('logSdkState');
  }

  @override
  Future<String?> getDeviceId() {
    _logCall('getDeviceId');
    return Future.value('mock_device_id');
  }

  @override
  Future<Map<Object?, Object?>?> getAttributes() {
    _logCall('getAttributes');
    return Future.value(mockAttributes);
  }

  @override
  Future<void> setAttribute(String key, String value) async {
    _logCall('setAttribute');
    mockAttributes[key] = value;
  }

  @override
  Future<void> clearAttribute(String key) async {
    _logCall('clearAttribute');
    mockAttributes[key] = null;
  }

  @override
  Future<void> addTag(String tag) async {
    _logCall('addTag');
    mockTags.add(tag);
  }

  @override
  Future<void> removeTag(String tag) async {
    _logCall('removeTag');
    mockTags.remove(tag);
  }

  @override
  Future<List<Object?>?> getTags() {
    _logCall('getTags');
    return Future.value(mockTags);
  }

  @override
  Future<void> setContactKey(String contactKey) async {
    _logCall('setContactKey');
    mockContactKey = contactKey;
  }

  @override
  Future<String?> getContactKey() {
    _logCall('getContactKey');
    return Future.value(mockContactKey);
  }
}

void main() {
  final SfmcPlatform initialPlatform = SfmcPlatform.instance;
  late MockSfmcPlatform mockPlatform;
  const String testKey = 'testKey';
  const String testValue = 'testValue';
  const String testTag = 'testTag';
  const String testContactKey = 'testContactKey';

  setUp(() {
    mockPlatform = MockSfmcPlatform();
    SfmcPlatform.instance = mockPlatform;
  });

  tearDown(() {
    SfmcPlatform.instance = initialPlatform;
  });

  test('getSystemToken', () async {
    expect(await SFMCSdk.getSystemToken(), 'mock_token');
    expect(mockPlatform.recentCalledMethod, 'getSystemToken');
  });

  test('isPushEnabled', () async {
    expect(await SFMCSdk.isPushEnabled(), true);
    expect(mockPlatform.recentCalledMethod, 'isPushEnabled');
  });

  test('enablePush', () async {
    await SFMCSdk.enablePush();
    expect(mockPlatform.recentCalledMethod, 'enablePush');
  });

  test('disablePush', () async {
    await SFMCSdk.disablePush();
    expect(mockPlatform.recentCalledMethod, 'disablePush');
  });

  test('enableLogging', () async {
    await SFMCSdk.enableLogging();
    expect(mockPlatform.recentCalledMethod, 'enableLogging');
  });

  test('disableLogging', () async {
    await SFMCSdk.disableLogging();
    expect(mockPlatform.recentCalledMethod, 'disableLogging');
  });

  test('logSdkState', () async {
    await SFMCSdk.logSdkState();
    expect(mockPlatform.recentCalledMethod, 'logSdkState');
  });

  test('getDeviceId', () async {
    expect(await SFMCSdk.getDeviceId(), 'mock_device_id');
    expect(mockPlatform.recentCalledMethod, 'getDeviceId');
  });

  test('getAttributes', () async {
    mockPlatform.mockAttributes[testKey] = testValue;
    expect(await SFMCSdk.getAttributes(), equals(mockPlatform.mockAttributes));
    expect(mockPlatform.recentCalledMethod, 'getAttributes');
  });

  test('setAttribute', () async {
    await SFMCSdk.setAttribute(testKey, testValue);
    expect(mockPlatform.mockAttributes[testKey], equals(testValue));
    expect(mockPlatform.recentCalledMethod, 'setAttribute');
  });

  test('clearAttribute', () async {
    mockPlatform.mockAttributes[testKey] = testValue;
    await SFMCSdk.clearAttribute(testKey);
    expect(mockPlatform.mockAttributes[testKey], isNull);
    expect(mockPlatform.recentCalledMethod, 'clearAttribute');
  });

  test('addTag', () async {
    await SFMCSdk.addTag(testTag);
    expect(mockPlatform.mockTags.contains(testTag), isTrue);
    expect(mockPlatform.recentCalledMethod, 'addTag');
  });

  test('removeTag', () async {
    mockPlatform.mockTags.add(testTag);
    await SFMCSdk.removeTag(testTag);
    expect(mockPlatform.mockTags.contains(testTag), isFalse);
    expect(mockPlatform.recentCalledMethod, 'removeTag');
  });

  test('getTags', () async {
    mockPlatform.mockTags.add(testTag);
    expect(await SFMCSdk.getTags(), equals(mockPlatform.mockTags));
    expect(mockPlatform.recentCalledMethod, 'getTags');
  });

  test('setContactKey', () async {
    await SFMCSdk.setContactKey(testContactKey);
    expect(mockPlatform.mockContactKey, equals(testContactKey));
    expect(mockPlatform.recentCalledMethod, 'setContactKey');
  });

  test('getContactKey', () async {
    mockPlatform.mockContactKey = testContactKey;
    expect(await SFMCSdk.getContactKey(), equals(testContactKey));
    expect(mockPlatform.recentCalledMethod, 'getContactKey');
  });
}
