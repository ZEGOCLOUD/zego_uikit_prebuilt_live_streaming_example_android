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

        findViewById(R.id.start_live).setOnClickListener(v -> {
            Intent intent = new Intent(MainActivity.this, LiveActivity.class);
            intent.putExtra("host", true);
            startActivity(intent);
        });
        findViewById(R.id.watch_live).setOnClickListener(v -> {
            Intent intent = new Intent(MainActivity.this, LiveActivity.class);
            intent.putExtra("host", false);
            startActivity(intent);
        });
    }
}