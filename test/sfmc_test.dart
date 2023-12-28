import 'package:flutter_test/flutter_test.dart';
import 'package:sfmc/sfmc.dart';
import 'package:sfmc/sfmc_platform_interface.dart';
import 'package:sfmc/sfmc_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockSfmcPlatform with MockPlatformInterfaceMixin implements SfmcPlatform {
  String recentCalledMethod = '';

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
}

void main() {
  final SfmcPlatform initialPlatform = SfmcPlatform.instance;
  late MockSfmcPlatform mockPlatform;

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
}
