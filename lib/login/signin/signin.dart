import 'package:app_chat/login/signin/cubit_signin.dart';
import 'package:app_chat/login/signin/state_signin.dart';
import 'package:app_chat/model/user.dart';
import 'package:app_chat/servies/database.dart';
import 'package:app_chat/widget/widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final keyFormSignIn = GlobalKey<FormState>();
  final SignInCubit _signInCubit = SignInCubit();

  bool checkHind = true;
  bool checkSignInErr = false;

  final TextEditingController _controllerGmail = TextEditingController();
  final TextEditingController _controllerPass = TextEditingController();

  DatabaseMethod userData = DatabaseMethod();
  UserData userYou = UserData();

  @override
  void initState() {
    _controllerGmail.text = "lethelu@gmail.com";
    _controllerPass.text = "lethelu123";
    super.initState();
  }


  validateForm() {
    if (keyFormSignIn.currentState!.validate()) {
      _signInCubit.signMeIn(context, email: _controllerGmail.text,pass: _controllerPass.text);
    }
  }

  @override
  void dispose(){
    _controllerGmail.dispose();
    _controllerPass.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.cyan[200],
      body: SafeArea(
        child: BlocBuilder<SignInCubit, SignInState>(
        buildWhen: (pre, cur) =>pre.enumStateSignIn !=cur.enumStateSignIn,
        bloc: _signInCubit,
        builder: (context, state) {
          if(state.enumStateSignIn == EnumStateSignIn.loadingSignIn){
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if(state.enumStateSignIn == EnumStateSignIn.errSignIn){
            checkSignInErr = true;
          } else if(state.enumStateSignIn == EnumStateSignIn.signInAgain){
            checkSignInErr = false;
          }
          else if(state.enumStateSignIn == EnumStateSignIn.passHind){
            checkHind = true;
          }
          else if(state.enumStateSignIn == EnumStateSignIn.passShow){
            checkHind = false;
          }
          return Stack(
            children: [
              SingleChildScrollView(
                physics: const NeverScrollableScrollPhysics(),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      logoFlutter(),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius:
                          const BorderRadius.all(Radius.circular(30)),
                          color: Colors.cyan[500],
                        ),
                        width: MediaQuery.of(context).size.width - 30,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Form(
                                key: keyFormSignIn,
                                child: Column(
                                  children: [
                                    textFieldGmail("Gmail", _controllerGmail),
                                    passWord(
                                        controller: _controllerPass,
                                        checkHind: checkHind,
                                        onPressed: () {
                                          _signInCubit.setStatePass(!checkHind);
                                        }),
                                  ],
                                ))
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      buttonHome(
                          context: context,
                          label: "SignIn",
                          onPressed: () {
                            validateForm();
                          }),
                      const SizedBox(
                        height: 30,
                      ),
                      buttonHome(
                          context: context,
                          label: "Google",
                          onPressed: () {
                          },
                          colorButton: Colors.white,
                          colorText: Colors.black),
                      const SizedBox(
                        height: 30,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Bạn chưa có tài khoảng?"),
                          const SizedBox(
                            width: 10,
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.pushNamed(context, "signup");
                            },
                            child: const Text(
                              "Đăng Kí ngay!",
                              style: TextStyle(color: Colors.white),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
              Visibility(
                  visible: checkSignInErr,
                  child: Center(
                    child: Container(
                        decoration: BoxDecoration(
                            color: Colors.teal[500],
                            borderRadius:
                            const BorderRadius.all(Radius.circular(20))),
                        height: 100,
                        width: 250,
                        child: Stack(
                          children: [
                            const Center(
                                child: Text(
                                  "Đăng nhập không thành công",
                                  style: TextStyle(color: Colors.white),
                                )),
                            Positioned(
                              top: 10,
                              right: 10,
                              child: GestureDetector(
                                onTap: () {
                                    _signInCubit.signMeInAgain();
                                },
                                child: const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: Icon(
                                    Icons.clear,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            )
                          ],
                        )),
                  )),
            ],
          );
        },
    )));
  }
}

