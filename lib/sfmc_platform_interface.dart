// sfmc_platform_interface.dart
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

import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'sfmc_method_channel.dart';

abstract class SfmcPlatform extends PlatformInterface {
  /// Constructs a SfmcPlatform.
  SfmcPlatform() : super(token: _token);

  static final Object _token = Object();

  static SfmcPlatform _instance = MethodChannelSfmc();

  static SfmcPlatform get instance => _instance;

  static set instance(SfmcPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getSystemToken() {
    throw UnimplementedError('getSystemToken() has not been implemented.');
  }

  Future<bool?> isPushEnabled() {
    throw UnimplementedError('isPushEnabled() has not been implemented.');
  }

  Future<void> enablePush() {
    throw UnimplementedError('enablePush() has not been implemented.');
  }

  Future<void> disablePush() {
    throw UnimplementedError('disablePush() has not been implemented.');
  }

  Future<void> enableLogging() {
    throw UnimplementedError('enableLogging() has not been implemented.');
  }

  Future<void> disableLogging() {
    throw UnimplementedError('disableLogging() has not been implemented.');
  }

  Future<void> logSdkState() {
    throw UnimplementedError('logSdkState() has not been implemented.');
  }

  Future<String?> getDeviceId() {
    throw UnimplementedError('getDeviceId() has not been implemented.');
  }

  Future<Map<String, String>> getAttributes() {
    throw UnimplementedError('getAttributes() has not been implemented.');
  }

  Future<void> setAttribute(String key, String value) {
    throw UnimplementedError('setAttribute() has not been implemented.');
  }

  Future<void> clearAttribute(String key) {
    throw UnimplementedError('clearAttribute() has not been implemented.');
  }

  Future<void> addTag(String tag) {
    throw UnimplementedError('addTag() has not been implemented.');
  }

  Future<void> removeTag(String tag) {
    throw UnimplementedError('removeTag() has not been implemented.');
  }

  Future<List<String>> getTags() {
    throw UnimplementedError('getTags() has not been implemented.');
  }

  Future<void> setContactKey(String contactKey) {
    throw UnimplementedError('setContactKey() has not been implemented.');
  }

  Future<String?> getContactKey() {
    throw UnimplementedError('getContactKey() has not been implemented.');
  }

  Future<void> trackEvent(Map<String, dynamic> eventJson) {
    throw UnimplementedError('trackEvent() has not been implemented.');
  }

  Future<void> setAnalyticsEnabled(bool analyticsEnabled) {
    throw UnimplementedError('setAnalyticsEnabled() has not been implemented.');
  }

  Future<bool> isAnalyticsEnabled() {
    throw UnimplementedError('isAnalyticsEnabled() has not been implemented.');
  }

  Future<void> setPiAnalyticsEnabled(bool analyticsEnabled) {
    throw UnimplementedError(
        'setPiAnalyticsEnabled() has not been implemented.');
  }

  Future<bool> isPiAnalyticsEnabled() {
    throw UnimplementedError(
        'isPiAnalyticsEnabled() has not been implemented.');
  }

  Future<List<String>> getMessages() async {
    throw UnimplementedError('getMessages() has not been implemented.');
  }

  Future<List<String>> getReadMessages() async {
    throw UnimplementedError('getReadMessages() has not been implemented.');
  }

  Future<List<String>> getUnreadMessages() async {
    throw UnimplementedError('getUnreadMessages() has not been implemented.');
  }

  Future<List<String>> getDeletedMessages() async {
    throw UnimplementedError('getDeletedMessages() has not been implemented.');
  }

  Future<void> setMessageRead(String id) {
    throw UnimplementedError('setMessageRead() has not been implemented.');
  }

  Future<void> deleteMessage(String id) {
    throw UnimplementedError('deleteMessage() has not been implemented.');
  }

  Future<int?> getMessageCount() {
    throw UnimplementedError('getMessageCount() has not been implemented.');
  }

  Future<int?> getReadMessageCount() {
    throw UnimplementedError('getReadMessageCount() has not been implemented.');
  }

  Future<int?> getUnreadMessageCount() {
    throw UnimplementedError('getReadMessageCount() has not been implemented.');
  }

  Future<int?> getDeletedMessageCount() {
    throw UnimplementedError(
        'getDeletedMessageCount() has not been implemented.');
  }

  Future<void> markAllMessagesRead() {
    throw UnimplementedError('markAllMessagesRead() has not been implemented.');
  }

  Future<void> markAllMessagesDeleted() {
    throw UnimplementedError(
        'markAllMessagesDeleted() has not been implemented.');
  }

  Future<bool> refreshInbox(InboxRefreshListener callback) {
    throw UnimplementedError('refreshInbox() has not been implemented.');
  }

  Future<void> registerInboxResponseListener(InboxResponseListener callback) {
    throw UnimplementedError(
        'registerInboxResponseListener()has not been implemented.');
  }

  Future<void> unregisterInboxResponseListener(InboxResponseListener callback) {
    throw UnimplementedError(
        'unregisterInboxResponseListener()has not been implemented.');
  }
}
