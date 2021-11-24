import 'dart:convert';

import 'package:app_chat/home/state_home.dart';
import 'package:app_chat/model/user.dart';
import 'package:app_chat/servies/database.dart';
import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';

class CubitHome extends Cubit<StateHome> {
  CubitHome() : super(const StateHome());

  DatabaseMethod userData = DatabaseMethod();

  Future<List> getListSearch(BuildContext context,
      {required String name}) async {
    emit(state.copyWith(enumHome: EnumHome.initSearch));
    List listSearch = [];
    listSearch = await userData.getUserByUserName(name: name).then((value) {
      value.removeWhere((element) =>
          element.name == UserInheritedWidget.of(context).user.name);
      emit(state.copyWith(enumHome: EnumHome.doneSearch));
      return value;
    }).catchError((e) {
      emit(state.copyWith(enumHome: EnumHome.errSearch));
    });
    return listSearch;
  }
  Future<List> getListHistory(BuildContext context) async {
    List<Map<String,String>> listFriend = [];
    List list = await userData.getIdChatRoomsByEmailUserHome(context);
    await Future.forEach(list, (index) async {
      String a= await userData.getNameFriendInIdChatRoom(context, idChatRoom: index.toString());
      listFriend.add({index.toString() : a});
    });
    Map<String, String> mapString = {
      "abc":"abcs"
    };
    print(mapString.keys);
    return listFriend;
  }

    /*Map mapDemo = {};
    List listDone = [];

    for(var i = 0; i < list.length; i++){
      mapDemo.addAll({list[i]:nameFriend[i]});
    }

    listDone.add(mapDemo);*/

    //return [];

  /* getItem(BuildContext context , {required String idChatRoom}) async {
    String id = await userData.getIdFriendInChatRoom(
        emailUser: UserInheritedWidget.of(context).user.email ?? "",
        idChatRoom: idChatRoom);
    String nameFriend = await userData.getNameById(id: id);
    return nameFriend;
  }*/
}
