package com.salesforce.marketingcloud.sfmc_example

import io.flutter.app.FlutterApplication
import com.salesforce.marketingcloud.MCLogListener
import com.salesforce.marketingcloud.MarketingCloudConfig
import com.salesforce.marketingcloud.MarketingCloudSdk
import com.salesforce.marketingcloud.notifications.NotificationCustomizationOptions
import com.salesforce.marketingcloud.sfmcsdk.SFMCSdk
import com.salesforce.marketingcloud.sfmcsdk.SFMCSdkModuleConfig
import android.util.Log

class MainApplication : FlutterApplication() {
    override fun onCreate() {
        super.onCreate()

        SFMCSdk.configure(
                applicationContext,
                SFMCSdkModuleConfig.build {
                    pushModuleConfig =
                            MarketingCloudConfig.builder()
                                    .apply {
                                        setApplicationId("MC_APP_ID")
                                        setAccessToken("MC_ACCESS_TOKEN")
                                        setMid("MC_MID")
                                        setMarketingCloudServerUrl("MC_APP_SERVER_URL")
                                        setSenderId("FCM_SENDER_ID_FOR_MC_APP")
                                        setNotificationCustomizationOptions(NotificationCustomizationOptions.create(R.mipmap.ic_launcher))
                                    }
                                    .build(applicationContext)
                }
        ) { initStatus ->
           Log.d("SFMCSdk Initialization ", initStatus.status.toString())
        }
    }
}
