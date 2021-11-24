import 'package:flutter/cupertino.dart';

class UserData {
  String? userID;
  String? name;
  String? email;

  UserData({this.userID, this.name, this.email});

  UserData.fromJson(Map<String, dynamic> json) {
    userID = json['userID'];
    name = json['name'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['userID'] = userID;
    data['name'] = name;
    data['email'] = email;
    return data;
  }
}
class UserChat {
  String? userEmail;
  String? fiendEmail;

  UserChat({this.userEmail, this.fiendEmail});

  UserChat.fromJson(Map<String, dynamic> json) {
    userEmail = json['emailUser'];
    fiendEmail = json['emailFriend'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['emailUser'] = userEmail;
    data['emailFriend'] = fiendEmail;
    return data;
  }
}


class ChatRoom {
  Email? email;

  ChatRoom({this.email});

  ChatRoom.fromJson(Map<String, dynamic> json) {
    email = json['email'] != null ? Email.fromJson(json['email']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (email != null) {
      data['email'] = email!.toJson();
    }
    return data;
  }
}

class Email {
  String? id01;
  String? id02;

  Email({this.id01, this.id02});

  Email.fromJson(Map<String, dynamic> json) {
    id01 = json['id01'];
    id02 = json['id02'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id01'] = id01;
    data['id02'] = id02;
    return data;
  }
}

class UserInheritedWidget extends InheritedWidget {
  final UserData user;

  const UserInheritedWidget({Key? key, required Widget child, required this.user}) : super(key: key, child: child);

  static UserInheritedWidget of(BuildContext context) {
    final UserInheritedWidget? result = context.dependOnInheritedWidgetOfExactType<UserInheritedWidget>();
    assert(result != null, 'No User found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(UserInheritedWidget oldWidget) {
    return user != oldWidget.user;
  }
}
