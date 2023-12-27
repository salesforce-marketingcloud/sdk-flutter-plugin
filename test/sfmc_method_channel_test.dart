import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sfmc/sfmc_method_channel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  MethodChannelSfmc platform = MethodChannelSfmc();
  const MethodChannel channel = MethodChannel('sfmc');

  setUp(() {
  });

  tearDown(() {
  });
}
