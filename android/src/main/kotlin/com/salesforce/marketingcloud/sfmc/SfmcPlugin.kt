// SfmcPlugin.kt
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

package com.salesforce.marketingcloud.sfmc

import com.salesforce.marketingcloud.messages.inbox.*
import android.content.Context
import android.content.SyncResult
import android.util.Log
import androidx.annotation.NonNull
import com.salesforce.marketingcloud.MCLogListener
import com.salesforce.marketingcloud.MarketingCloudSdk
import com.salesforce.marketingcloud.sfmcsdk.SFMCSdk
import com.salesforce.marketingcloud.sfmcsdk.components.events.Event
import com.salesforce.marketingcloud.sfmcsdk.components.identity.Identity
import com.salesforce.marketingcloud.sfmcsdk.components.logging.LogLevel
import com.salesforce.marketingcloud.sfmcsdk.components.logging.LogListener
import com.salesforce.marketingcloud.sfmcsdk.modules.push.PushModuleInterface

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import java.util.HashMap


class SfmcPlugin : FlutterPlugin, MethodCallHandler {
    private lateinit var channel: MethodChannel
    private lateinit var context: Context

    companion object {
        private const val TAG = "~&SFMCPlugin"
    }

    override fun onAttachedToEngine(
        @NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding
    ) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "sfmc")
        channel.setMethodCallHandler(this)
        context = flutterPluginBinding.applicationContext
        handlePushAction {
            it.registrationManager.edit().addTag("Flutter").commit()
        }
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        when (call.method) {
            "getPlatformVersion" -> getPlatformVersion(result)
            "logSdkState" -> logSdkState(result)
            "enableLogging" -> enableLogging(result)
            "disableLogging" -> disableLogging(result)
            "getSystemToken" -> getSystemToken(result)
            "isPushEnabled" -> isPushEnabled(result)
            "enablePush" -> enablePush(result)
            "disablePush" -> disablePush(result)
            "getDeviceId" -> getDeviceId(result)
            "getTags" -> getTags(result)
            "addTag" -> addTag(call, result)
            "removeTag" -> removeTag(call, result)
            "getContactKey" -> getContactKey(result)
            "setContactKey" -> setContactKey(call, result)
            "getAttributes" -> getAttributes(result)
            "setAttribute" -> setAttribute(call, result)
            "clearAttribute" -> clearAttribute(call, result)
            "trackEvent" -> trackEvent(call, result)
            "isAnalyticsEnabled" -> isAnalyticsEnabled(result)
            "setAnalyticsEnabled" -> setAnalyticsEnabled(call, result)
            "isPiAnalyticsEnabled" -> isPiAnalyticsEnabled(result)
            "setPiAnalyticsEnabled" -> setPiAnalyticsEnabled(call, result)
            "getMessages" -> getMessages(result)
            "getReadMessages" -> getReadMessages(result)
            "getUnreadMessages" -> getUnreadMessages(result)
            "getDeletedMessages" -> getDeletedMessages(result)
            "getMessageCount" -> getMessageCount(result)
            "getReadMessageCount" -> getReadMessageCount(result)
            "getUnreadMessageCount" -> getUnreadMessageCount(result)
            "getDeletedMessageCount" -> getDeletedMessageCount(result)
            "setMessageRead" -> setMessageRead(call, result)
            "deleteMessage" -> deleteMessage(call, result)
            "markAllMessagesRead" -> markAllMessagesRead(result)
            "markAllMessagesDeleted" -> markAllMessagesDeleted(result)
            "refreshInbox" -> refreshInbox(result)
            "registerInboxResponseListener" -> registerInboxResponseListener(result)
            "unregisterInboxResponseListener" -> unregisterInboxResponseListener(result)
            else -> result.notImplemented()
        }
    }

    private fun getPlatformVersion(result: Result) {
        result.success("Android ${android.os.Build.VERSION.RELEASE}")
    }

    private fun logSdkState(result: Result) {
        handleSFMCAction {
            try {
                Log.d(TAG, "SDK State: " + it.getSdkState().toString(2))
                result.success(null)
            } catch (e: Exception) {
                result.error("SDK_STATE_ERROR", e.message, null)
            }
        }
    }

    private fun enableLogging(result: Result) {
        SFMCSdk.setLogging(LogLevel.DEBUG, LogListener.AndroidLogger())
        MarketingCloudSdk.setLogLevel(MCLogListener.VERBOSE)
        MarketingCloudSdk.setLogListener(MCLogListener.AndroidLogListener())
        result.success(null)
    }

    private fun disableLogging(result: Result) {
        SFMCSdk.setLogging(LogLevel.NONE, null)
        MarketingCloudSdk.setLogListener(null)
        result.success(null)
    }

    private fun getSystemToken(result: Result) {
        handlePushAction {
            val token = it.registrationManager.getSystemToken()
            result.success(token)
        }
    }

    private fun isPushEnabled(result: Result) {
        handlePushAction {
            val isPushEnabled = it.pushMessageManager.isPushEnabled()
            result.success(isPushEnabled)
        }
    }

    private fun enablePush(result: Result) {
        handlePushAction {
            it.pushMessageManager.enablePush()
            result.success(null)
        }
    }

    private fun disablePush(result: Result) {
        handlePushAction {
            it.pushMessageManager.disablePush()
            result.success(null)
        }
    }

    private fun getDeviceId(result: Result) {
        handlePushAction {
            val deviceId = it.registrationManager.getDeviceId()
            result.success(deviceId)
        }
    }

    private fun getContactKey(result: Result) {
        handlePushAction {
            val contactKey = it.registrationManager.getContactKey()
            result.success(contactKey)
        }
    }

    private fun setContactKey(call: MethodCall, result: Result) {
        call.argument<String?>("contactKey")?.let { contactKey ->
            handleIdentityAction {
                it.setProfileId(contactKey)
                result.success(null)
            }
        } ?: result.error("INVALID_ARGUMENTS", "contactKey is null", null)
    }

    private fun getAttributes(result: Result) {
        handlePushAction {
            val attributes = it.registrationManager.getAttributes()
            result.success(attributes)
        }
    }

    private fun setAttribute(call: MethodCall, result: Result) {
        val key: String? = call.argument("key")
        val value: String? = call.argument("value")
        key?.let { key ->
            handleIdentityAction {
                it.setProfileAttribute(key, value)
                result.success(null)
            }
        } ?: result.error("INVALID_ARGUMENTS", "attribute key is null", null)
    }

    private fun clearAttribute(call: MethodCall, result: Result) {
        call.argument<String?>("key")?.let { key ->
            handleIdentityAction {
                it.clearProfileAttribute(key)
                result.success(null)
            }
        } ?: result.error("INVALID_ARGUMENTS", "clearAttribute key is null", null)
    }

    private fun getTags(result: Result) {
        handlePushAction {
            val tags = it.registrationManager.getTags()
            result.success(tags.toList())
        }
    }

    private fun addTag(call: MethodCall, result: Result) {
        call.argument<String?>("tag")?.let { tag ->
            handlePushAction {
                it.registrationManager.edit().addTag(tag).commit()
                result.success(null)
            }
        } ?: result.error("INVALID_ARGUMENTS", "tag is null", null)
    }

    private fun removeTag(call: MethodCall, result: Result) {
        call.argument<String?>("tag")?.let { tag ->
            handlePushAction {
                it.registrationManager.edit().removeTag(tag).commit()
                result.success(null)
            }
        } ?: result.error("INVALID_ARGUMENTS", "tag is null", null)
    }

    private fun trackEvent(call: MethodCall, result: Result) {
        try {
            val eventJson = call.arguments as? Map<String, Any?> ?: run {
                result.error("INVALID_ARGUMENTS", "No event data provided", null)
                return
            }

            val event: Event? = EventUtility.toEvent(eventJson)
            event?.let {
                SFMCSdk.track(it)
                result.success(null)
            } ?: run {
                result.error("EVENT_PARSING_ERROR", "Could not parse event data", null)
            }
        } catch (e: Exception) {
            Log.e(TAG, "Error in tracking event: ${e.message}")
            result.error("TRACK_EVENT_ERROR", "Error tracking event: ${e.message}", null)
        }
    }

    private fun isAnalyticsEnabled(result: Result) {
        handlePushAction {
            val isEnabled = it.analyticsManager.areAnalyticsEnabled()
            result.success(isEnabled)
        }
    }

    private fun setAnalyticsEnabled(call: MethodCall, result: Result) {
        val enable: Boolean = call.argument("analyticsEnabled") ?: false
        handlePushAction {
            if (enable) {
                it.analyticsManager.enableAnalytics()
            } else {
                it.analyticsManager.disableAnalytics()
            }
            result.success(null)
        }
    }

    private fun isPiAnalyticsEnabled(result: Result) {
        handlePushAction {
            val isEnabled = it.analyticsManager.arePiAnalyticsEnabled()
            result.success(isEnabled)
        }
    }

    private fun setPiAnalyticsEnabled(call: MethodCall, result: Result) {
        val enable: Boolean = call.argument("analyticsEnabled") ?: false
        handlePushAction {
            if (enable) {
                it.analyticsManager.enablePiAnalytics()
            } else {
                it.analyticsManager.disablePiAnalytics()
            }
            result.success(null)
        }
    }

    private fun getMessages(result: Result) {
        handlePushAction {
            val inboxMessages: List<InboxMessage> = it.inboxMessageManager.getMessages()
            val str: List<String> = InboxUtils.inboxMessagesToString(inboxMessages)
            result.success(str)
        }
    }

    private fun getReadMessages(result: Result) {
        handlePushAction {
            val inboxMessages: List<InboxMessage> = it.inboxMessageManager.getReadMessages()
            val str: List<String> = InboxUtils.inboxMessagesToString(inboxMessages)
            result.success(str)
        }
    }

    private fun getUnreadMessages(result: Result) {
        handlePushAction {
            val inboxMessages: List<InboxMessage> =
                it.inboxMessageManager.getUnreadMessages()
            val str: List<String> = InboxUtils.inboxMessagesToString(inboxMessages)
            result.success(str)
        }
    }

    private fun getDeletedMessages(result: Result) {
        handlePushAction {
            val inboxMessages: List<InboxMessage> =
                it.inboxMessageManager.getDeletedMessages()
            val str: List<String> = InboxUtils.inboxMessagesToString(inboxMessages)
            result.success(str)
        }
    }

    private fun setMessageRead(call: MethodCall, result: Result) {
        call.argument<String?>("messageId")?.let { messageId ->
            handlePushAction {
                it.inboxMessageManager.setMessageRead(messageId)
                result.success(null)
            }
        } ?: result.error("INVALID_ARGUMENTS", "messageId is null", null)

    }

    private fun deleteMessage(call: MethodCall, result: Result) {
        call.argument<String?>("messageId")?.let { messageId ->
            handlePushAction {
                it.inboxMessageManager.deleteMessage(messageId)
                result.success(null)
            }
        } ?: result.error("INVALID_ARGUMENTS", "messageId is null", null)

    }

    private fun getMessageCount(result: Result) {
        handlePushAction {
            val count = it.inboxMessageManager.getMessageCount()
            result.success(count)
        }
    }

    private fun getReadMessageCount(result: Result) {
        handlePushAction {
            val count = it.inboxMessageManager.getReadMessageCount()
            result.success(count)
        }
    }

    private fun getUnreadMessageCount(result: Result) {
        handlePushAction {
            val count = it.inboxMessageManager.getUnreadMessageCount()
            result.success(count)
        }
    }

    private fun getDeletedMessageCount(result: Result) {
        handlePushAction {
            val count = it.inboxMessageManager.getDeletedMessageCount()
            result.success(count)
        }
    }

    private fun markAllMessagesRead(result: Result) {
        handlePushAction {
            it.inboxMessageManager.markAllMessagesRead()
            result.success(null)
        }
    }

    private fun markAllMessagesDeleted(result: Result) {
        handlePushAction {
            it.inboxMessageManager.markAllMessagesDeleted()
            result.success(null)
        }
    }

    private fun refreshInbox(result: Result) {
        handlePushAction {
            it.inboxMessageManager.refreshInbox(object :
                InboxMessageManager.InboxRefreshListener {
                override fun onRefreshComplete(successful: Boolean) {
                    result.success(successful)
                    Log.d(TAG, "Inbox refresh completed successfully: $successful")
                }
            })
        }
    }

    private var inboxResponseListener: InboxMessageManager.InboxResponseListener? = null

    private fun createInboxResponseListener(result: Result): InboxMessageManager.InboxResponseListener {
        return object : InboxMessageManager.InboxResponseListener {
            override fun onInboxMessagesChanged(messages: MutableList<InboxMessage>) {
                try {
                    val str: List<String> = InboxUtils.inboxMessagesToString(messages)
                    channel.invokeMethod("onInboxMessagesChanged", str)
                } catch (e: Exception) {
                    result.error(
                        "UNREGISTER_ERROR",
                        "Failed to unregister listener: ${e.message}",
                        null
                    )
                }
            }
        }.also { inboxResponseListener = it }
    }

    private fun registerInboxResponseListener(result: Result) {
        val listener = createInboxResponseListener(result)
        handlePushAction {
            it.inboxMessageManager.registerInboxResponseListener(listener)
            result.success(null)
        }
    }

    private fun unregisterInboxResponseListener(result: Result) {
        val listener = inboxResponseListener
        if (listener != null) {
            handlePushAction {
                it.inboxMessageManager.unregisterInboxResponseListener(listener)
                inboxResponseListener = null
                result.success(null)
            }
        } else {
            result.error("Error", "Listener not found", null)
        }
    }

    private fun handleSFMCAction(action: (SFMCSdk) -> Unit) {
        SFMCSdk.requestSdk { sdk ->
            action(sdk)
        }
    }

    private fun handlePushAction(action: (PushModuleInterface) -> Unit) {
        handleSFMCAction {
            it.mp { pushModule ->
                action(pushModule)
            }
        }
    }

    private fun handleIdentityAction(action: (Identity) -> Unit) {
        handleSFMCAction {
            action(it.identity)
        }
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }
}
