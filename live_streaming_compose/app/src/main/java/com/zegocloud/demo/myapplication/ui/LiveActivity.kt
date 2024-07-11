package com.zegocloud.demo.myapplication.ui

import android.os.Bundle
import androidx.appcompat.app.AppCompatActivity
import com.zegocloud.demo.myapplication.R
import com.zegocloud.uikit.prebuilt.livestreaming.ZegoUIKitPrebuiltLiveStreamingConfig
import com.zegocloud.uikit.prebuilt.livestreaming.ZegoUIKitPrebuiltLiveStreamingFragment

/**
 * if AppTheme meet error,change you app theme to
 * "Theme.MaterialComponents.Light.NoActionBar.Bridge"
 */
class LiveActivity : AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_live)

        addFragment()
    }


    private fun addFragment() {
        val appID = 
        val appSign = 
        val userID = 
        val userName = 
        val isHost = true
        val liveID = 
        val config = if (isHost) {
            ZegoUIKitPrebuiltLiveStreamingConfig.host(true)
        } else {
            ZegoUIKitPrebuiltLiveStreamingConfig.audience(true)
        }
        val fragment: ZegoUIKitPrebuiltLiveStreamingFragment =
            ZegoUIKitPrebuiltLiveStreamingFragment.newInstance(appID, appSign, userID, userName, liveID, config)
        supportFragmentManager.beginTransaction().replace(R.id.fragment_container, fragment).commitNow()
    }
}