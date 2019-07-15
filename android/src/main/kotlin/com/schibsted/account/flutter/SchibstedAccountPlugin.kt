package com.schibsted.account.flutter

import android.app.Activity
import android.arch.lifecycle.Lifecycle
import android.arch.lifecycle.LifecycleObserver
import android.arch.lifecycle.OnLifecycleEvent
import android.arch.lifecycle.ProcessLifecycleOwner
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.support.v4.app.ActivityCompat.startActivityForResult
import android.support.v4.content.LocalBroadcastManager
import com.google.gson.Gson
import com.schibsted.account.AccountService
import com.schibsted.account.Events
import com.schibsted.account.engine.integration.ResultCallback
import com.schibsted.account.flutter.models.SchibstedAccountEvent
import com.schibsted.account.flutter.models.toSchibstedAccountError
import com.schibsted.account.flutter.models.toUserData
import com.schibsted.account.model.error.ClientError
import com.schibsted.account.network.response.ProfileData
import com.schibsted.account.session.User
import com.schibsted.account.smartlock.SmartlockReceiver
import com.schibsted.account.ui.AccountUi
import com.schibsted.account.ui.login.BaseLoginActivity
import com.schibsted.account.ui.smartlock.SmartlockMode
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.JSONMethodCodec
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar

class SchibstedAccountPlugin(private val registrar: Registrar) : MethodCallHandler, LifecycleObserver {

    private var loginEventsSink: EventChannel.EventSink? = null

    private lateinit var accountSdkReceiver: AccountSdkReceiver
    private lateinit var smartlockReceiver: SmartlockReceiver
    private lateinit var accountService: AccountService
    private var user: User? = null
    private val gson = Gson()

    companion object {
        const val PASSWORD_REQUEST_CODE = 234

        @JvmStatic
        fun registerWith(registrar: Registrar) {
            val channel = MethodChannel(registrar.messenger(), "schibsted_account/callbacks")
            channel.setMethodCallHandler(SchibstedAccountPlugin(registrar))
        }
    }

    init {
        ProcessLifecycleOwner.get().lifecycle.addObserver(this)

        val eventChannel = EventChannel(this.registrar.messenger(), "schibsted_account/events", JSONMethodCodec.INSTANCE)
        eventChannel.setStreamHandler(object : EventChannel.StreamHandler {
            override fun onListen(arguments: Any?, eventSink: EventChannel.EventSink?) {
                this@SchibstedAccountPlugin.loginEventsSink = eventSink
            }

            override fun onCancel(arguments: Any?) {
                loginEventsSink = null
            }
        })
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        when {
            call.method == "login" -> {
                val intent = AccountUi.getCallingIntent(registrar.context(), AccountUi.FlowType.PASSWORD,
                        AccountUi.Params.Builder()
                                .smartLockMode(SmartlockMode.ENABLED)
                                .build())
                startActivityForResult(registrar.activity(), intent, PASSWORD_REQUEST_CODE, null)
            }
            call.method == "logout" -> {
                user?.logout(null)
            }
            else -> result.notImplemented()
        }

        registrar.addActivityResultListener { requestCode, resultCode, data ->
            if (requestCode == PASSWORD_REQUEST_CODE) {
                when (resultCode) {
                    Activity.RESULT_OK -> {
                        // when the flow was performed without any issue, you can get the newly created user.
                        user = data!!.getParcelableExtra(BaseLoginActivity.EXTRA_USER)
                        onUserLoggedIn()
                    }
                    AccountUi.SMARTLOCK_FAILED -> {
                        // restart the flow, telling the SDK that SmartLock failed
                        val intent = AccountUi.getCallingIntent(registrar.context(), AccountUi.FlowType.PASSWORD,
                                AccountUi.Params.Builder()
                                        .smartLockMode(SmartlockMode.FAILED)
                                        .build())
                        startActivityForResult(registrar.activity(), intent, PASSWORD_REQUEST_CODE, null)
                    }
                    AccountUi.RESULT_ERROR -> {
                        val error = data!!.getParcelableExtra<ClientError>(AccountUi.EXTRA_ERROR)
                        sendEvent(SchibstedAccountEvent.Error(error.toSchibstedAccountError()))
                    }
                    Activity.RESULT_CANCELED -> {
                        sendEvent(SchibstedAccountEvent.Canceled())
                    }
                    else -> {
                        sendEvent(SchibstedAccountEvent.Unknown())
                    }
                }
                true
            } else {
                false
            }
        }
    }

    private fun sendEvent(event: SchibstedAccountEvent) {
        loginEventsSink?.success(gson.toJson(event))
    }

    private fun onUserLoggedIn() {
        sendEvent(SchibstedAccountEvent.Fetching())
        user!!.profile.get(object : ResultCallback<ProfileData> {
            override fun onSuccess(profileData: ProfileData) {
                sendEvent(SchibstedAccountEvent.LoggedIn(profileData.toUserData()))
            }

            override fun onError(error: ClientError) {
                sendEvent(SchibstedAccountEvent.Error(error.toSchibstedAccountError()))
            }
        })
    }

    @OnLifecycleEvent(Lifecycle.Event.ON_CREATE)
    fun onCreate() {
        accountService = AccountService(registrar.context())
        smartlockReceiver = SmartlockReceiver(registrar.activity())
        accountSdkReceiver = AccountSdkReceiver()
        User.resumeLastSession(registrar.context(), object : ResultCallback<User> {
            override fun onSuccess(result: User) {
                toSchibstedAccountError        user = result
                onUserLoggedIn()
            }

            override fun onError(error: ClientError) {
                user = null
                sendEvent(SchibstedAccountEvent.Error(error.()))
            }
        })
    }

    @OnLifecycleEvent(Lifecycle.Event.ON_START)
    fun onStart() {
        accountService.bind()
        LocalBroadcastManager.getInstance(registrar.context()).registerReceiver(smartlockReceiver, IntentFilter(Events.ACTION_USER_LOGOUT));
        LocalBroadcastManager.getInstance(registrar.context()).registerReceiver(accountSdkReceiver, IntentFilter(Events.ACTION_USER_LOGOUT))
    }

    @OnLifecycleEvent(Lifecycle.Event.ON_STOP)
    fun onStop() {
        LocalBroadcastManager.getInstance(registrar.context()).unregisterReceiver(smartlockReceiver)
        LocalBroadcastManager.getInstance(registrar.context()).unregisterReceiver(accountSdkReceiver)
        accountService.unbind()
    }

    private inner class AccountSdkReceiver : BroadcastReceiver() {
        override fun onReceive(context: Context, intent: Intent) {
            val action = intent.action
            if (action != null && action == Events.ACTION_USER_LOGOUT) {
                user = null
                sendEvent(SchibstedAccountEvent.LoggedOut())
            }
        }
    }
}
