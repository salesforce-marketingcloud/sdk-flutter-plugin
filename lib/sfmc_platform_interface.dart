import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'sfmc_method_channel.dart';

abstract class SfmcPlatform extends PlatformInterface {
  /// Constructs a SfmcPlatform.
  SfmcPlatform() : super(token: _token);

  static final Object _token = Object();

  static SfmcPlatform _instance = MethodChannelSfmc();

  /// The default instance of [SfmcPlatform] to use.
  ///
  /// Defaults to [MethodChannelSfmc].
  static SfmcPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [SfmcPlatform] when
  /// they register themselves.
  static set instance(SfmcPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }
}
