

import 'package:app_chat/chat/chat.dart';
import 'package:app_chat/home/home.dart';
import 'package:app_chat/login/signin/signin.dart';
import 'package:app_chat/login/signup/signup.dart';
import 'package:flutter/material.dart';

class RouteName{
  static const String login = "login";
  static const String chatRoom = "chatRoom";
  static const String chat = "chat";
  static const String signUp = "signup";
}

class Routes{
  static Route<dynamic>? generate(RouteSettings settings){

    switch (settings.name){
      case "login": {
        return MaterialPageRoute(builder: (_) => const Login());
      }
      case "chatRoom":
        {
          return MaterialPageRoute(builder: (_) =>const Home());
        }
      case "chat":
        {
          String nameFriend = settings.arguments as String;
          String idChatRoom = settings.arguments as String;
          return MaterialPageRoute(builder: (_) => Chat(nameFriend: nameFriend,idChatRoom: idChatRoom,));
        }
      case "signup":
        {
          return MaterialPageRoute(builder: (_) =>const SignUp());
        }
    }
  }
}