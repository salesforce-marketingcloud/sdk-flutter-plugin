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

  @override
  Future<Map<Object?, Object?>?> getAttributes() async {
    return methodChannel.invokeMethod<Map<Object?, Object?>>('getAttributes');
  }

  @override
  Future<void> setAttribute(String key, String value) {
    return methodChannel
        .invokeMethod('setAttribute', {"key": key, "value": value});
  }

  @override
  Future<void> clearAttribute(String key) {
    return methodChannel.invokeMethod('clearAttribute', {"key": key});
  }

  @override
  Future<void> addTag(String tag) {
    return methodChannel.invokeMethod('addTag', {"tag": tag});
  }

  @override
  Future<void> removeTag(String tag) {
    return methodChannel.invokeMethod('removeTag', {"tag": tag});
  }

  @override
  Future<List<Object?>?> getTags() {
    return methodChannel.invokeMethod<List<Object?>>('getTags');
  }

  @override
  Future<void> setContactKey(String contactKey) {
    return methodChannel
        .invokeMethod('setContactKey', {"contactKey": contactKey});
  }

  @override
  Future<String?> getContactKey() {
    return methodChannel.invokeMethod<String>('getContactKey');
  }
}
