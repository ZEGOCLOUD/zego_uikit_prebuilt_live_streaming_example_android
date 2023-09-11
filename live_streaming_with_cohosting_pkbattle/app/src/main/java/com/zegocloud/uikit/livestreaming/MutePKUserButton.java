package com.zegocloud.uikit.livestreaming;

import android.content.Context;
import android.graphics.Color;
import android.util.AttributeSet;
import android.view.Gravity;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import com.zegocloud.uikit.components.common.ZTextButton;
import com.zegocloud.uikit.prebuilt.livestreaming.ZegoLiveStreamingManager;
import com.zegocloud.uikit.prebuilt.livestreaming.ZegoLiveStreamingManager.ZegoLiveStreamingListener;
import com.zegocloud.uikit.service.defines.ZegoUIKitCallback;
import com.zegocloud.uikit.utils.Utils;

public class MutePKUserButton extends ZTextButton {

    public MutePKUserButton(@NonNull Context context) {
        super(context);
    }

    public MutePKUserButton(@NonNull Context context, @Nullable AttributeSet attrs) {
        super(context, attrs);
    }

    public MutePKUserButton(@NonNull Context context, @Nullable AttributeSet attrs, int defStyleAttr) {
        super(context, attrs, defStyleAttr);
    }

    @Override
    protected void initView() {
        super.initView();
        setBackgroundResource(com.zegocloud.uikit.prebuilt.livestreaming.R.drawable.livestreaming_bg_cohost_btn);
        setGravity(Gravity.CENTER);
        setTextColor(Color.parseColor("#cccccc"));
        setMinWidth(Utils.dp2px(36, getResources().getDisplayMetrics()));
        int padding = Utils.dp2px(8, getResources().getDisplayMetrics());
        setPadding(padding, 0, padding, 0);
        updateButton();
        ZegoLiveStreamingManager.getInstance().addLiveStreamingListener(new ZegoLiveStreamingListener() {
            @Override
            public void onOtherHostMuted(String userID, boolean muted) {
                updateButton();
            }
        });
    }

    @Override
    protected void afterClick() {
        boolean pkUserMuted = ZegoLiveStreamingManager.getInstance().isAnotherHostMuted();
        ZegoLiveStreamingManager.getInstance().muteAnotherHostAudio(!pkUserMuted, new ZegoUIKitCallback() {
            @Override
            public void onResult(int errorCode) {

            }
        });
    }

    private void updateButton() {
        boolean pkUserMuted = ZegoLiveStreamingManager.getInstance().isAnotherHostMuted();
        if (pkUserMuted) {
            setText("Unmute user");
        } else {
            setText("Mute user");
        }
    }
}
