// MainApplication.kt
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

package com.salesforce.marketingcloud.sfmc_example

import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.net.Uri
import android.os.Build
import android.util.Log
import com.salesforce.marketingcloud.MarketingCloudConfig
import com.salesforce.marketingcloud.notifications.NotificationCustomizationOptions
import com.salesforce.marketingcloud.notifications.NotificationManager
import com.salesforce.marketingcloud.notifications.NotificationMessage
import com.salesforce.marketingcloud.sfmcsdk.InitializationStatus
import com.salesforce.marketingcloud.sfmcsdk.SFMCSdk
import com.salesforce.marketingcloud.sfmcsdk.SFMCSdkModuleConfig
import io.flutter.app.FlutterApplication
import java.util.Random

class MainApplication : FlutterApplication() {
    companion object {
        private const val TAG = "~&SFMC Example App"
    }

    override fun onCreate() {
        super.onCreate()
        SFMCSdk.configure(applicationContext, SFMCSdkModuleConfig.build {
            pushModuleConfig = MarketingCloudConfig.builder().apply {
                setApplicationId(BuildConfig.PUSH_APP_ID)
                setAccessToken(BuildConfig.PUSH_ACCESS_TOKEN)
                setMarketingCloudServerUrl(BuildConfig.PUSH_TSE)
                setSenderId(BuildConfig.PUSH_SENDER_ID)
                setAnalyticsEnabled(true)
                setNotificationCustomizationOptions(NotificationCustomizationOptions.create { context: Context, notificationMessage: NotificationMessage ->
                    NotificationManager.createDefaultNotificationChannel(context).let { channelId ->
                        NotificationManager.getDefaultNotificationBuilder(
                            context,
                            notificationMessage,
                            channelId,
                            R.mipmap.ic_launcher
                        ).apply {
                            setContentIntent(
                                NotificationManager.redirectIntentForAnalytics(
                                    context,
                                    getPendingIntent(context, notificationMessage),
                                    notificationMessage,
                                    true
                                )
                            )
                        }
                    }
                })
            }.build(applicationContext)
        }) { initStatus ->
            when (initStatus.status) {
                InitializationStatus.SUCCESS -> Log.d(TAG, "SFMC SDK Initialization Successful")
                InitializationStatus.FAILURE -> Log.d(TAG, "SFMC SDK Initialization Failed")
                else -> Log.d(TAG, "SFMC SDK Initialization Status: Unknown")
            }
        }
    }

    private fun provideIntentFlags(): Int {
        return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        } else {
            PendingIntent.FLAG_UPDATE_CURRENT
        }
    }

    private fun getPendingIntent(
        context: Context,
        notificationMessage: NotificationMessage
    ): PendingIntent {
        val intent = if (notificationMessage.url.isNullOrEmpty()) {
            context.packageManager.getLaunchIntentForPackage(context.packageName)
        } else {
            Intent(Intent.ACTION_VIEW, Uri.parse(notificationMessage.url))
        }
        return PendingIntent.getActivity(context, Random().nextInt(), intent, provideIntentFlags())
    }
}
