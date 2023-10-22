import 'package:contact_list/models/model.dart';

class ContactModel implements Model {
  String objId = "";
  String name = "";
  String? photoUrl;
  int phoneNumber = 0;
  String? facebookUser;
  String? instagramUser;

  @override
  void fromJson(Map<String, dynamic> json) {
    objId = json['objectId'];
    name = json['name'];
    photoUrl = json['photoUrl'] ?? "";
    phoneNumber = json['phoneNumber'];
    facebookUser = json['facebookUser'] ?? "";
    instagramUser = json['instagramUser'] ?? "";
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'objId': objId,
      'name': name,
      'photoUrl': photoUrl,
      'phoneNumber': phoneNumber,
      'instagramUser': instagramUser,
      'facebookUser': facebookUser
    };
  }
}
