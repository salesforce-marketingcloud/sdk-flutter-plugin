import 'package:flutter_test/flutter_test.dart';
import 'package:sfmc/sfmc.dart';
import 'package:sfmc/sfmc_platform_interface.dart';
import 'package:sfmc/sfmc_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockSfmcPlatform
    with MockPlatformInterfaceMixin
    implements SfmcPlatform {
}

void main() {
  final SfmcPlatform initialPlatform = SfmcPlatform.instance;
}
