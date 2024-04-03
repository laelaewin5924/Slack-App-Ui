class Muser {
  int? id;
  String? name;
  String? email;
  String? password_digest;
  String? profile_image;
  String? remember_digest;
  bool? active_status;
  bool? admin;
  bool? member_status;
  Muser({this.id, this.name});
  Muser.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    password_digest = json['password_digest'];
    active_status = json['active_status'];
    admin = json['admin'];
    member_status = json['member_status'];
    profile_image = json['profile_image'];
    remember_digest = json['remember_digest'];
  }
}