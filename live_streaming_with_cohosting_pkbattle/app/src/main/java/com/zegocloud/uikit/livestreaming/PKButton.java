package com.zegocloud.uikit.livestreaming;

import android.content.Context;
import android.graphics.Color;
import android.text.TextUtils;
import android.util.AttributeSet;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.appcompat.app.AlertDialog;
import androidx.appcompat.app.AlertDialog.Builder;
import com.google.android.material.textfield.TextInputLayout;
import com.zegocloud.uikit.components.common.ZTextButton;
import com.zegocloud.uikit.prebuilt.livestreaming.ZegoLiveStreamingManager;
import com.zegocloud.uikit.prebuilt.livestreaming.ZegoLiveStreamingManager.ZegoLiveStreamingListener;
import com.zegocloud.uikit.prebuilt.livestreaming.internal.core.PKService.PKInfo;
import com.zegocloud.uikit.prebuilt.livestreaming.internal.core.PKService.PKRequest;
import com.zegocloud.uikit.prebuilt.livestreaming.internal.core.UserRequestCallback;
import com.zegocloud.uikit.prebuilt.livestreaming.internal.core.ZegoLiveStreamingPKBattleRejectCode;
import com.zegocloud.uikit.service.defines.ZegoUIKitUser;
import com.zegocloud.uikit.utils.Utils;

public class PKButton extends ZTextButton {

    public PKButton(@NonNull Context context) {
        super(context);
    }

    public PKButton(@NonNull Context context, @Nullable AttributeSet attrs) {
        super(context, attrs);
    }

    public PKButton(@NonNull Context context, @Nullable AttributeSet attrs, int defStyleAttr) {
        super(context, attrs, defStyleAttr);
    }

    @Override
    protected void initView() {
        super.initView();
        setText("PK");
        setBackgroundResource(com.zegocloud.uikit.prebuilt.livestreaming.R.drawable.livestreaming_bg_cohost_btn);
        setGravity(Gravity.CENTER);
        setTextColor(Color.parseColor("#cccccc"));
        setMinWidth(Utils.dp2px(36, getResources().getDisplayMetrics()));
        int padding = Utils.dp2px(8, getResources().getDisplayMetrics());
        setPadding(padding, 0, padding, 0);

        ZegoLiveStreamingManager.getInstance().addLiveStreamingListener(new ZegoLiveStreamingListener() {
            @Override
            public void onPKStarted() {
                updateUI();
            }

            @Override
            public void onPKEnded() {
                updateUI();
            }

            @Override
            public void onOutgoingPKBattleRequestTimeout(String requestID, ZegoUIKitUser anotherHost) {
                updateUI();
                ZegoLiveStreamingManager.getInstance()
                    .showTopTips(getContext().getString(R.string.livestreaming_send_pk_no_reply), false);
            }

            @Override
            public void onOutgoingPKBattleRequestRejected(int reason, ZegoUIKitUser anotherHostUser) {
                updateUI();
                if (reason == ZegoLiveStreamingPKBattleRejectCode.HOST_REJECT.ordinal()) {
                    ZegoLiveStreamingManager.getInstance()
                        .showTopTips(getContext().getString(R.string.livestreaming_send_pk_rejected), false);
                } else {
                    ZegoLiveStreamingManager.getInstance()
                        .showTopTips(getContext().getString(R.string.livestreaming_send_pk_busy), false);
                }
            }

            @Override
            public void onOutgoingPKBattleRequestAccepted(String anotherHostLiveID, ZegoUIKitUser anotherHostUser) {
                ZegoLiveStreamingManager.getInstance()
                    .startPKBattleWith(anotherHostLiveID, anotherHostUser.userID, anotherHostUser.userName);
            }
        });
    }

    @Override
    protected void afterClick() {
        super.afterClick();
        PKRequest pkRequest = ZegoLiveStreamingManager.getInstance().getSendPKStartRequest();
        if (pkRequest == null) {
            if (ZegoLiveStreamingManager.getInstance().getPKInfo() == null) {
                Builder builder = new Builder(getContext());
                View layout = LayoutInflater.from(getContext())
                    .inflate(R.layout.livestreaming_dialog_pkinput, null, false);
                TextInputLayout inputLayout = layout.findViewById(R.id.dialog_pk_edittext);
                Button button = layout.findViewById(R.id.dialog_pk_button);
                builder.setView(layout);
                AlertDialog alertDialog = builder.create();
                alertDialog.show();
                button.setOnClickListener(view -> {
                    EditText editText = inputLayout.getEditText();
                    if (!TextUtils.isEmpty(editText.getText())) {
                        ZegoLiveStreamingManager.getInstance()
                            .sendPKBattleRequest(editText.getText().toString(), new UserRequestCallback() {
                                @Override
                                public void onUserRequestSend(int errorCode, String requestID) {
                                    if (errorCode != 0) {
                                        ZegoLiveStreamingManager.getInstance().showTopTips(
                                            getContext().getString(R.string.livestreaming_send_pk_error, errorCode),
                                            false);
                                    }
                                    updateUI();
                                }
                            });
                        alertDialog.dismiss();
                    }
                });
            } else {
                ZegoLiveStreamingManager.getInstance().stopPKBattle();
            }
        } else {
            ZegoLiveStreamingManager.getInstance().cancelPKBattleRequest(new UserRequestCallback() {
                @Override
                public void onUserRequestSend(int errorCode, String requestID) {
                    updateUI();
                }
            });
        }
    }

    public void updateUI() {
        PKInfo pkInfo = ZegoLiveStreamingManager.getInstance().getPKInfo();
        if (pkInfo != null) {
            setText("End PK");
        } else {
            PKRequest sendPKStartRequest = ZegoLiveStreamingManager.getInstance().getSendPKStartRequest();
            if (sendPKStartRequest == null) {
                setText("PK");
            } else {
                setText("Cancel PK");
            }
        }
    }
}
