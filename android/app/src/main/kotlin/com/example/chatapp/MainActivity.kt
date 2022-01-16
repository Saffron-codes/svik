package com.example.chatapp


import android.os.Environment
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.widget.Toast
import io.flutter.plugins.GeneratedPluginRegistrant
import java.io.File

class MainActivity: FlutterActivity() {

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        GeneratedPluginRegistrant.registerWith(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor,"com.javesindia/channels")
            .setMethodCallHandler { call, result ->
                if (call.method == "toast"){
                    val data: String? = call.argument<String>("data")
                    Toast.makeText(this,data,Toast.LENGTH_LONG).show()
                }
            }
    }
}
