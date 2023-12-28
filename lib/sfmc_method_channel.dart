import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'sfmc_platform_interface.dart';

class MethodChannelSfmc extends SfmcPlatform {
  @visibleForTesting
  final methodChannel = const MethodChannel('sfmc');

  @override
  Future<String?> getSystemToken() {
    return methodChannel.invokeMethod<String>('getSystemToken');
  }

  @override
  Future<bool?> isPushEnabled() {
    return methodChannel.invokeMethod<bool>('isPushEnabled');
  }

  @override
  Future<void> enablePush() {
    return methodChannel.invokeMethod('enablePush');
  }

  @override
  Future<void> disablePush() {
    return methodChannel.invokeMethod('disablePush');
  }

  @override
  Future<void> enableLogging() {
    return methodChannel.invokeMethod('enableLogging');
  }

  @override
  Future<void> disableLogging() {
    return methodChannel.invokeMethod('disableLogging');
  }

  @override
  Future<void> logSdkState() {
    return methodChannel.invokeMethod('logSdkState');
  }

  @override
  Future<String?> getDeviceId() {
    return methodChannel.invokeMethod<String>('getDeviceId');
  }
}
