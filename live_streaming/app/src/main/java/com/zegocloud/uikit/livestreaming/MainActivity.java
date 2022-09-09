package com.zegocloud.uikit.livestreaming;

import android.content.Intent;
import android.os.Bundle;
import androidx.appcompat.app.AppCompatActivity;
import com.google.android.material.textfield.TextInputLayout;

public class MainActivity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        TextInputLayout liveName = findViewById(R.id.live_name);
        liveName.getEditText().setText("android_test_live_ID");

        findViewById(R.id.start_live).setOnClickListener(v -> {
            if (liveName.getEditText().getText().length() > 0) {
                Intent intent = new Intent(MainActivity.this, LiveActivity.class);
                intent.putExtra("host", true);
                intent.putExtra("liveID", liveName.getEditText().getText().toString());
                startActivity(intent);
            }
        });
        findViewById(R.id.watch_live).setOnClickListener(v -> {
            if (liveName.getEditText().getText().length() > 0) {
                Intent intent = new Intent(MainActivity.this, LiveActivity.class);
                intent.putExtra("host", false);
                intent.putExtra("liveID", liveName.getEditText().getText().toString());
                startActivity(intent);
            }
        });
    }
}