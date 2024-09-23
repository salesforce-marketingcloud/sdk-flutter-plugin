// sfmc.dart
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

import 'inbox_message.dart';
import 'sfmc_platform_interface.dart';
import 'events.dart';

export 'events.dart';

///The InboxResponseListener is a type definition for a callback function that handles a list of InboxMessage objects. It is used to respond to events or actions that return a list of inbox messages.
///
/// @param messages A list of InboxMessage objects (List<InboxMessage>).
typedef InboxResponseListener = void Function(List<InboxMessage> messages);

///The InboxRefreshListener is a type definition for a callback function that handles the result of an inbox refresh operation. It indicates whether the refresh operation was successful or not.
///
/// @param successful A boolean value, indicating the success of the refresh operation. true if the refresh was successful, false otherwise.
typedef InboxRefreshListener = void Function(bool successful);

/// Salesforce Marketing Cloud SDK for Flutter.
class SFMCSdk {
  /// Returns the system token used by the Marketing Cloud to send push messages to the device.
  ///
  /// Returns a Future that resolves to the system token string.
  ///
  /// See:
  /// - [Android Docs](https://salesforce-marketingcloud.github.io/MarketingCloudSDK-Android/javadocs/MarketingCloudSdk/8.0/com.salesforce.marketingcloud.registration/-registration-manager/get-system-token.html)
  /// - [iOS Docs](https://salesforce-marketingcloud.github.io/MarketingCloudSDK-iOS/appledocs/MarketingCloudSdk/8.0/Classes/PushModule.html#/c:@M@MarketingCloudSDK@objc(cs)SFMCSdkPushModule(im)deviceToken)
  static Future<String?> getSystemToken() {
    return SfmcPlatform.instance.getSystemToken();
  }

  /// Checks if push messaging is enabled in the Marketing Cloud SDK.
  ///
  /// Returns a Future that resolves to a boolean indicating if push is enabled.
  ///
  /// See:
  /// - [Android Docs](https://salesforce-marketingcloud.github.io/MarketingCloudSDK-Android/javadocs/MarketingCloudSdk/8.0/com.salesforce.marketingcloud.messages.push/-push-message-manager/is-push-enabled.html)
  /// - [iOS Docs](https://salesforce-marketingcloud.github.io/MarketingCloudSDK-iOS/appledocs/MarketingCloudSdk/8.0/Classes/PushModule.html#/c:@M@MarketingCloudSDK@objc(cs)SFMCSdkPushModule(im)pushEnabled)
  static Future<bool?> isPushEnabled() {
    return SfmcPlatform.instance.isPushEnabled();
  }

  /// Enables push messaging in the native Marketing Cloud SDK.
  ///
  /// See:
  /// - [Android Docs](https://salesforce-marketingcloud.github.io/MarketingCloudSDK-Android/javadocs/MarketingCloudSdk/8.0/com.salesforce.marketingcloud.messages.push/-push-message-manager/enable-push.html)
  /// - [iOS Docs](https://salesforce-marketingcloud.github.io/MarketingCloudSDK-iOS/appledocs/MarketingCloudSdk/8.0/Classes/PushModule.html#/c:@M@MarketingCloudSDK@objc(cs)SFMCSdkPushModule(im)setPushEnabled:)
  static Future<void> enablePush() {
    return SfmcPlatform.instance.enablePush();
  }

  /// Disables push messaging in the native Marketing Cloud SDK.
  ///
  /// See:
  /// - [Android Docs](https://salesforce-marketingcloud.github.io/MarketingCloudSDK-Android/javadocs/MarketingCloudSdk/8.0/com.salesforce.marketingcloud.messages.push/-push-message-manager/disable-push.html)
  /// - [iOS Docs](https://salesforce-marketingcloud.github.io/MarketingCloudSDK-iOS/appledocs/MarketingCloudSdk/8.0/Classes/PushModule.html#/c:@M@MarketingCloudSDK@objc(cs)SFMCSdkPushModule(im)setPushEnabled:)
  static Future<void> disablePush() {
    return SfmcPlatform.instance.disablePush();
  }

  /// Enables verbose logging within the native Marketing Cloud SDK and Unified SFMC SDK.
  ///
  /// See:
  /// - [Android Docs](https://salesforce-marketingcloud.github.io/MarketingCloudSDK-Android/trouble-shooting/loginterface.html)
  /// - [iOS Docs](https://salesforce-marketingcloud.github.io/MarketingCloudSDK-iOS/appledocs/SFMCSdk/8.0/Classes/SFMCSdk.html#/c:@M@SFMCSDK@objc(cs)SFMCSdk(cm)setLoggerWithLogLevel:logOutputter:)
  static Future<void> enableLogging() {
    return SfmcPlatform.instance.enableLogging();
  }

  /// Disables verbose logging within the native Marketing Cloud SDK.
  ///
  /// See:
  /// - [Android Docs](https://salesforce-marketingcloud.github.io/MarketingCloudSDK-Android/trouble-shooting/loginterface.html)
  /// - [iOS Docs](https://salesforce-marketingcloud.github.io/MarketingCloudSDK-iOS/appledocs/SFMCSdk/8.0/Classes/SFMCSdk.html#/c:@M@SFMCSDK@objc(cs)SFMCSdk(cm)setLoggerWithLogLevel:logOutputter:)
  static Future<void> disableLogging() {
    return SfmcPlatform.instance.disableLogging();
  }

  /// Logs the SDK state to the native logging system (Logcat for Android and Xcode/Console.app for iOS).
  /// This can help diagnose most issues within the SDK and is often requested by the Marketing Cloud support team.
  ///
  /// See:
  /// - [Android Docs](https://salesforce-marketingcloud.github.io/MarketingCloudSDK-Android/javadocs/SFMCSdk/8.0/com.salesforce.marketingcloud.sfmcsdk/-s-f-m-c-sdk/get-sdk-state.html)
  /// - [iOS Docs](https://salesforce-marketingcloud.github.io/MarketingCloudSDK-iOS/appledocs/SFMCSdk/8.0/Classes/SFMCSdk.html#/c:@M@SFMCSDK@objc(cs)SFMCSdk(cm)state)
  static Future<void> logSdkState() {
    return SfmcPlatform.instance.logSdkState();
  }

  /// Returns the device ID used by the Marketing Cloud to send push messages to the device.
  ///
  /// Returns a Future that resolves to the device ID.
  ///
  /// See:
  /// - [Android Docs](https://salesforce-marketingcloud.github.io/MarketingCloudSDK-Android/javadocs/MarketingCloudSdk/8.0/com.salesforce.marketingcloud.registration/-registration-manager/get-device-id.html)
  /// - [iOS Docs](https://salesforce-marketingcloud.github.io/MarketingCloudSDK-iOS/appledocs/MarketingCloudSdk/8.0/Classes/PushModule.html#/c:@M@MarketingCloudSDK@objc(cs)SFMCSdkPushModule(im)deviceIdentifier)
  static Future<String?> getDeviceId() {
    return SfmcPlatform.instance.getDeviceId();
  }

  /// Retrieves a map of attributes set in the registration.
  ///
  /// Returns a Future that resolves to a map of attributes.
  ///
  /// See:
  /// - [Android Docs](https://salesforce-marketingcloud.github.io/MarketingCloudSDK-Android/javadocs/MarketingCloudSdk/8.0/com.salesforce.marketingcloud.registration/-registration-manager/get-attributes.html)
  /// - [iOS Docs](https://salesforce-marketingcloud.github.io/MarketingCloudSDK-iOS/appledocs/MarketingCloudSdk/8.0/Classes/PushModule.html#/c:@M@MarketingCloudSDK@objc(cs)SFMCSdkPushModule(im)attributes)
  static Future<Map<String, String>> getAttributes() {
    return SfmcPlatform.instance.getAttributes();
  }

  /// Sets the value of an attribute in the registration.
  ///
  /// @param key The name of the attribute to be set.
  /// @param value The value of the attribute to be set.
  ///
  /// See:
  /// - [Android Docs](https://salesforce-marketingcloud.github.io/MarketingCloudSDK-Android/javadocs/SFMCSdk/8.0/com.salesforce.marketingcloud.sfmcsdk.components.identity/-identity/set-profile-attribute.html)
  /// - [iOS Docs](https://salesforce-marketingcloud.github.io/MarketingCloudSDK-iOS/appledocs/SFMCSdk/8.0/Classes/IDENTITY.html#/c:@M@SFMCSDK@objc(cs)SFMCSdkIDENTITY(im)setProfileAttributes:)
  static Future<void> setAttribute(String key, String value) {
    return SfmcPlatform.instance.setAttribute(key, value);
  }

  /// Clears the value of an attribute in the registration.
  ///
  /// @param key The name of the attribute whose value should be cleared.
  ///
  /// See:
  /// - [Android Docs](https://salesforce-marketingcloud.github.io/MarketingCloudSDK-Android/javadocs/MarketingCloudSdk/8.0/com.salesforce.marketingcloud.registration/-registration-manager/-editor/clear-attribute.html)
  /// - [iOS Docs](https://salesforce-marketingcloud.github.io/MarketingCloudSDK-iOS/appledocs/SFMCSdk/8.0/Classes/IDENTITY.html#/c:@M@SFMCSDK@objc(cs)SFMCSdkIDENTITY(im)clearProfileAttributeWithKey:)
  static Future<void> clearAttribute(String key) {
    return SfmcPlatform.instance.clearAttribute(key);
  }

  /// Adds a tag to the list of tags in the registration.
  ///
  /// @param tag The tag to be added.
  ///
  /// See:
  /// - [Android Docs](https://salesforce-marketingcloud.github.io/MarketingCloudSDK-Android/javadocs/MarketingCloudSdk/8.0/com.salesforce.marketingcloud.registration/-registration-manager/-editor/add-tag.html)
  /// - [iOS Docs](https://salesforce-marketingcloud.github.io/MarketingCloudSDK-iOS/appledocs/MarketingCloudSdk/8.0/Classes/PushModule.html#/c:@M@MarketingCloudSDK@objc(cs)SFMCSdkPushModule(im)addTag:)
  static Future<void> addTag(String tag) {
    return SfmcPlatform.instance.addTag(tag);
  }

  /// Removes a tag from the list of tags in the registration.
  ///
  /// @param tag The tag to be removed.
  ///
  /// See:
  /// - [Android Docs](https://salesforce-marketingcloud.github.io/MarketingCloudSDK-Android/javadocs/MarketingCloudSdk/8.0/com.salesforce.marketingcloud.registration/-registration-manager/-editor/remove-tag.html)
  /// - [iOS Docs](https://salesforce-marketingcloud.github.io/MarketingCloudSDK-iOS/appledocs/MarketingCloudSdk/8.0/Classes/PushModule.html#/c:@M@MarketingCloudSDK@objc(cs)SFMCSdkPushModule(im)removeTag:)
  static Future<void> removeTag(String tag) {
    return SfmcPlatform.instance.removeTag(tag);
  }

  /// Retrieves the list of tags currently set on the device.
  ///
  /// Returns a Future that resolves to a list of tags.
  ///
  /// See:
  /// - [Android Docs](https://salesforce-marketingcloud.github.io/MarketingCloudSDK-Android/javadocs/MarketingCloudSdk/8.0/com.salesforce.marketingcloud.registration/-registration-manager/get-tags.html)
  /// - [iOS Docs](https://salesforce-marketingcloud.github.io/MarketingCloudSDK-iOS/appledocs/MarketingCloudSdk/8.0/Classes/PushModule.html#/c:@M@MarketingCloudSDK@objc(cs)SFMCSdkPushModule(im)tags)
  static Future<List<String>> getTags() {
    return SfmcPlatform.instance.getTags();
  }

  /// Sets the contact key for the device's user.
  ///
  /// @param contactKey The value to be set as the contact key.
  ///
  /// See:
  /// - [Android Docs](https://salesforce-marketingcloud.github.io/MarketingCloudSDK-Android/javadocs/SFMCSdk/8.0/com.salesforce.marketingcloud.sfmcsdk.components.identity/-identity/set-profile-id.html)
  /// - [iOS Docs](https://salesforce-marketingcloud.github.io/MarketingCloudSDK-iOS/appledocs/SFMCSdk/8.0/Classes/IDENTITY.html#/c:@M@SFMCSDK@objc(cs)SFMCSdkIDENTITY(im)setProfileId:)
  static Future<void> setContactKey(String contactKey) {
    return SfmcPlatform.instance.setContactKey(contactKey);
  }

  /// Retrieves the contact key currently set on the device.
  ///
  /// Returns a Future that resolves to the current contact key.
  ///
  /// See:
  /// - [Android Docs](https://salesforce-marketingcloud.github.io/MarketingCloudSDK-Android/javadocs/MarketingCloudSdk/8.0/com.salesforce.marketingcloud.registration/-registration-manager/get-contact-key.html)
  /// - [iOS Docs](https://salesforce-marketingcloud.github.io/MarketingCloudSDK-iOS/appledocs/MarketingCloudSdk/8.0/Classes/PushModule.html#/c:@M@MarketingCloudSDK@objc(cs)SFMCSdkPushModule(im)contactKey)
  static Future<String?> getContactKey() {
    return SfmcPlatform.instance.getContactKey();
  }

  /// This method helps to track events, which could result in actions such as an InApp Message being displayed.
  ///
  /// @param event The event to be tracked.
  ///
  /// See:
  /// - [Android Docs](https://salesforce-marketingcloud.github.io/MarketingCloudSDK-Android/event-tracking/event-tracking-event-tracking.html)
  /// - [iOS Docs](https://salesforce-marketingcloud.github.io/MarketingCloudSDK-iOS/event-tracking/event-tracking-event-tracking.html)

  static Future<void> trackEvent(CustomEvent event) {
    // Implement event tracking logic
    return SfmcPlatform.instance.trackEvent(event.toJson());
  }

  /// Enables or disables analytics in the Marketing Cloud SDK.
  ///
  /// @param analyticsEnabled A flag indicating whether analytics should be enabled.
  ///
  /// See also:
  /// - [Android Docs](https://salesforce-marketingcloud.github.io/MarketingCloudSDK-Android/sdk-implementation/runtime-toggles.html)
  /// - [iOS Docs](https://salesforce-marketingcloud.github.io/MarketingCloudSDK-iOS/sdk-implementation/runtime-toggles.html)
  static Future<void> setAnalyticsEnabled(bool analyticsEnabled) {
    return SfmcPlatform.instance.setAnalyticsEnabled(analyticsEnabled);
  }

  /// Checks if analytics is enabled in the Marketing Cloud SDK.
  ///
  /// Returns a Future to the boolean representation of whether analytics is enabled.
  ///
  /// See also:
  /// - [Android Docs](https://salesforce-marketingcloud.github.io/MarketingCloudSDK-Android/sdk-implementation/runtime-toggles.html)
  /// - [iOS Docs](https://salesforce-marketingcloud.github.io/MarketingCloudSDK-iOS/sdk-implementation/runtime-toggles.html)
  static Future<bool> isAnalyticsEnabled() {
    return SfmcPlatform.instance.isAnalyticsEnabled();
  }

  /// Enables or disables Predictive Intelligence analytics in the Marketing Cloud SDK.
  ///
  /// [analyticsEnabled] A flag indicating whether PI analytics should be enabled.
  ///
  /// See also:
  /// - [Android Docs](https://salesforce-marketingcloud.github.io/MarketingCloudSDK-Android/sdk-implementation/runtime-toggles.html)
  /// - [iOS Docs](https://salesforce-marketingcloud.github.io/MarketingCloudSDK-iOS/sdk-implementation/runtime-toggles.html)
  static Future<void> setPiAnalyticsEnabled(bool analyticsEnabled) {
    return SfmcPlatform.instance.setPiAnalyticsEnabled(analyticsEnabled);
  }

  /// Checks if Predictive Intelligence analytics is enabled in the Marketing Cloud SDK.
  ///
  /// Returns a Future to the boolean representation of whether PI analytics is enabled.
  ///
  /// See also:
  /// - [Android Docs](https://salesforce-marketingcloud.github.io/MarketingCloudSDK-Android/sdk-implementation/runtime-toggles.html)
  /// - [iOS Docs](https://salesforce-marketingcloud.github.io/MarketingCloudSDK-iOS/sdk-implementation/runtime-toggles.html)
  static Future<bool> isPiAnalyticsEnabled() {
    return SfmcPlatform.instance.isPiAnalyticsEnabled();
  }

  /// Retrieves the list of Active, Read & Unread, not Deleted Inbox Messages.
  ///
  /// Returns a Future to the list of InboxMessage representing Active, Read & Unread, not Deleted Inbox Messages.
  ///
  /// See also:
  /// - [Android Docs](https://salesforce-marketingcloud.github.io/MarketingCloudSDK-Android/javadocs/MarketingCloudSdk/8.0/com.salesforce.marketingcloud.messages.inbox/-inbox-message-manager/get-messages.html)
  /// - [iOS Docs](https://salesforce-marketingcloud.github.io/MarketingCloudSDK-iOS/appledocs/MarketingCloudSdk/8.1/Classes/PushModule.html#/c:@M@MarketingCloudSDK@objc(cs)SFMCSdkPushModule(im)getAllMessages)
  static Future<List<InboxMessage>> getMessages() {
    return SfmcPlatform.instance.getMessages();
  }

  /// Retrieves the list of Active, Read, not Deleted Inbox Messages
  ///
  /// Returns a Future to the list of InboxMessage representing Active, Read, not Deleted Inbox Messages.
  ///
  /// See also:
  /// - [Android Docs](https://salesforce-marketingcloud.github.io/MarketingCloudSDK-Android/javadocs/MarketingCloudSdk/8.0/com.salesforce.marketingcloud.messages.inbox/-inbox-message-manager/get-read-messages.html)
  /// - [iOS Docs](https://salesforce-marketingcloud.github.io/MarketingCloudSDK-iOS/appledocs/MarketingCloudSdk/8.1/Classes/PushModule.html#/c:@M@MarketingCloudSDK@objc(cs)SFMCSdkPushModule(im)getReadMessages)
  static Future<List<InboxMessage>> getReadMessages() {
    return SfmcPlatform.instance.getReadMessages();
  }

  /// Retrieves the list of Active, Unread, not Deleted Inbox Messages
  ///
  /// Returns a Future to the list of InboxMessage representing Active, Unread, not Deleted Inbox Messages.
  ///
  /// See also:
  /// - [Android Docs](https://salesforce-marketingcloud.github.io/MarketingCloudSDK-Android/javadocs/MarketingCloudSdk/8.0/com.salesforce.marketingcloud.messages.inbox/-inbox-message-manager/get-unread-messages.html)
  /// - [iOS Docs](https://salesforce-marketingcloud.github.io/MarketingCloudSDK-iOS/appledocs/MarketingCloudSdk/8.1/Classes/PushModule.html#/c:@M@MarketingCloudSDK@objc(cs)SFMCSdkPushModule(im)getUnreadMessages)
  static Future<List<InboxMessage>> getUnreadMessages() {
    return SfmcPlatform.instance.getUnreadMessages();
  }

  /// Retrieves the list of Active, Deleted Inbox Messages
  ///
  /// Returns a Future to the list of InboxMessage representing Active, Deleted Inbox Messages.
  ///
  /// See also:
  /// - [Android Docs](https://salesforce-marketingcloud.github.io/MarketingCloudSDK-Android/javadocs/MarketingCloudSdk/8.0/com.salesforce.marketingcloud.messages.inbox/-inbox-message-manager/get-deleted-messages.html)
  /// - [iOS Docs](https://salesforce-marketingcloud.github.io/MarketingCloudSDK-iOS/appledocs/MarketingCloudSdk/8.1/Classes/PushModule.html#/c:@M@MarketingCloudSDK@objc(cs)SFMCSdkPushModule(im)getDeletedMessages)
  static Future<List<InboxMessage>> getDeletedMessages() {
    return SfmcPlatform.instance.getDeletedMessages();
  }

  /// Marks a InboxMessage as read in local storage.
  ///
  /// @param id The InboxMessage#id() of the InboxMessage to mark as read.
  ///
  /// See:
  /// - [Android Docs](https://salesforce-marketingcloud.github.io/MarketingCloudSDK-Android/javadocs/MarketingCloudSdk/8.0/com.salesforce.marketingcloud.messages.inbox/-inbox-message-manager/set-message-read.html)
  /// - [iOS Docs](https://salesforce-marketingcloud.github.io/MarketingCloudSDK-iOS/appledocs/MarketingCloudSdk/8.1/Classes/PushModule.html#/c:@M@MarketingCloudSDK@objc(cs)SFMCSdkPushModule(im)markMessageWithIdReadWithMessageId:)
  static Future<void> setMessageRead(String id) {
    return SfmcPlatform.instance.setMessageRead(id);
  }

  /// Marks a InboxMessage as deleted in local storage.
  ///
  /// @param id The InboxMessage#id() of the InboxMessage to mark as deleted.
  ///
  /// See:
  /// - [Android Docs](https://salesforce-marketingcloud.github.io/MarketingCloudSDK-Android/javadocs/MarketingCloudSdk/8.0/com.salesforce.marketingcloud.messages.inbox/-inbox-message-manager/delete-message.html)
  /// - [iOS Docs](https://salesforce-marketingcloud.github.io/MarketingCloudSDK-iOS/appledocs/MarketingCloudSdk/8.1/Classes/PushModule.html#/c:@M@MarketingCloudSDK@objc(cs)SFMCSdkPushModule(im)markMessageWithIdDeletedWithMessageId:)
  static Future<void> deleteMessage(String id) {
    return SfmcPlatform.instance.deleteMessage(id);
  }

  /// Retrieves the total number of not deleted Inbox Messages.
  ///
  /// Returns a Future to the int representing total number of not deleted Inbox Messages.
  ///
  /// See also:
  /// - [Android Docs](https://salesforce-marketingcloud.github.io/MarketingCloudSDK-Android/javadocs/MarketingCloudSdk/8.0/com.salesforce.marketingcloud.messages.inbox/-inbox-message-manager/get-message-count.html)
  /// - [iOS Docs](https://salesforce-marketingcloud.github.io/MarketingCloudSDK-iOS/appledocs/MarketingCloudSdk/8.1/Classes/PushModule.html#/c:@M@MarketingCloudSDK@objc(cs)SFMCSdkPushModule(im)getAllMessagesCount)
  static Future<int> getMessageCount() {
    return SfmcPlatform.instance.getMessageCount();
  }

  /// Retrieves the total number of read, not deleted Inbox Messages.
  ///
  /// Returns a Future to the int representing total number of read, not deleted Inbox Messages.
  ///
  /// See also:
  /// - [Android Docs](https://salesforce-marketingcloud.github.io/MarketingCloudSDK-Android/javadocs/MarketingCloudSdk/8.0/com.salesforce.marketingcloud.messages.inbox/-inbox-message-manager/get-read-message-count.html)
  /// - [iOS Docs](https://salesforce-marketingcloud.github.io/MarketingCloudSDK-iOS/appledocs/MarketingCloudSdk/8.1/Classes/PushModule.html#/c:@M@MarketingCloudSDK@objc(cs)SFMCSdkPushModule(im)getReadMessagesCount)
  static Future<int> getReadMessageCount() {
    return SfmcPlatform.instance.getReadMessageCount();
  }

  /// Retrieves the total number of unread, not deleted Inbox Messages
  ///
  /// Returns a Future to the int representing total number of unread, not deleted Inbox Messages.
  ///
  /// See also:
  /// - [Android Docs](https://salesforce-marketingcloud.github.io/MarketingCloudSDK-Android/javadocs/MarketingCloudSdk/8.0/com.salesforce.marketingcloud.messages.inbox/-inbox-message-manager/get-unread-message-count.html)
  /// - [iOS Docs](https://salesforce-marketingcloud.github.io/MarketingCloudSDK-iOS/appledocs/MarketingCloudSdk/8.1/Classes/PushModule.html#/c:@M@MarketingCloudSDK@objc(cs)SFMCSdkPushModule(im)getUnreadMessagesCount)
  static Future<int> getUnreadMessageCount() {
    return SfmcPlatform.instance.getUnreadMessageCount();
  }

  /// Retrieves the total number of deleted Inbox Messages regardless of their read status.
  ///
  /// Returns a Future to the int representing total number of unread, not deleted Inbox Messages.
  ///
  /// See also:
  /// - [Android Docs](https://salesforce-marketingcloud.github.io/MarketingCloudSDK-Android/javadocs/MarketingCloudSdk/8.0/com.salesforce.marketingcloud.messages.inbox/-inbox-message-manager/get-deleted-message-count.html)
  /// - [iOS Docs](https://salesforce-marketingcloud.github.io/MarketingCloudSDK-iOS/appledocs/MarketingCloudSdk/8.1/Classes/PushModule.html#/c:@M@MarketingCloudSDK@objc(cs)SFMCSdkPushModule(im)getDeletedMessagesCount)
  static Future<int> getDeletedMessageCount() {
    return SfmcPlatform.instance.getDeletedMessageCount();
  }

  /// Marks all active, unread InboxMessages as read.
  ///
  /// Returns a Future to the void that marks all active, unread InboxMessages as read.
  ///
  /// See also:
  /// - [Android Docs](https://salesforce-marketingcloud.github.io/MarketingCloudSDK-Android/javadocs/MarketingCloudSdk/8.0/com.salesforce.marketingcloud.messages.inbox/-inbox-message-manager/mark-all-messages-read.html)
  /// - [iOS Docs](https://salesforce-marketingcloud.github.io/MarketingCloudSDK-iOS/appledocs/MarketingCloudSdk/8.1/Classes/PushModule.html#/c:@M@MarketingCloudSDK@objc(cs)SFMCSdkPushModule(im)markAllMessagesRead)
  static Future<void> markAllMessagesRead() {
    return SfmcPlatform.instance.markAllMessagesRead();
  }

  /// Marks all active InboxMessages as deleted.
  ///
  /// Returns a Future to to the void that Marks all active InboxMessages as deleted.
  ///
  /// See also:
  /// - [Android Docs](https://salesforce-marketingcloud.github.io/MarketingCloudSDK-Android/javadocs/MarketingCloudSdk/8.0/com.salesforce.marketingcloud.messages.inbox/-inbox-message-manager/mark-all-messages-deleted.html)
  /// - [iOS Docs](https://salesforce-marketingcloud.github.io/MarketingCloudSDK-iOS/appledocs/MarketingCloudSdk/8.1/Classes/PushModule.html#/c:@M@MarketingCloudSDK@objc(cs)SFMCSdkPushModule(im)markAllMessagesDeleted)
  static Future<void> markAllMessagesDeleted() {
    return SfmcPlatform.instance.markAllMessagesDeleted();
  }

  /// Requests an updated list of Inbox Messages from the Marketing Cloud Servers. The Inbox request can be made, at most, once per minute. This throttle also includes the Inbox request that is made by the SDK when your application is brought into the foreground.
  ///
  /// Returns a Future to the boolean representation if inbox has been refreshed or not.
  ///
  /// See also:
  /// - [Android Docs](https://salesforce-marketingcloud.github.io/MarketingCloudSDK-Android/javadocs/MarketingCloudSdk/8.0/com.salesforce.marketingcloud.messages.inbox/-inbox-message-manager/refresh-inbox.html)
  /// - [iOS Docs](https://salesforce-marketingcloud.github.io/MarketingCloudSDK-iOS/appledocs/MarketingCloudSdk/8.1/Classes/PushModule.html#/c:@M@MarketingCloudSDK@objc(cs)SFMCSdkPushModule(im)refreshMessages)
  static Future<bool> refreshInbox(InboxRefreshListener callback) {
    return SfmcPlatform.instance.refreshInbox(callback);
  }

  /// Call this method to be notified of Inbox events within the Marketing Cloud SDK.
  ///
  /// @param callback The InboxResponseListener that you want to register.
  ///
  /// See also:
  /// - [Android Docs](https://salesforce-marketingcloud.github.io/MarketingCloudSDK-Android/javadocs/MarketingCloudSdk/8.0/com.salesforce.marketingcloud.messages.inbox/-inbox-message-manager/register-inbox-response-listener.html)
  /// - [iOS Docs](https://developer.salesforce.com/docs/marketing/mobilepush/guide/implement-inbox-messaging-ios.html)
  static Future<void> registerInboxResponseListener(
      InboxResponseListener callback) {
    return SfmcPlatform.instance.registerInboxResponseListener(callback);
  }

  /// Unregister your InboxMessageManager.InboxResponseListener listener.
  ///
  ///@param callback The InboxResponseListener that you want to unregister.
  ///
  /// See also:
  /// - [Android Docs](https://salesforce-marketingcloud.github.io/MarketingCloudSDK-Android/javadocs/MarketingCloudSdk/8.0/com.salesforce.marketingcloud.messages.inbox/-inbox-message-manager/unregister-inbox-response-listener.html)
  /// - [iOS Docs](https://developer.salesforce.com/docs/marketing/mobilepush/guide/implement-inbox-messaging-ios.html)
  static Future<void> unregisterInboxResponseListener(
      InboxResponseListener callback) {
    return SfmcPlatform.instance.unregisterInboxResponseListener(callback);
  }
}
