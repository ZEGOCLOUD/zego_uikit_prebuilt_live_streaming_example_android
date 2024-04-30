package com.zegocloud.uikit.livestreaming;

import android.content.DialogInterface;
import android.content.DialogInterface.OnClickListener;
import android.graphics.Color;
import android.os.Bundle;
import android.util.DisplayMetrics;
import android.util.TypedValue;
import android.view.Gravity;
import android.view.View;
import android.view.ViewGroup;
import android.widget.FrameLayout;
import android.widget.LinearLayout.LayoutParams;
import android.widget.TextView;
import androidx.appcompat.app.AlertDialog;
import androidx.appcompat.app.AppCompatActivity;
import androidx.core.content.ContextCompat;
import com.zegocloud.uikit.prebuilt.livestreaming.ZegoUIKitPrebuiltLiveStreamingConfig;
import com.zegocloud.uikit.prebuilt.livestreaming.ZegoUIKitPrebuiltLiveStreamingFragment;
import com.zegocloud.uikit.prebuilt.livestreaming.api.ZegoUIKitPrebuiltLiveStreamingService;
import com.zegocloud.uikit.prebuilt.livestreaming.core.ZegoLiveStreamingRole;
import com.zegocloud.uikit.prebuilt.livestreaming.internal.core.PKListener;
import com.zegocloud.uikit.prebuilt.livestreaming.internal.core.ZegoLiveStreamingPKBattleViewProvider;
import com.zegocloud.uikit.prebuilt.livestreaming.internal.core.ZegoLiveStreamingPKBattleViewProvider2;
import com.zegocloud.uikit.service.defines.ZegoUIKitUser;
import com.zegocloud.uikit.utils.Utils;
import java.util.Collections;
import java.util.List;

public class LiveActivity extends AppCompatActivity {

    private AlertDialog startPKDialog;

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

        customPKView(config, isHost);

        ZegoUIKitPrebuiltLiveStreamingFragment fragment = ZegoUIKitPrebuiltLiveStreamingFragment.newInstance(appID,
            appSign, userID, userName, liveID, config);
        getSupportFragmentManager().beginTransaction().replace(R.id.fragment_container, fragment).commitNow();

        addPKButton(fragment);

        addPKDialog();
    }

    @Override
    protected void onStart() {
        super.onStart();
        ZegoUIKitPrebuiltLiveStreamingService.common.unMuteAllAudioVideo();
    }

    @Override
    protected void onStop() {
        super.onStop();
        ZegoUIKitPrebuiltLiveStreamingService.common.muteAllAudioVideo();
    }

    public void addPKButton(ZegoUIKitPrebuiltLiveStreamingFragment fragment) {
        PKButton pkButton = new PKButton(this);
        int size = Utils.dp2px(36f, getResources().getDisplayMetrics());
        int marginTop = Utils.dp2px(10f, getResources().getDisplayMetrics());
        int marginBottom = Utils.dp2px(16f, getResources().getDisplayMetrics());
        int marginEnd = Utils.dp2px(8, getResources().getDisplayMetrics());
        LayoutParams layoutParams = new LayoutParams(ViewGroup.LayoutParams.WRAP_CONTENT, size);
        layoutParams.topMargin = marginTop;
        layoutParams.bottomMargin = marginBottom;
        layoutParams.rightMargin = marginEnd;
        pkButton.setLayoutParams(layoutParams);
        fragment.addButtonToBottomMenuBar(Collections.singletonList(pkButton), ZegoLiveStreamingRole.HOST);
    }

    private void addPKDialog() {
        ZegoUIKitPrebuiltLiveStreamingService.pk.events.addPKListener(new PKListener() {
            @Override
            public void onIncomingPKBattleRequestReceived(String requestID, ZegoUIKitUser anotherHostUser,
                String anotherHostLiveID, String customData) {
                if (startPKDialog != null && startPKDialog.isShowing()) {
                    return;
                }
                AlertDialog.Builder startPKBuilder = new AlertDialog.Builder(LiveActivity.this);
                startPKBuilder.setTitle(getString(R.string.livestreaming_invite_pk_title, anotherHostUser.userName));
                startPKBuilder.setPositiveButton(com.zegocloud.uikit.prebuilt.livestreaming.R.string.livestreaming_ok,
                    new OnClickListener() {
                        @Override
                        public void onClick(DialogInterface dialog, int which) {
                            dialog.dismiss();
                            ZegoUIKitPrebuiltLiveStreamingService.pk
                                .acceptIncomingPKBattleRequest(requestID, anotherHostLiveID, anotherHostUser);
                        }
                    });
                startPKBuilder.setNegativeButton(
                    com.zegocloud.uikit.prebuilt.livestreaming.R.string.livestreaming_disagree, new OnClickListener() {
                        @Override
                        public void onClick(DialogInterface dialog, int which) {
                            dialog.dismiss();
                            ZegoUIKitPrebuiltLiveStreamingService.pk.rejectPKBattleStartRequest(requestID);
                        }
                    });
                startPKDialog = startPKBuilder.create();
                startPKDialog.setCanceledOnTouchOutside(false);
                startPKDialog.show();
            }

            @Override
            public void onIncomingPKBattleRequestTimeout(String requestID, ZegoUIKitUser anotherHostUser) {
                if (startPKDialog != null && startPKDialog.isShowing()) {
                    startPKDialog.dismiss();
                }
            }

            @Override
            public void onIncomingPKBattleRequestCanceled(String requestID, ZegoUIKitUser anotherHostUser,
                String customData) {
                if (startPKDialog != null && startPKDialog.isShowing()) {
                    startPKDialog.dismiss();
                }
            }
        });
    }

    private void customPKView(ZegoUIKitPrebuiltLiveStreamingConfig config, boolean isHost) {
        config.pkBattleConfig.pkBattleViewBottomProvider = new ZegoLiveStreamingPKBattleViewProvider() {
            @Override
            public View getView(ViewGroup parent, List<ZegoUIKitUser> uiKitUsers) {
                View view = new View(parent.getContext());
                view.setBackgroundColor(Color.MAGENTA);
                DisplayMetrics displayMetrics = parent.getContext().getResources().getDisplayMetrics();
                view.setLayoutParams(new FrameLayout.LayoutParams(-1, Utils.dp2px(32, displayMetrics)));
                return view;
            }
        };
        config.pkBattleConfig.pkBattleViewTopProvider = new ZegoLiveStreamingPKBattleViewProvider() {
            @Override
            public View getView(ViewGroup parent, List<ZegoUIKitUser> uiKitUsers) {
                View view = new View(parent.getContext());
                view.setBackgroundColor(Color.TRANSPARENT);
                DisplayMetrics displayMetrics = parent.getContext().getResources().getDisplayMetrics();
                view.setLayoutParams(new FrameLayout.LayoutParams(-1, Utils.dp2px(48, displayMetrics)));
                return view;
            }
        };
        //        config.pkBattleConfig.pkBattleViewForegroundProvider = new ZegoLiveStreamingPKBattleViewProvider() {
        //            @Override
        //            public View getView(ViewGroup parent, List<ZegoUIKitUser> uiKitUsers) {
        //                if (isHost) {
        //                    MutePKUserButton mutePKUserButton = new MutePKUserButton(parent.getContext());
        //                    int size = Utils.dp2px(36f, getResources().getDisplayMetrics());
        //                    int marginTop = Utils.dp2px(10f, getResources().getDisplayMetrics());
        //                    int marginBottom = Utils.dp2px(16f, getResources().getDisplayMetrics());
        //                    int marginEnd = Utils.dp2px(8, getResources().getDisplayMetrics());
        //                    FrameLayout.LayoutParams layoutParams = new FrameLayout.LayoutParams(
        //                        FrameLayout.LayoutParams.WRAP_CONTENT, size);
        //                    layoutParams.leftMargin = parent.getWidth() / 2;
        //                    layoutParams.topMargin = marginTop;
        //                    layoutParams.bottomMargin = marginBottom;
        //                    layoutParams.rightMargin = marginEnd;
        //                    mutePKUserButton.setLayoutParams(layoutParams);
        //                    return mutePKUserButton;
        //                } else {
        //                    return null;
        //                }
        //            }
        //        };

        config.pkBattleConfig.hostReconnectingProvider = new ZegoLiveStreamingPKBattleViewProvider2() {
            @Override
            public View getView(ViewGroup parent, ZegoUIKitUser uiKitUsers) {
                TextView textView = new TextView(LiveActivity.this);
                textView.setLayoutParams(new FrameLayout.LayoutParams(-1, -1));
                textView.setBackgroundColor(ContextCompat.getColor(LiveActivity.this,
                    com.zegocloud.uikit.prebuilt.livestreaming.R.color.gray_444));
                textView.setGravity(Gravity.CENTER);
                textView.setTextColor(Color.WHITE);
                textView.setTextSize(TypedValue.COMPLEX_UNIT_SP, 18);
                textView.setText("uiKitUsers:" + uiKitUsers.userName + " disconnected");
                return textView;
            }
        };
    }
}