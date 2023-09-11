package com.zegocloud.uikit.livestreaming;

import android.content.Intent;
import android.os.Build;
import android.os.Bundle;
import android.text.Editable;
import android.text.TextWatcher;
import android.widget.EditText;
import androidx.appcompat.app.AppCompatActivity;
import com.google.android.material.textfield.TextInputLayout;
import java.util.Random;

public class MainActivity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        long appID = ;
        String appSign = ;

        TextInputLayout userIDLayout = findViewById(R.id.live_login_userid);
        TextInputLayout userNameLayout = findViewById(R.id.live_login_name);
        TextInputLayout liveIDLayout = findViewById(R.id.live_id);
        userIDLayout.getEditText().addTextChangedListener(new TextWatcher() {
            @Override
            public void beforeTextChanged(CharSequence s, int start, int count, int after) {

            }

            @Override
            public void onTextChanged(CharSequence s, int start, int before, int count) {

            }

            @Override
            public void afterTextChanged(Editable s) {
                userNameLayout.getEditText().setText(s + "_" + Build.MANUFACTURER.toLowerCase());
            }
        });

        findViewById(R.id.start_live).setOnClickListener(v -> {
            Intent intent = new Intent(MainActivity.this, LiveActivity.class);
            String userID = userIDLayout.getEditText().getText().toString();
            String userName = userNameLayout.getEditText().getText().toString();
            String liveID = liveIDLayout.getEditText().getText().toString();
            intent.putExtra("host", true);
            intent.putExtra("appID", appID);
            intent.putExtra("appSign", appSign);
            intent.putExtra("userID", userID);
            intent.putExtra("userName", userName);
            intent.putExtra("liveID", liveID);
            startActivity(intent);
        });
        findViewById(R.id.watch_live).setOnClickListener(v -> {
            Intent intent = new Intent(MainActivity.this, LiveActivity.class);
            String userID = userIDLayout.getEditText().getText().toString();
            String userName = userNameLayout.getEditText().getText().toString();
            String liveID = liveIDLayout.getEditText().getText().toString();
            intent.putExtra("appID", appID);
            intent.putExtra("appSign", appSign);
            intent.putExtra("userID", userID);
            intent.putExtra("userName", userName);
            intent.putExtra("liveID", liveID);
            startActivity(intent);
        });
    }
}