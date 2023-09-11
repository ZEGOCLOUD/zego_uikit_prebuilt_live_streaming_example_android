package com.zegocloud.uikit.livestreaming;

import android.os.Bundle;
import androidx.appcompat.app.AppCompatActivity;
import com.zegocloud.uikit.prebuilt.livestreaming.ZegoUIKitPrebuiltLiveStreamingConfig;
import com.zegocloud.uikit.prebuilt.livestreaming.ZegoUIKitPrebuiltLiveStreamingFragment;

public class LiveActivity extends AppCompatActivity {

    private static final String TAG = "LiveActivity";

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_live);

        addFragment();
    }

    private void addFragment() {
        long appID = getIntent().getLongExtra("appID", 0L);
        String appSign = getIntent().getStringExtra("appSign");
        String userID = getIntent().getStringExtra("userID");
        String userName = getIntent().getStringExtra("userName");

        boolean isHost = getIntent().getBooleanExtra("host", false);
        String liveID = getIntent().getStringExtra("liveID");

        ZegoUIKitPrebuiltLiveStreamingConfig config;
        if (isHost) {
            config = ZegoUIKitPrebuiltLiveStreamingConfig.host(true);
        } else {
            config = ZegoUIKitPrebuiltLiveStreamingConfig.audience(true);
        }


        ZegoUIKitPrebuiltLiveStreamingFragment fragment = ZegoUIKitPrebuiltLiveStreamingFragment.newInstance(appID,
            appSign, userID, userName, liveID, config);
        getSupportFragmentManager().beginTransaction().replace(R.id.fragment_container, fragment).commitNow();
    }
}