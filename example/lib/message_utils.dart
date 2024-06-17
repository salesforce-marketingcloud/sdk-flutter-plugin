import 'package:flutter/material.dart';
import 'package:sfmc/inbox_message.dart';
import 'package:sfmc/sfmc.dart';
import 'dart:convert';

// Utility functions

Future<int> fetchMessageCount() async {
  final int? count = await SFMCSdk.getMessageCount();
  return count!;
}

Future<int> fetchReadMessageCount() async {
  final int? count = await SFMCSdk.getReadMessageCount();
  return count!;
}

Future<int> fetchUnreadMessageCount() async {
  final int? count = await SFMCSdk.getUnreadMessageCount();
  return count!;
}

Future<int> fetchDeletedMessageCount() async {
  final int? count = await SFMCSdk.getDeletedMessageCount();
  return count!;
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

// Function to format date and time
String formatDateTime(DateTime sendDateUtc) {
  String date = sendDateUtc.toString().substring(0, 10); // Extract date
  String time = formatTime(sendDateUtc); // Format time
  return '$date $time';
}

// Function to format time
String formatTime(DateTime sendDateUtc) {
  String period = sendDateUtc.hour >= 12 ? 'PM' : 'AM';
  int hour = sendDateUtc.hour > 12 ? sendDateUtc.hour - 12 : sendDateUtc.hour;
  String hourStr = hour.toString().padLeft(2, '0');
  String minuteStr = sendDateUtc.minute.toString().padLeft(2, '0');
  return '$hourStr:$minuteStr $period';
}
