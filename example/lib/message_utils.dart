import 'package:flutter/material.dart';
import 'package:sfmc/inbox_message.dart';
import 'package:sfmc/sfmc.dart';
import 'dart:convert';
import 'package:intl/intl.dart';

Future<int> fetchMessageCount() async {
  final int? count = await SFMCSdk.getMessageCount();
  if (count != null) {
    return count;
  } else {
    return 0;
  }
}

Future<int> fetchReadMessageCount() async {
  final int? count = await SFMCSdk.getReadMessageCount();
  if (count != null) {
    return count;
  } else {
    return 0;
  }
}

Future<int> fetchUnreadMessageCount() async {
  final int? count = await SFMCSdk.getUnreadMessageCount();
  if (count != null) {
    return count;
  } else {
    return 0;
  }
}

Future<int> fetchDeletedMessageCount() async {
  final int? count = await SFMCSdk.getDeletedMessageCount();
  if (count != null) {
    return count;
  } else {
    return 0;
  }
}

Future<void> setMessagesRead(String id) async {
  await SFMCSdk.setMessageRead(id);
}

Future<void> deleteMessage(String id) async {
  await SFMCSdk.deleteMessage(id);
}

Future<void> markAllMessagesAsRead() async {
  await SFMCSdk.markAllMessagesRead();
}

Future<void> deleteAllMessages() async {
  await SFMCSdk.markAllMessagesDeleted();
}

Future<List<InboxMessage>> fetchReadMessages() async {
  final String messages = await SFMCSdk.getReadMessages();
  return parseMessages(messages);
}

Future<List<InboxMessage>> fetchUnreadMessages() async {
  final String messages = await SFMCSdk.getUnreadMessages();
  return parseMessages(messages);
}

Future<List<InboxMessage>> fetchDeletedMessages() async {
  final String messages = await SFMCSdk.getDeletedMessages();
  return parseMessages(messages);
}

List<InboxMessage> parseMessages(String jsonString) {
  final List<dynamic> jsonArray = jsonDecode(jsonString);
  return jsonArray.map((json) => InboxMessage.fromJson(json)).toList();
}

String formatDateTime(DateTime sendDateUtc) {
  final DateFormat dateFormatter = DateFormat('yyyy-MM-dd');
  String date = dateFormatter.format(sendDateUtc);
  final DateFormat timeFormatter = DateFormat('hh:mm a');
  String time = timeFormatter.format(sendDateUtc);
  return '$date $time';
}
