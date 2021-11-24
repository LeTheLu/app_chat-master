import 'package:app_chat/login/signup/signup_state.dart';
import 'package:app_chat/model/user.dart';
import 'package:app_chat/servies/auth.dart';
import 'package:app_chat/servies/database.dart';
import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';

class CubitSignUp extends Cubit<SignUpState>{
  CubitSignUp() : super(const SignUpState());
  AuthMethod authMethods  = AuthMethod();
  DatabaseMethod databaseMethod = DatabaseMethod();

  Future<void> signMeUp(BuildContext context , {required String email, required String pass,required String name}) async {
    emit(state.copyWith(enumSignUp: EnumSignUp.loadingSignUp));
      authMethods.signUpWithEmailAndPassWord(email: email, password: pass).then((e) async {
        Map<String, String> userMap = {
          "name" : name,
          "email" : email
        };
        databaseMethod.uploadUserInfo(userMap);
        UserInheritedWidget.of(context).user.email = email;
        UserInheritedWidget.of(context).user.name = await databaseMethod.getNameByUserGmail(email: UserInheritedWidget.of(context).user.email ?? "");
        emit(state.copyWith(enumSignUp: EnumSignUp.doneSignUp));
      }).catchError((e){
        emit(state.copyWith(enumSignUp: EnumSignUp.errSignUp));
      });
    }
    Future<void> signMeUpAgain() async {
    emit(state.copyWith(enumSignUp: EnumSignUp.signUpAgain));
    }
  }