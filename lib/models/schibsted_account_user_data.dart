class SchibstedAccountUserData {
  String displayName;
  String email;
  String id;
  String photo;

  SchibstedAccountUserData({this.displayName, this.email, this.id, this.photo});

  SchibstedAccountUserData.fromJson(Map<String, dynamic> json) {
    displayName = json['displayName'];
    email = json['email'];
    id = json['id'];
    photo = json['photo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['displayName'] = this.displayName;
    data['email'] = this.email;
    data['id'] = this.id;
    data['photo'] = this.photo;
    return data;
  }

  @override
  String toString() {
    return "displayName $displayName; id $id; email $email; photo $photo";
  }
}