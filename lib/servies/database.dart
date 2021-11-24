import 'package:app_chat/model/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class DatabaseMethod {
  Future<String> newChatRoom(
      {required String emailUser, required String emailFriend}) async {
    String idChatRoom = "";
    String idUser = await getIdByGmail(email: emailUser);
    String idFriend = await getIdByGmail(email: emailFriend);

    Map<String, Map<String, bool>> map = {
      "email": {idUser: true, idFriend: true}
    };
    FirebaseFirestore.instance.collection("chat").doc().set(map);
    idChatRoom = await getIdChatRoomBy2Email(
        emailFriend: emailFriend, emailUser: emailUser);
    return idChatRoom;
  }

  Future<String> getIdByGmail({required String email}) async {
    String id = "";
    await FirebaseFirestore.instance
        .collection("users")
        .where("email", isEqualTo: email)
        .get()
        .then((value) => id = value.docs.first.id)
        .catchError((e) {});
    return id;
  }

  Future<String> getEmailById({required String id}) async {
    String email = "";
    await FirebaseFirestore.instance
        .collection("users")
        .doc(id)
        .get()
        .then((value) => email = value["email"]);
    return email;
  }

  Future<String> getNameById({required String id}) async {
    String name = "";
    await FirebaseFirestore.instance
        .collection("users")
        .doc(id)
        .get()
        .then((value) => name = value["name"]);
    return name;
  }

  Future<List<UserData>> getUserByUserName({required String name}) async {
    List<UserData> listUser = [];
    await FirebaseFirestore.instance
        .collection("users")
        .where(
          "name",
          isLessThanOrEqualTo: name,
        )
        .get()
        .then((value) {
      List<UserData> data =
          value.docs.map((e) => UserData.fromJson(e.data())).toList();
      listUser = data;
    });
    return listUser;
  }

  Future<String> getIdChatRoomBy2Email(
      {required String emailUser, required String emailFriend}) async {
    String id = "";
    try {
      String idUser = await getIdByGmail(email: emailUser);
      String idFriend = await getIdByGmail(email: emailFriend);
      await FirebaseFirestore.instance
          .collection("chat")
          .where("email.$idUser", isEqualTo: true)
          .where("email.$idFriend", isEqualTo: true)
          .get()
          .then((value) => id = value.docs.first.id);
    } catch (e) {
      id = await newChatRoom(emailUser: emailUser, emailFriend: emailFriend);
    }
    return id;
  }

  Future<String?> getNameByUserGmail({required String email}) async {
    UserData user = UserData();
    await FirebaseFirestore.instance
        .collection("users")
        .where("email", isEqualTo: email)
        .get()
        .then((value) {
      user = value.docs.map((e) => UserData.fromJson(e.data())).toList().first;
    });
    return user.name;
  }

  uploadUserInfo(userMap) {
    FirebaseFirestore.instance.collection("users").add(userMap);
  }

  sendMessage(
      {required String message,
      required String user,
      required String idRoom}) async {
    Map<String, String> data = {
      "message": message,
      "user": user,
      "time": DateTime.now().millisecondsSinceEpoch.toString()
    };
    await FirebaseFirestore.instance
        .collection("chat")
        .doc(idRoom)
        .collection("chat")
        .add(data)
        .then((value) => print("done"));
  }

  Future<List> listChatWithUser({required String emailUser}) async {
    List list = [];
    try {
      String idUser = await getIdByGmail(email: emailUser);
      FirebaseFirestore.instance
          .collection("chat")
          .where("email.$idUser", isEqualTo: true)
          .get()
          .then((value) {
        for (var element in value.docs) {
          list.add(element.id);
        }
        list = value.docs.map((e) => ChatRoom.fromJson(e.data())).toList();
      });
    } catch (e) {
      throw Exception(e);
    }
    return list;
  }

  Future<String> getNameFriendInIdChatRoom(BuildContext context,
      {required String idChatRoom}) async {
    String idFriend = "";
    try {
      String idUsers = await getIdByGmail(
          email: UserInheritedWidget.of(context).user.email ?? "");
      var a = await FirebaseFirestore.instance
          .collection("chat")
          .doc(idChatRoom)
          .get();
      Map<String, dynamic> map =
          Map<String, dynamic>.from(a.data()!.values.first);
      map.removeWhere((key, value) => key == idUsers);
      idFriend = map.keys.first;
    } catch (e) {
      throw Exception();
    }
    String nameFriend = await getNameById(id: idFriend);
    return nameFriend;
  }

  Future<List> getIdChatRoomsByEmailUserHome(BuildContext context) async {
    List listId = [];
    try {
      String idUser = await getIdByGmail(
          email: UserInheritedWidget.of(context).user.email ?? "");
      await FirebaseFirestore.instance
          .collection("chat")
          .where("email.$idUser", isEqualTo: true)
          .get()
          .then((value) => value.docs.forEach((element) {
                listId.add(element.id);
              }));
    } catch (e) {
      throw Exception();
    }
    return listId;
  }
}
