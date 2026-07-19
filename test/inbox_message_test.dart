import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sfmc/inbox_message.dart';
import 'package:sfmc/sfmc_method_channel.dart';
import 'dart:convert';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Map<String, dynamic> messageJson(String id, {dynamic sendDateUtc}) {
    return {
      'id': id,
      'subject': 'Subject $id',
      'title': 'Title $id',
      'alert': 'Alert $id',
      'deleted': false,
      'read': false,
      'url': 'https://example.com/$id',
      if (sendDateUtc != null) 'sendDateUtc': sendDateUtc,
    };
  }

  group('InboxMessage.fromJson date parsing', () {
    test('parses ISO-8601 UTC format emitted by both native bridges', () {
      final message = InboxMessage.fromJson(
          messageJson('1', sendDateUtc: '2026-05-02T05:28:00Z'));
      expect(message.sendDateUtc, DateTime.utc(2026, 5, 2, 5, 28, 0));
      expect(message.sendDateUtc!.isUtc, true);
    });

    test('parses legacy space-separated format without milliseconds', () {
      final message = InboxMessage.fromJson(
          messageJson('1', sendDateUtc: '2026-05-02 05:28:00'));
      expect(message.sendDateUtc, DateTime(2026, 5, 2, 5, 28, 0));
    });

    test('parses legacy space-separated format with milliseconds', () {
      final message = InboxMessage.fromJson(
          messageJson('1', sendDateUtc: '2026-05-02 05:28:00.000'));
      expect(message.sendDateUtc, DateTime(2026, 5, 2, 5, 28, 0));
    });

    test('parses legacy 12-hour AM format with offset', () {
      final message = InboxMessage.fromJson(
          messageJson('1', sendDateUtc: '2026-05-02 3:56:00 AM +0000'));
      expect(message.sendDateUtc, DateTime.utc(2026, 5, 2, 3, 56, 0));
    });

    test('parses legacy 12-hour PM format with offset', () {
      final message = InboxMessage.fromJson(
          messageJson('1', sendDateUtc: '2026-05-02 3:56:00 PM +0000'));
      expect(message.sendDateUtc, DateTime.utc(2026, 5, 2, 15, 56, 0));
    });

    test('parses legacy 12-hour edge cases 12 AM and 12 PM', () {
      final midnight = InboxMessage.fromJson(
          messageJson('1', sendDateUtc: '2026-05-02 12:05:00 AM +0000'));
      expect(midnight.sendDateUtc, DateTime.utc(2026, 5, 2, 0, 5, 0));

      final noon = InboxMessage.fromJson(
          messageJson('1', sendDateUtc: '2026-05-02 12:05:00 PM +0000'));
      expect(noon.sendDateUtc, DateTime.utc(2026, 5, 2, 12, 5, 0));
    });

    test('applies non-zero UTC offsets', () {
      final message = InboxMessage.fromJson(
          messageJson('1', sendDateUtc: '2026-05-02 8:56:00 AM +05:30'));
      expect(message.sendDateUtc, DateTime.utc(2026, 5, 2, 3, 26, 0));

      final negative = InboxMessage.fromJson(
          messageJson('1', sendDateUtc: '2026-05-02 3:56:00 AM -0400'));
      expect(negative.sendDateUtc, DateTime.utc(2026, 5, 2, 7, 56, 0));
    });

    test('returns null instead of throwing for unparseable dates', () {
      final message = InboxMessage.fromJson(
          messageJson('1', sendDateUtc: 'not a date'));
      expect(message.sendDateUtc, null);

      final nonLatin = InboxMessage.fromJson(
          messageJson('1', sendDateUtc: '٢٠٢٦-٠٥-٠٢ ٠٥:٢٨:٠٠'));
      expect(nonLatin.sendDateUtc, null);
    });

    test('returns null for non-string and empty values', () {
      expect(InboxMessage.fromJson(messageJson('1', sendDateUtc: 12345))
          .sendDateUtc, null);
      expect(InboxMessage.fromJson(messageJson('1', sendDateUtc: ''))
          .sendDateUtc, null);
      expect(InboxMessage.fromJson(messageJson('1')).sendDateUtc, null);
    });

    test('parses all three date fields', () {
      final json = messageJson('1');
      json['startDateUtc'] = '2026-05-01T00:00:00Z';
      json['sendDateUtc'] = '2026-05-02T05:28:00Z';
      json['endDateUtc'] = '2026-05-03 3:56:00 AM +0000';
      final message = InboxMessage.fromJson(json);
      expect(message.startDateUtc, DateTime.utc(2026, 5, 1));
      expect(message.sendDateUtc, DateTime.utc(2026, 5, 2, 5, 28, 0));
      expect(message.endDateUtc, DateTime.utc(2026, 5, 3, 3, 56, 0));
    });
  });

  group('Malformed inbox messages are skipped', () {
    MethodChannelSfmc platform = MethodChannelSfmc();
    const MethodChannel channel = MethodChannel('sfmc');

    final String goodMessage = jsonEncode(
        messageJson('good', sendDateUtc: '2026-05-02T05:28:00Z'));
    const String malformedMessage = '{"id": "bad", not valid json';

    tearDown(() {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, null);
    });

    test('getMessages skips a malformed message instead of failing', () async {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
        if (methodCall.method == 'getMessages') {
          return [malformedMessage, goodMessage];
        }
        return null;
      });

      final messages = await platform.getMessages();
      expect(messages.length, 1);
      expect(messages[0].id, 'good');
      expect(messages[0].sendDateUtc, DateTime.utc(2026, 5, 2, 5, 28, 0));
    });

    test('message with an unparseable date is kept with a null date',
        () async {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
        if (methodCall.method == 'getMessages') {
          return [
            jsonEncode(messageJson('legacy',
                sendDateUtc: '2026-05-02 3:56:00 AM +0000')),
            jsonEncode(messageJson('broken', sendDateUtc: 'not a date')),
          ];
        }
        return null;
      });

      final messages = await platform.getMessages();
      expect(messages.length, 2);
      expect(messages[0].id, 'legacy');
      expect(messages[0].sendDateUtc, DateTime.utc(2026, 5, 2, 3, 56, 0));
      expect(messages[1].id, 'broken');
      expect(messages[1].sendDateUtc, null);
    });

    test('onInboxMessagesChanged delivers remaining messages when one is malformed',
        () async {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
        return null;
      });

      List<InboxMessage>? receivedMessages;
      listener(List<InboxMessage> messages) {
        receivedMessages = messages;
      }

      await platform.registerInboxResponseListener(listener);

      await TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .handlePlatformMessage(
        'sfmc',
        const StandardMethodCodec().encodeMethodCall(
            MethodCall('onInboxMessagesChanged',
                [malformedMessage, goodMessage])),
        (ByteData? data) {},
      );

      expect(receivedMessages, isNotNull);
      expect(receivedMessages!.length, 1);
      expect(receivedMessages![0].id, 'good');

      await platform.unregisterInboxResponseListener(listener);
    });
  });
}
