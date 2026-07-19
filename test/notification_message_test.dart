import 'package:flutter_test/flutter_test.dart';
import 'package:sfmc/notification_message.dart';
import 'dart:convert';

void main() {
  Map<String, dynamic> notificationJson({dynamic payload}) => {
        'id': 'notification_1',
        'alert': 'Test alert',
        'type': 'OTHER',
        'trigger': 'PUSH',
        if (payload != null) 'payload': payload,
      };

  group('NotificationMessage payload parsing', () {
    test('accepts payload as a Map (current Android wire format)', () {
      final message = NotificationMessage.fromJson(
          notificationJson(payload: {'_m': 'message_id', 'key': 'value'}));
      expect(message.payload, {'_m': 'message_id', 'key': 'value'});
    });

    test('accepts payload as a JSON-encoded String (older Android wire format)',
        () {
      final message = NotificationMessage.fromJson(notificationJson(
          payload: jsonEncode({'_m': 'message_id', 'key': 'value'})));
      expect(message.payload, {'_m': 'message_id', 'key': 'value'});
    });

    test('payload is null when absent', () {
      final message = NotificationMessage.fromJson(notificationJson());
      expect(message.payload, isNull);
    });
  });
}
