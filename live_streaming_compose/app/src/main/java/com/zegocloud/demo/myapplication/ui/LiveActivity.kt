package com.zegocloud.demo.myapplication.ui

import android.os.Bundle
import androidx.appcompat.app.AppCompatActivity
import com.zegocloud.demo.myapplication.R
import com.zegocloud.uikit.prebuilt.livestreaming.ZegoUIKitPrebuiltLiveStreamingConfig
import com.zegocloud.uikit.prebuilt.livestreaming.ZegoUIKitPrebuiltLiveStreamingFragment

class LiveActivity : AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_live)

        addFragment()
    }


    private fun addFragment() {
        val appID =
        val appSign =
        val userID = "123324"
        val userName = "235345"
        val isHost = true
        val liveID = "345345"
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