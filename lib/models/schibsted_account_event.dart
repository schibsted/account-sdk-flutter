import 'schibsted_account_error.dart';
import 'schibsted_account_state.dart';
import 'schibsted_account_user_data.dart';

class SchibstedAccountEvent {
  SchibstedAccountUserData schibstedAccountUserData;
  SchibstedAccountState schibstedAccountState;
  SchibstedAccountError schibstedAccountError;

  SchibstedAccountEvent(this.schibstedAccountState) {
    schibstedAccountError = null;
    schibstedAccountUserData = null;
  }

  SchibstedAccountEvent.fromJson(Map<String, dynamic> json) {
    schibstedAccountUserData = json['schibstedAccountUserData'] != null ? new SchibstedAccountUserData.fromJson(json['schibstedAccountUserData']) : null;
    schibstedAccountState = getLoginStateFromString(json['schibstedAccountLoginState']);
    schibstedAccountError = json['schibstedAccountError'] != null ? new SchibstedAccountError.fromJson(json['schibstedAccountError']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.schibstedAccountUserData != null) {
      data['schibstedAccountUserData'] = this.schibstedAccountUserData.toJson();
    }
    data['schibstedAccountLoginState'] = this.schibstedAccountState;
    data['schibstedAccountError'] = this.schibstedAccountError;
    return data;
  }
}

