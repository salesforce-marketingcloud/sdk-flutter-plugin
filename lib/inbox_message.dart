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
    required this.url,
    this.media,
  });

  factory InboxMessage.fromJson(Map<String, dynamic> json) {
    return InboxMessage(
      id: json['id'] ?? '',
      subject: json['subject'] ?? '',
      title: json['title'] ?? '',
      alert: json['alert'] ?? '',
      sound: json['sound'] ?? '',
      media: json['media'] != null ? Media.fromJson(json['media']) : null,
      startDateUtc: json['startDateUtc'] != null
          ? DateTime.parse(json['startDateUtc'])
          : null,
      endDateUtc: json['endDateUtc'] != null
          ? DateTime.parse(json['endDateUtc'])
          : null,
      sendDateUtc: json['sendDateUtc'] != null
          ? DateTime.parse(json['sendDateUtc'])
          : null,
      url: json['url'] ?? '',
      custom: json['custom'] ?? '',
      customKeys: json['customKeys'] != null
          ? Map<String, String>.from(json['customKeys'])
          : null,
      deleted: json['deleted'] ?? false,
      read: json['read'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'alert': alert,
      'custom': custom,
      'customKeys': customKeys,
      'deleted': deleted,
      'endDateUtc': endDateUtc?.toIso8601String(),
      'read': read,
      'sendDateUtc': sendDateUtc?.toIso8601String(),
      'sound': sound,
      'startDateUtc': startDateUtc?.toIso8601String(),
      'subject': subject,
      'url': url,
      'media': media?.toJson(),
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
