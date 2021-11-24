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
  Future<List<Map<String, String>>> getListHistory(BuildContext context) async {
    emit(state.copyWith(enumHome: EnumHome.loadingHome));
    List<Map<String,String>> listFriend = [];
    List list = await userData.getIdChatRoomsByEmailUserHome(context);
    await Future.forEach(list, (index) async {
      String a= await userData.getNameFriendInIdChatRoom(context, idChatRoom: index.toString());
      listFriend.add({index.toString() : a});
    });
    emit(state.copyWith(enumHome: EnumHome.doneHome));
    return listFriend;
  }
}
