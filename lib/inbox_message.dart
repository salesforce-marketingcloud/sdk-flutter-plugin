import 'media.dart';

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
  final String url;
  final Media? media;

  InboxMessage({
    required this.id,
    required this.title,
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
    required this.url,
    this.media,
  });

  String? alert() {
    return alert;
  }

  String? custom() {
    return custom;
  }

  Map<String, String>? customKeys() {
    return customKeys;
  }

  bool deleted() {
    return deleted;
  }

  DateTime? endDateUtc() {
    return endDateUtc;
  }

  String id() {
    return id;
  }

  Media? media() {
    return media;
  }

  bool read() {
    return read;
  }

  DateTime? sendDateUtc() {
    return sendDateUtc;
  }

  String? sound() {
    return sound;
  }

  DateTime? startDateUtc() {
    return startDateUtc;
  }

  String? subject() {
    return subject;
  }

  String? title() {
    return title;
  }

  String url() {
    return url;
  }
}

 List<InboxMessage> inboxMessages = [];