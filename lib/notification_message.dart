import 'dart:convert';
import 'package:flutter/foundation.dart';


class NotificationMessage {
  final String id;
  final String alert;
  final String? sound;
  final String? soundName;
  final String? title;
  final String? subtitle;
  final String type;
  final String trigger;
  final String? url;
  final String? mediaUrl;
  final String? mediaAltText;
  final Map<String, String>? customKeys;
  final String? custom;
  final Map<String, String>? payload;

  NotificationMessage({
    required this.id,
    required this.alert,
    this.sound,
    this.soundName,
    this.title,
    this.subtitle,
    required this.type,
    required this.trigger,
    this.url,
    this.mediaUrl,
    this.mediaAltText,
    this.customKeys,
    this.custom,
    this.payload,
  });

  factory NotificationMessage.fromJson(Map<String, dynamic> json) {
    debugPrint(json.toString());
    return NotificationMessage(
      id: json['id'] ?? '',
      alert: json['alert'] ?? '',
      sound: json['sound'],
      soundName: json['soundName'],
      title: json['title'],
      subtitle: json['subtitle'],
      type: json['type'] ?? '',
      trigger: json['trigger'] ?? '',
      url: json['url'],
      mediaUrl: json['mediaUrl'],
      mediaAltText: json['mediaAltText'],
      customKeys: json['customKeys'] is Map<dynamic, dynamic> 
          ? Map<String, String>.from(json['customKeys'])
          : null, 
      custom: json['custom'],
      payload: json['payload'] != null
          ? Map<String, String>.from(json['payload'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'alert': alert,
      'sound': sound,
      'soundName': soundName,
      'title': title,
      'subtitle': subtitle,
      'type': type,
      'trigger': trigger,
      'url': url,
      'mediaUrl': mediaUrl,
      'mediaAltText': mediaAltText,
      'customKeys': customKeys,
      'custom': custom,
      'payload': payload,
    };
  }
}
