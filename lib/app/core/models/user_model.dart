import 'dart:convert';

class UserModel {
  String? id;
  String? email;
  String? name;
  String? userId;
  String? userPassword;
  String? userType;
  String? isActive;

  String? address;

  bool? logStatus;
  bool? isAnonymous;

  String? phone;

  String? photoUrl;

  UserModel({
    this.id,
    this.email,
    this.userId,
    this.userPassword,
    this.userType,
    this.isActive,
    this.name,
    this.address,
    this.isAnonymous,

    this.logStatus,
    this.phone,

    this.photoUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'isAnonymous': isAnonymous,
      'userId': userId,
      'userPassword': userPassword,
      'userType': userType,
      'isActive': isActive,
      'name': name,

      'address': address,
      'logStatus': logStatus,
      'phone': phone,

      'photoUrl': photoUrl,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      name: map['name'],
      isAnonymous: map['isAnonymous'],
      email: map['email'],
      userId: map['userId'],
      userPassword: map['userPassword'],
      userType: map['userType'],
      isActive: map['isActive'],

      address: map['address'],

      logStatus: map['logStatus'],
      phone: map['phone'],

      photoUrl: map['photoUrl'],
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'UserModel( id: $id, name:$name, isAnonymous:$isAnonymous, email: $email, userId: $userId, userPassword: $userPassword, userType: $userType, isActive: $isActive,  address: $address,  logStatus: $logStatus, phone: $phone,    photoUrl: $photoUrl)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserModel &&
        other.id == id &&
        other.name == name &&
        other.isAnonymous == isAnonymous &&
        other.email == email &&
        other.userId == userId &&
        other.userPassword == userPassword &&
        other.userType == userType &&
        other.isActive == isActive &&
        other.address == address &&
        other.logStatus == logStatus &&
        other.phone == phone &&
        other.photoUrl == photoUrl;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        email.hashCode ^
        userId.hashCode ^
        userPassword.hashCode ^
        userType.hashCode ^
        isActive.hashCode ^
        address.hashCode ^
        logStatus.hashCode ^
        phone.hashCode ^
        photoUrl.hashCode;
  }
}
