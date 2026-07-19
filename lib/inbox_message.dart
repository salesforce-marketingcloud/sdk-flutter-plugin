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

  /// Leniently parses a date value received from the native SDKs.
  ///
  /// Both native bridges now emit ISO-8601 UTC strings
  /// (`yyyy-MM-dd'T'HH:mm:ss'Z'`), which [DateTime.tryParse] handles directly.
  /// Older plugin versions emitted locale-dependent strings such as
  /// `2026-05-02 05:28:00`, `2026-05-02 05:28:00.000` or the 12-hour
  /// `2026-05-02 3:56:00 AM +0000` form produced by iOS devices with a
  /// 12-hour clock, so those are tolerated as a fallback. Returns `null`
  /// instead of throwing when the value cannot be parsed, so a single
  /// malformed date can never fail an entire message list.
  static DateTime? _parseDate(dynamic value) {
    if (value is! String || value.isEmpty) {
      return null;
    }
    final trimmed = value.trim();
    final parsed = DateTime.tryParse(trimmed);
    if (parsed != null) {
      return parsed;
    }
    final match = RegExp(
            r'^(\d{4})-(\d{1,2})-(\d{1,2})[ T](\d{1,2}):(\d{2}):(\d{2})(?:\.(\d+))?(?:\s*([AaPp][Mm]))?(?:\s*(Z|[+-]\d{2}:?\d{2}))?$')
        .firstMatch(trimmed);
    if (match == null) {
      return null;
    }
    final year = int.parse(match.group(1)!);
    final month = int.parse(match.group(2)!);
    final day = int.parse(match.group(3)!);
    var hour = int.parse(match.group(4)!);
    final minute = int.parse(match.group(5)!);
    final second = int.parse(match.group(6)!);
    final fraction = match.group(7);
    final millisecond = fraction != null
        ? int.parse(fraction.padRight(3, '0').substring(0, 3))
        : 0;
    final meridiem = match.group(8);
    if (meridiem != null) {
      if (hour < 1 || hour > 12) {
        return null;
      }
      final isPm = meridiem.toLowerCase() == 'pm';
      if (hour == 12) {
        hour = isPm ? 12 : 0;
      } else if (isPm) {
        hour += 12;
      }
    }
    final offset = match.group(9);
    if (offset == null) {
      // No zone designator: keep the legacy behavior of DateTime.parse and
      // interpret the wall-clock time as local time.
      return DateTime(year, month, day, hour, minute, second, millisecond);
    }
    final utc = DateTime.utc(year, month, day, hour, minute, second, millisecond);
    if (offset == 'Z') {
      return utc;
    }
    final sign = offset.startsWith('-') ? -1 : 1;
    final digits = offset.substring(1).replaceAll(':', '');
    final offsetDuration = Duration(
        hours: int.parse(digits.substring(0, 2)),
        minutes: int.parse(digits.substring(2, 4)));
    return sign == 1 ? utc.subtract(offsetDuration) : utc.add(offsetDuration);
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
