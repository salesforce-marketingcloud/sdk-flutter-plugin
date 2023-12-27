import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'sfmc_platform_interface.dart';

class MethodChannelSfmc extends SfmcPlatform {
  @visibleForTesting
  final methodChannel = const MethodChannel('sfmc');
}
