import 'dart:convert';
import 'notification_message.dart';
import 'custom_keys_parser.dart';

class InboxMessage {
  final String id;
  final String? title;
  final String? alert;
  final String? custom;
  final Map<String, String>? customKeys;
  bool deleted;
  final DateTime? endDateUtc;
  bool read;
  final DateTime? sendDateUtc;
  final String? sound;
  final DateTime? startDateUtc;
  final String? subject;
  final String? url;
  final Media? media;
  final String? subtitle;
  final String? inboxMessage;
  final String? inboxSubtitle;
  final NotificationMessage? notificationMessage;
  final int? messageType;

  InboxMessage(
      {required this.id,
      this.title,
      this.alert,
      this.custom,
      this.customKeys,
      required this.deleted,
      this.endDateUtc,
      required this.read,
      this.sendDateUtc,
      this.sound,
      this.startDateUtc,
      this.subject,
      this.url,
      this.media,
      this.subtitle,
      this.inboxMessage,
      this.inboxSubtitle,
      this.notificationMessage,
      this.messageType});

  factory InboxMessage.fromJson(Map<String, dynamic> json) {
    final customKeys = CustomKeysParser.parseCustomKeys(json['keys']);
    return InboxMessage(
      id: json['id'] ?? '',
      subject: json['subject'] ?? '',
      title: json['title'] ?? '',
      alert: json['alert'] ?? '',
      sound: json['sound'] ?? '',
      media: json['media'] != null ? Media.fromJson(json['media']) : null,
      startDateUtc: _parseDate(json['startDateUtc']),
      endDateUtc: _parseDate(json['endDateUtc']),
      sendDateUtc: _parseDate(json['sendDateUtc']),
      url: json['url'] ?? '',
      custom: json['custom'] ?? '',
      customKeys: customKeys,
      deleted: json['deleted'] ?? false,
      read: json['read'] ?? false,
      subtitle: json['subtitle'],
      inboxMessage: json['inboxMessage'],
      inboxSubtitle: json['inboxSubtitle'],
      notificationMessage: json['notificationMessage'] != null
          ? NotificationMessage.fromJson(json['notificationMessage'])
          : null,
      messageType: json['messageType'],
    );
  }

  /// Parses a date value received from the native SDKs.
  ///
  /// Both native bridges emit ISO-8601 UTC strings, and the legacy 24-hour
  /// forms (`2026-05-02 05:28:00`, with `.SSS` or a `±hhmm` offset) are also
  /// valid [DateTime.tryParse] input. Anything else — such as the
  /// locale-dependent 12-hour strings old plugin versions produced on
  /// 12-hour-clock devices — returns `null` instead of throwing, so a single
  /// unparseable date can never fail a message list. Those strings crashed
  /// the old unguarded `DateTime.parse` anyway, so `null` is no regression.
  static DateTime? _parseDate(dynamic value) {
    if (value is! String || value.isEmpty) {
      return null;
    }
    return DateTime.tryParse(value.trim());
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'subject': subject,
      'title': title,
      'alert': alert,
      'sound': sound,
      'media': media?.toJson(),
      'startDateUtc': startDateUtc?.toIso8601String(),
      'endDateUtc': endDateUtc?.toIso8601String(),
      'sendDateUtc': sendDateUtc?.toIso8601String(),
      'url': url,
      'custom': custom,
      'customKeys': customKeys,
      'deleted': deleted,
      'read': read,
      'subtitle': subtitle,
      'inboxMessage': inboxMessage,
      'inboxSubtitle': inboxSubtitle,
      'notificationMessage': notificationMessage?.toJson(),
      'messageType': messageType
    };
  }
}

class Media {
  final String? altText;
  final String? url;

  Media({this.altText, this.url});

  factory Media.fromJson(Map<String, dynamic> json) {
    return Media(
      altText: json['altText'],
      url: json['url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'altText': altText,
      'url': url,
    };
  }
}
