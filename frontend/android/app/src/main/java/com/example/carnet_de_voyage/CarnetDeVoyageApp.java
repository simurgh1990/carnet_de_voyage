package com.example.carnet_de_voyage;

import io.flutter.app.FlutterApplication;
import android.content.Context;
import androidx.multidex.MultiDex;
import com.google.firebase.FirebaseApp;

public class CarnetDeVoyageApp extends FlutterApplication {
    @Override
    public void onCreate() {
        super.onCreate();
        // Initialisation de Firebase
        FirebaseApp.initializeApp(this);
    }

    @Override
    protected void attachBaseContext(Context base) {
        super.attachBaseContext(base);
        MultiDex.install(this);
    }
}