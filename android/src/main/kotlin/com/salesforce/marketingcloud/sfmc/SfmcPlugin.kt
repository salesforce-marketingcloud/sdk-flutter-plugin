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
        // SFMCSdk.setLogging(LogLevel.DEBUG, LogListener.AndroidLogger())
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

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }
}
