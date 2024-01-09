package com.salesforce.marketingcloud.sfmc

import android.content.Context
import android.util.Log
import androidx.annotation.NonNull
import com.salesforce.marketingcloud.MCLogListener
import com.salesforce.marketingcloud.MarketingCloudConfig
import com.salesforce.marketingcloud.MarketingCloudSdk
import com.salesforce.marketingcloud.notifications.NotificationCustomizationOptions
import com.salesforce.marketingcloud.sfmcsdk.SFMCSdk
import com.salesforce.marketingcloud.sfmcsdk.SFMCSdkModuleConfig
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

class SfmcPlugin : FlutterPlugin, MethodCallHandler {
    private lateinit var channel: MethodChannel
    private lateinit var context: Context

    override fun onAttachedToEngine(
        @NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding
    ) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "sfmc")
        channel.setMethodCallHandler(this)
        context = flutterPluginBinding.applicationContext
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
            // For track method, you need to implement conversion from Map to Event
            else -> result.notImplemented()
        }
    }


    private fun getPlatformVersion(result: Result) {
        result.success("Android ${android.os.Build.VERSION.RELEASE}")
    }

    private fun logSdkState(result: Result) {
        SFMCSdk.requestSdk { sdk ->
            try {
                Log.d("~#RNMCSdkModule", "SDK State: " + sdk.getSdkState().toString(2))
                result.success(null)
            } catch (e: Exception) {
                result.error("SDK_STATE_ERROR", e.message, null)
            }
        }
    }

    private fun enableLogging(result: Result) {
        MarketingCloudSdk.setLogLevel(MCLogListener.VERBOSE)
        MarketingCloudSdk.setLogListener(MCLogListener.AndroidLogListener())
        result.success(null)
    }

    private fun disableLogging(result: Result) {
        MarketingCloudSdk.setLogListener(null)
        result.success(null)
    }

    private fun getSystemToken(result: Result) {
        SFMCSdk.requestSdk { sdk ->
            sdk.mp {
                var token = it.registrationManager.getSystemToken()
                result.success(token)
            }
        }
    }

    private fun isPushEnabled(result: Result) {
        SFMCSdk.requestSdk { sdk ->
            sdk.mp {
                val isPushEnabled = it.pushMessageManager.isPushEnabled()
                result.success(isPushEnabled)
            }
        }
    }

    private fun enablePush(result: Result) {
        SFMCSdk.requestSdk { sdk ->
            sdk.mp {
                it.pushMessageManager.enablePush()
                result.success(null)
            }
        }
    }

    private fun disablePush(result: Result) {
        SFMCSdk.requestSdk { sdk ->
            sdk.mp {
                it.pushMessageManager.disablePush()
                result.success(null)
            }
        }
    }

    private fun getDeviceId(result: Result) {
        SFMCSdk.requestSdk { sdk ->
            sdk.mp {
                val deviceId = it.registrationManager.getDeviceId()
                result.success(deviceId)
            }
        }
    }

    private fun getContactKey(result: Result) {
        SFMCSdk.requestSdk { sdk ->
            sdk.mp {
                val contactKey = it.registrationManager.getContactKey()
                result.success(contactKey)
            }
        }
    }

    private fun setContactKey(call: MethodCall, result: Result) {
        val contactKey: String? = call.argument("contactKey")
        SFMCSdk.requestSdk { sdk ->
            sdk.identity.setProfileId(contactKey ?: "")
            result.success(null)
        }
    }

    private fun getAttributes(result: Result) {
        SFMCSdk.requestSdk { sdk ->
            sdk.mp {
                val attributes = it.registrationManager.getAttributes()
                result.success(attributes)
            }
        }
    }

    private fun setAttribute(call: MethodCall, result: Result) {
        val key: String? = call.argument("key")
        val value: String? = call.argument("value")
        SFMCSdk.requestSdk { sdk ->
            sdk.identity.setProfileAttribute(key ?: "", value ?: "")
            result.success(null)
        }
    }

    private fun clearAttribute(call: MethodCall, result: Result) {
        val key: String? = call.argument("key")
        SFMCSdk.requestSdk { sdk ->
            sdk.identity.clearProfileAttribute(key ?: "")
            result.success(null)
        }
    }

    private fun getTags(result: Result) {
        SFMCSdk.requestSdk { sdk ->
            sdk.mp {
                val tags = it.registrationManager.getTags()
                result.success(tags.toList())
            }
        }
    }

    private fun addTag(call: MethodCall, result: Result) {
        val tag: String? = call.argument("tag")
        SFMCSdk.requestSdk { sdk ->
            sdk.mp {
                it.registrationManager.edit().addTag(tag ?: "").commit()
                result.success(null)
            }
        }
    }

    private fun removeTag(call: MethodCall, result: Result) {
        val tag: String? = call.argument("tag")
        SFMCSdk.requestSdk { sdk ->
            sdk.mp {
                it.registrationManager.edit().removeTag(tag ?: "").commit()
                result.success(null)
            }
        }
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }
}
