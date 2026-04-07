package com.BaseFlutter.BaseFlutter

import io.flutter.embedding.android.FlutterFragmentActivity
import android.content.Intent
import android.os.Build
import android.provider.Settings
import androidx.annotation.NonNull
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import androidx.core.net.toUri
import android.content.Context
import android.telephony.euicc.EuiccManager

class MainActivity : FlutterFragmentActivity() {
    private val CHANNEL = "com.luxe.esim/flutter_to_native"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "openSimProfilesSettings" -> {
                    openSimProfilesSettings(result)
                }

                "openEsimSetup" -> {
                    openEsimSetup(result, call);
                }

                else -> {
                    result.notImplemented()
                }
            }
        }
    }

    /**
     * Opens the SIM profiles settings screen on the device.
     *
     * @param result MethodChannel.Result used to send success or error back to Flutter.
     *
     * For Android 9.0 (API 28) and above, opens the dedicated "Manage all SIM profiles" settings.
     * For older versions, falls back to general network operator settings.
     */
    private fun openSimProfilesSettings(result: MethodChannel.Result) {
        try {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) { // Android 9.0 (API 28) or higher
                val intent = Intent(Settings.ACTION_MANAGE_ALL_SIM_PROFILES_SETTINGS)
                startActivity(intent)
                result.success(true)
            } else {
                // For older versions, we can try to open the general network settings
                val intent = Intent(Settings.ACTION_NETWORK_OPERATOR_SETTINGS)
                startActivity(intent)
                result.success(true)
            }
        } catch (e: Exception) {
            result.error("UNAVAILABLE", "Could not open SIM profiles settings: ${e.message}", null)
        }
    }

    /**
     * Initiates the eSIM setup flow using card data provided from Flutter.
     *
     * @param result MethodChannel.Result to report success or failure back to Flutter.
     * @param call MethodCall containing arguments sent from Flutter; expects "cardData".
     *
     * If cardData is valid, it delegates to [installNormalEsim].
     * Otherwise, reports an error to Flutter.
     *
     * Expected cardData format:
     * ```
     * LPA:1$smdpAddress$activationCode
     * Example:
     * LPA:1$smdp-plus-0.eu.cd.rsp.kigen.com$WTHY4-S9IDP-BZZ7B-3W19C
     * ```
     * - `smdpAddress` → The SMDP+ server address provided by the carrier.
     * - `activationCode` → The unique eSIM activation code.
     */
    private fun openEsimSetup(result: MethodChannel.Result, call: MethodCall) {
        val euIccManager = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) {
            getSystemService(Context.EUICC_SERVICE) as EuiccManager
        } else null

        val isESIMSupported = euIccManager?.isEnabled == true

        if (!isESIMSupported) {
            result.success(false)
            return
        }

        val cardData = call.argument<String>("cardData")
        if (!cardData.isNullOrEmpty()) {
            installESIM(cardData = cardData, result = result)
        } else {
            result.error("INVALID_ARGUMENT", "Card data is required", null)
        }
    }

    /**
     * Installs eSIM using the provided card data.
     *
     * @param cardData Encoded eSIM card information used for provisioning.
     * @param result MethodChannel.Result to report success or failure back to Flutter.
     *
     * For Android 10+ (API 29+), opens the eSIM provisioning URL in a new task.
     * For older versions, installation is not supported and returns false.
     *
     * Expected cardData format:
     * ```
     * LPA:1$smdpAddress$activationCode
     * Example:
     * LPA:1$smdp-plus-0.eu.cd.rsp.kigen.com$WTHY4-S9IDP-BZZ7B-3W19C
     * ```
     */
    private fun installESIM(cardData: String, result: MethodChannel.Result) {
        try {
            // check if the device is running android 10 or higher
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
                val intent = Intent(Intent.ACTION_VIEW).apply {
                    data =
                        "https://esimsetup.android.com/esim_qrcode_provisioning?carddata=${cardData}".toUri()
                    flags = Intent.FLAG_ACTIVITY_NEW_TASK
                }
                startActivity(intent)
                result.success(true)
            } else {
                result.success(false)
            }
        } catch (e: Exception) {
            result.error("UNAVAILABLE", "Could not install eSim: ${e.message}", null)
        }
    }
}
