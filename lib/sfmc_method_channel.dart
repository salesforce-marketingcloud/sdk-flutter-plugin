// sfmc_method_channel.dart
//
// Copyright (c) 2024 Salesforce, Inc
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are met:
//
// Redistributions of source code must retain the above copyright notice, this
// list of conditions and the following disclaimer. Redistributions in binary
// form must reproduce the above copyright notice, this list of conditions and
// the following disclaimer in the documentation and/or other materials
// provided with the distribution. Neither the name of the nor the names of
// its contributors may be used to endorse or promote products derived from
// this software without specific prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
// AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
// IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
// ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
// LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
// CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
// SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
// INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
// CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
// ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
// POSSIBILITY OF SUCH DAMAGE.

import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'inbox_message.dart';
import 'sfmc_platform_interface.dart';

typedef InboxResponseListener = void Function(List<InboxMessage> messages);
typedef InboxRefreshListener = void Function(bool successful);

List<InboxResponseListener> _callbacksById = [];

class MethodChannelSfmc extends SfmcPlatform {
  @visibleForTesting
  final methodChannel = const MethodChannel('sfmc');

  MethodChannelSfmc() {
    WidgetsFlutterBinding.ensureInitialized();
    methodChannel.setMethodCallHandler(_handleNativeCall);
  }

  @override
  Future<String?> getSystemToken() {
    return methodChannel.invokeMethod<String>('getSystemToken');
  }

  @override
  Future<bool?> isPushEnabled() {
    return methodChannel.invokeMethod<bool>('isPushEnabled');
  }

  @override
  Future<void> enablePush() {
    return methodChannel.invokeMethod('enablePush');
  }

  @override
  Future<void> disablePush() {
    return methodChannel.invokeMethod('disablePush');
  }

  @override
  Future<void> enableLogging() {
    return methodChannel.invokeMethod('enableLogging');
  }

  @override
  Future<void> disableLogging() {
    return methodChannel.invokeMethod('disableLogging');
  }

  @override
  Future<void> logSdkState() {
    return methodChannel.invokeMethod('logSdkState');
  }

  @override
  Future<String?> getDeviceId() {
    return methodChannel.invokeMethod<String>('getDeviceId');
  }

  @override
  Future<Map<String, String>> getAttributes() async {
    final Map<dynamic, dynamic> result =
        await methodChannel.invokeMethod('getAttributes');
    return result.cast<String, String>();
  }

  @override
  Future<void> setAttribute(String key, String value) {
    return methodChannel
        .invokeMethod('setAttribute', {"key": key, "value": value});
  }

  @override
  Future<void> clearAttribute(String key) {
    return methodChannel.invokeMethod('clearAttribute', {"key": key});
  }

  @override
  Future<void> addTag(String tag) {
    return methodChannel.invokeMethod('addTag', {"tag": tag});
  }

  @override
  Future<void> removeTag(String tag) {
    return methodChannel.invokeMethod('removeTag', {"tag": tag});
  }

  @override
  Future<List<String>> getTags() async {
    final List<dynamic> result = await methodChannel.invokeMethod('getTags');
    return result.cast<String>();
  }

  @override
  Future<void> setContactKey(String contactKey) {
    return methodChannel
        .invokeMethod('setContactKey', {"contactKey": contactKey});
  }

  @override
  Future<String?> getContactKey() {
    return methodChannel.invokeMethod<String>('getContactKey');
  }

  @override
  Future<void> trackEvent(Map<String, dynamic> eventJson) {
    return methodChannel.invokeMethod('trackEvent', eventJson);
  }

  @override
  Future<void> setAnalyticsEnabled(bool analyticsEnabled) {
    return methodChannel.invokeMethod(
        'setAnalyticsEnabled', {'analyticsEnabled': analyticsEnabled});
  }

  @override
  Future<bool> isAnalyticsEnabled() async {
    return await methodChannel.invokeMethod<bool>('isAnalyticsEnabled') ??
        false;
  }

  @override
  Future<void> setPiAnalyticsEnabled(bool analyticsEnabled) {
    return methodChannel.invokeMethod(
        'setPiAnalyticsEnabled', {'analyticsEnabled': analyticsEnabled});
  }

  @override
  Future<bool> isPiAnalyticsEnabled() async {
    return await methodChannel.invokeMethod<bool>('isPiAnalyticsEnabled') ??
        false;
  }

  @override
  Future<List<InboxMessage>> getMessages() async {
    return _fetchMessages('getMessages');
  }

  @override
  Future<List<InboxMessage>> getReadMessages() async {
    return _fetchMessages('getReadMessages');
  }

  @override
  Future<List<InboxMessage>> getUnreadMessages() async {
    return _fetchMessages('getUnreadMessages');
  }

  @override
  Future<List<InboxMessage>> getDeletedMessages() async {
    return _fetchMessages('getDeletedMessages');
  }

  @override
  Future<void> setMessageRead(String id) {
    return methodChannel.invokeMethod('setMessageRead', {'messageId': id});
  }

  @override
  Future<void> deleteMessage(String id) {
    return methodChannel.invokeMethod('deleteMessage', {'messageId': id});
  }

  @override
  Future<int> getMessageCount() async {
    return await methodChannel.invokeMethod<int?>('getMessageCount') ?? 0;
  }

  @override
  Future<int> getReadMessageCount() async {
    return await methodChannel.invokeMethod<int?>('getReadMessageCount') ?? 0;
  }

  @override
  Future<int> getUnreadMessageCount() async {
    return await methodChannel.invokeMethod<int?>('getUnreadMessageCount') ?? 0;
  }

  @override
  Future<int> getDeletedMessageCount() async {
    return await methodChannel.invokeMethod<int?>('getDeletedMessageCount') ??
        0;
  }

  @override
  Future<void> markAllMessagesRead() {
    return methodChannel.invokeMethod('markAllMessagesRead');
  }

  @override
  Future<void> markAllMessagesDeleted() {
    return methodChannel.invokeMethod('markAllMessagesDeleted');
  }

  @override
  Future<bool> refreshInbox(InboxRefreshListener callback) async {
    return await methodChannel.invokeMethod('refreshInbox');
  }

  @override
  Future<void> registerInboxResponseListener(
      InboxResponseListener callback) async {
    try {
      _callbacksById.add(callback);
      if (_callbacksById.length == 1) {
        await methodChannel.invokeMethod('registerInboxResponseListener');
      } else {
        debugPrint(
            "Skip Register Listener with Native. Active ${_callbacksById.length} registers left");
      }
    } catch (e) {
      debugPrint('Failed to Register listener with the Native SDK: $e');
    }
  }

  @override
  Future<void> unregisterInboxResponseListener(
      InboxResponseListener callback) async {
    try {
      _callbacksById.remove(callback);
      if (_callbacksById.isEmpty) {
        await methodChannel.invokeMethod('unregisterInboxResponseListener');
      } else {
        debugPrint(
            "Skip Unregister Listener with Native. Active ${_callbacksById.length} registers left");
      }
    } catch (e) {
      debugPrint('Failed to Unregister listener with the Native SDK : $e');
    }
  }

  Future<void> _handleNativeCall(MethodCall call) async {
    if (call.method == 'onInboxMessagesChanged') {
      final List<dynamic> jsonStringList = call.arguments;
      if (jsonStringList.every((element) => element is String)) {
        final List<InboxMessage> inboxMessages = jsonStringList
            .where((jsonString) => jsonString != null)
            .map((jsonString) {
          final Map<String, dynamic> jsonMap = jsonDecode(jsonString);
          return InboxMessage.fromJson(jsonMap);
        }).toList();
        _callbacksById.forEach((listener) {
          if (listener != null) {
            listener(inboxMessages);
          } else {
            debugPrint('Listener not found ');
          }
        });
      }
    }
  }

  Future<List<InboxMessage>> _fetchMessages(String methodName) async {
    final dynamic result =
        await methodChannel.invokeMethod<dynamic>(methodName);
    return _parseMessages(List<String>.from(result));
  }

  ///The parseMessages function takes a list of JSON strings, each representing an inbox message, and converts it into a list of InboxMessage objects.
  ///
  /// @param messages A list of JSON strings (List<String>), where each string represents the data of an inbox message in JSON format.
  ///
  /// Returns a list of InboxMessage objects (List<InboxMessage>).
  static List<InboxMessage> _parseMessages(List<String> messages) {
    return messages.map((jsonString) {
      final Map<String, dynamic> jsonMap = jsonDecode(jsonString);
      return InboxMessage.fromJson(jsonMap);
    }).toList();
  }
}
