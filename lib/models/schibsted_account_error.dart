class SchibstedAccountError {
  String errorType;
  String message;

  SchibstedAccountError({this.errorType, this.message});

  SchibstedAccountError.fromJson(Map<String, dynamic> json) {
    errorType = json['errorType'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['errorType'] = this.errorType;
    data['message'] = this.message;
    return data;
  }

  @override
  String toString() {
    return "errorType $errorType; message $message";
  }
}
