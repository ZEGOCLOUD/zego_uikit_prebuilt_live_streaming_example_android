package com.zegocloud.uikit.livestreaming;

import android.os.Bundle;
import androidx.appcompat.app.AppCompatActivity;
import com.zegocloud.uikit.prebuilt.livestreaming.ZegoUIKitPrebuiltLiveStreamingConfig;
import com.zegocloud.uikit.prebuilt.livestreaming.ZegoUIKitPrebuiltLiveStreamingFragment;

public class LiveActivity extends AppCompatActivity {

    private boolean isHost;
    private String mLiveID;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_live);

        isHost = getIntent().getBooleanExtra("host", false);
        mLiveID = getIntent().getStringExtra("liveID");
        addFragment();
    }

    private void addFragment() {
        long appID = YourAppID;
        String appSign = YourAppSign;

        String liveID = mLiveID;
        String userID = YourUserID;
        String userName = YourUserName;

        ZegoUIKitPrebuiltLiveStreamingConfig config;
        if (isHost) {
            config = new ZegoUIKitPrebuiltLiveStreamingConfig(ZegoUIKitPrebuiltLiveStreamingConfig.ROLE_HOST);
        } else {
            config = new ZegoUIKitPrebuiltLiveStreamingConfig(ZegoUIKitPrebuiltLiveStreamingConfig.ROLE_AUDIENCE);
        }

        ZegoUIKitPrebuiltLiveStreamingFragment fragment = ZegoUIKitPrebuiltLiveStreamingFragment.newInstance(
            appID, appSign, userID, userName, liveID, config);
        getSupportFragmentManager().beginTransaction()
            .replace(R.id.fragment_container, fragment)
            .commitNow();
    }
}