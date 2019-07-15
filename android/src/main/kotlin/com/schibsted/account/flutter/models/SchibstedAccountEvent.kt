package com.schibsted.account.flutter.models

import com.schibsted.account.model.error.ClientError
import com.schibsted.account.network.response.ProfileData

sealed class SchibstedAccountEvent(val schibstedAccountLoginState: String) {

    class LoggedOut : SchibstedAccountEvent("logged_out")
    data class LoggedIn(val schibstedAccountUserData: SchibstedAccountUserData) : SchibstedAccountEvent("logged_in")
    class Unknown : SchibstedAccountEvent("unknown")
    class Canceled : SchibstedAccountEvent("canceled")
    class Fetching : SchibstedAccountEvent("fetching")
    data class Error(val schibstedAccountError: SchibstedAccountError) : SchibstedAccountEvent("error")
}

data class SchibstedAccountUserData(
        val displayName: String,
        val photo: String,
        val email: String,
        val id: String
)

data class SchibstedAccountError(
        val errorType: String,
        val message: String
)

fun ProfileData.toUserData(): SchibstedAccountUserData {
    return SchibstedAccountUserData(this.displayName ?: "", this.photo ?: "", this.email ?: "", this.id ?: "")
}

fun ClientError.toSchibstedAccountError(): SchibstedAccountError { 
    return SchibstedAccountError(this.errorType.toString().toLowerCase(), this.message)
}