package com.example.libras

import ai.onnxruntime.OnnxTensor
import ai.onnxruntime.OrtEnvironment
import ai.onnxruntime.OrtSession
import android.graphics.BitmapFactory
import androidx.annotation.NonNull

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

import com.google.mediapipe.framework.image.BitmapImageBuilder
import com.google.mediapipe.tasks.core.BaseOptions
import com.google.mediapipe.tasks.core.Delegate
import com.google.mediapipe.tasks.vision.core.RunningMode
import com.google.mediapipe.tasks.vision.handlandmarker.HandLandmarker

import java.nio.FloatBuffer

class MainActivity: FlutterActivity() {
    private val CHANNEL = "teste"
    private var handLandmarker: HandLandmarker? = null

    private fun createORTSession( ortEnvironment: OrtEnvironment) : OrtSession {
        val modelBytes = resources.openRawResource( R.raw.alphabet_model).readBytes()
        return ortEnvironment.createSession( modelBytes )
    }

    private fun setup()
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

        handLandmarker = HandLandmarker.createFromOptions(context, options)
    }

    private fun runPrediction( input : List<Float> , ortSession: OrtSession , ortEnvironment: OrtEnvironment ) : Long {
        // Get the name of the input node
        val inputName = ortSession.inputNames?.iterator()?.next()
        // Make a FloatBuffer of the inputs
        val floatBufferInputs = FloatBuffer.wrap( input.toFloatArray())
        // Create input tensor with floatBufferInputs of shape ( 1 , 63 )
        val inputTensor = OnnxTensor.createTensor( ortEnvironment , floatBufferInputs , longArrayOf( 1, 63) )
        // Run the model
        val results = ortSession.run( mapOf( inputName to inputTensor ) )
        // Fetch and return the results

        val x = results[0].value as LongArray
        return x[0]
    }


    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
                call, result ->
            if(call.method == "model")
            {
                setup()
                val image = BitmapFactory.decodeFile(call.arguments as String)
                val mpImage = BitmapImageBuilder(image).build()
                val r = handLandmarker?.detect(mpImage)
                val worldLand = r?.worldLandmarks()

                val list: MutableList<Float> = ArrayList()

                for(landmark in worldLand?.get(0)!!)
                    list.addAll(arrayOf(landmark.x(), landmark.y(), landmark.z()))

                val ortEnvironment = OrtEnvironment.getEnvironment()
                val ortSession = createORTSession( ortEnvironment )
                val pred = runPrediction(list, ortSession , ortEnvironment )

                result.success(pred)
            }
            else
                result.notImplemented()
        }
    }
}

