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

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'sfmc_platform_interface.dart';

class MethodChannelSfmc extends SfmcPlatform {
  @visibleForTesting
  final methodChannel = const MethodChannel('sfmc');

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
  Future<String> getMessages() async {
    final dynamic result =
        await methodChannel.invokeMethod<dynamic>('getMessages');
    return result;
  }

  @override
  Future<String> getReadMessages() async {
    final dynamic result =
        await methodChannel.invokeMethod<dynamic>('getReadMessages');
    return result;
  }

  @override
  Future<String> getUnreadMessages() async {
    final dynamic result =
        await methodChannel.invokeMethod<dynamic>('getUnreadMessages');
    return result;
  }

  @override
  Future<String> getDeletedMessages() async {
    final dynamic result =
        await methodChannel.invokeMethod<dynamic>('getDeletedMessages');
    return result;
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
  Future<int?> getMessageCount() {
    return methodChannel.invokeMethod<int?>('getMessageCount');
  }

  @override
  Future<int?> getReadMessageCount() {
    return methodChannel.invokeMethod<int?>('getReadMessageCount');
  }

  @override
  Future<int?> getUnreadMessageCount() {
    return methodChannel.invokeMethod<int?>('getUnreadMessageCount');
  }

  @override
  Future<int?> getDeletedMessageCount() {
    return methodChannel.invokeMethod<int?>('getDeletedMessageCount');
  }

  @override
  Future<void> markAllMessagesRead() {
    return methodChannel.invokeMethod('markAllMessagesRead');
  }

  @override
  Future<void> markAllMessagesDeleted() {
    return methodChannel.invokeMethod('markAllMessagesDeleted');
  }
}
