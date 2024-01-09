import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'sfmc_method_channel.dart';

abstract class SfmcPlatform extends PlatformInterface {
  /// Constructs a SfmcPlatform.
  SfmcPlatform() : super(token: _token);

  static final Object _token = Object();

  static SfmcPlatform _instance = MethodChannelSfmc();

  static SfmcPlatform get instance => _instance;

  static set instance(SfmcPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getSystemToken() {
    throw UnimplementedError('getSystemToken() has not been implemented.');
  }

  Future<bool?> isPushEnabled() {
    throw UnimplementedError('isPushEnabled() has not been implemented.');
  }

  Future<void> enablePush() {
    throw UnimplementedError('enablePush() has not been implemented.');
  }

  Future<void> disablePush() {
    throw UnimplementedError('disablePush() has not been implemented.');
  }

  Future<void> enableLogging() {
    throw UnimplementedError('enableLogging() has not been implemented.');
  }

  Future<void> disableLogging() {
    throw UnimplementedError('disableLogging() has not been implemented.');
  }

  Future<void> logSdkState() {
    throw UnimplementedError('logSdkState() has not been implemented.');
  }

  Future<String?> getDeviceId() {
    throw UnimplementedError('getDeviceId() has not been implemented.');
  }

  Future<Map<Object?, Object?>?> getAttributes() {
    throw UnimplementedError('getAttributes() has not been implemented.');
  }

  Future<void> setAttribute(String key, String value) {
    throw UnimplementedError('setAttribute() has not been implemented.');
  }

  Future<void> clearAttribute(String key) {
    throw UnimplementedError('clearAttribute() has not been implemented.');
  }

  Future<void> addTag(String tag) {
    throw UnimplementedError('addTag() has not been implemented.');
  }

  Future<void> removeTag(String tag) {
    throw UnimplementedError('removeTag() has not been implemented.');
  }

  Future<List<Object?>?> getTags() {
    throw UnimplementedError('getTags() has not been implemented.');
  }

  Future<void> setContactKey(String contactKey) {
    throw UnimplementedError('setContactKey() has not been implemented.');
  }

  Future<String?> getContactKey() {
    throw UnimplementedError('getContactKey() has not been implemented.');
  }
}
