package com.example.libras

import android.graphics.BitmapFactory
import androidx.annotation.NonNull

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

import com.google.mediapipe.framework.image.BitmapImageBuilder
import com.google.mediapipe.framework.image.MPImage
import com.google.mediapipe.tasks.core.BaseOptions
import com.google.mediapipe.tasks.core.Delegate
import com.google.mediapipe.tasks.vision.core.RunningMode
import com.google.mediapipe.tasks.vision.handlandmarker.HandLandmarker
import com.google.mediapipe.tasks.vision.handlandmarker.HandLandmarkerResult

class MainActivity: FlutterActivity() {
    private val CHANNEL = "teste"
    private var handLandmarker: HandLandmarker? = null

    fun setup()
    {
        val baseOptionsBuilder = BaseOptions.builder().setModelAssetPath("hand_landmarker.task")
        val baseOptions = baseOptionsBuilder.build()

        val optionsBuilder =
            HandLandmarker.HandLandmarkerOptions.builder()
                .setBaseOptions(baseOptions)
                .setMinHandDetectionConfidence(0.5F)
                .setMinTrackingConfidence(0.5F)
                .setMinHandPresenceConfidence(0.5F)
                .setNumHands(1)
                .setRunningMode(RunningMode.IMAGE)

        val options = optionsBuilder.build()

        handLandmarker = HandLandmarker.createFromOptions(context, options);
    }


    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
                call, result ->
            if(call.method == "model")
            {
                setup();
                val image = BitmapFactory.decodeFile(call.arguments as String)
                val mpImage = BitmapImageBuilder(image).build()
                val r = handLandmarker?.detect(mpImage)
                val worldLand = r?.worldLandmarks();

                val list: MutableList<Float> = ArrayList()

                for(landmark in worldLand?.get(0)!!)
                    list.addAll(arrayOf(landmark.x(), landmark.y(), landmark.z()))

                result.success(list)
            }
            else
                result.notImplemented();
        }
    }
}

