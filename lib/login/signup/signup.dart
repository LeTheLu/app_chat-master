import 'package:app_chat/login/signup/signup_cubit.dart';
import 'package:app_chat/login/signup/signup_state.dart';
import 'package:app_chat/model/user.dart';
import 'package:app_chat/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool checkHind = true;
  bool checkSignInErr = false;
  final formKey = GlobalKey<FormState>();
  final CubitSignUp _cubitSignUp = CubitSignUp();
  final TextEditingController _controllerName = TextEditingController();
  final TextEditingController _controllerGmail = TextEditingController();
  final TextEditingController _controllerPass = TextEditingController();

  UserData userYou = UserData();

  validateForm() {
    if (formKey.currentState!.validate()) {
      _cubitSignUp.signMeUp(context, email: _controllerGmail.text, pass: _controllerPass.text, name: _controllerName.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.cyan[200],
      body: SafeArea(
        child: BlocBuilder<CubitSignUp,SignUpState>(
          buildWhen: (pre, cur) => pre.enumSignUp != cur.enumSignUp,
          bloc: _cubitSignUp,
          builder: (context, state) {
            if(state.enumSignUp == EnumSignUp.loadingSignUp){
              return const Center(
                child: CircularProgressIndicator(),
              );
            }else if (state.enumSignUp == EnumSignUp.errSignUp){
              checkSignInErr = true;
            }else if(state.enumSignUp == EnumSignUp.doneSignUp){
              Navigator.pushNamed(context, "chatRoom");
            }else if(state.enumSignUp == EnumSignUp.signUpAgain){
              checkSignInErr = false;
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
                        const Text(
                          "Đăng Ký",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 35),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
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
                                  key: formKey,
                                  child: Column(
                                    children: [
                                      textFieldName("Name", _controllerName),
                                      textFieldGmail("Gmail", _controllerGmail),
                                      passWord(
                                          controller: _controllerPass,
                                          checkHind: checkHind,
                                          onPressed: () {
                                            setState(() {
                                              checkHind = !checkHind;
                                            });
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
                            label: "SignUp",
                            onPressed: () {
                              validateForm();
                            }),
                        const SizedBox(
                          height: 30,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Bạn đã có tài khoản?"),
                            const SizedBox(
                              width: 10,
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: const Text(
                                "Đăng nhập ngay!",
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
                                    "Đăng Ký không thành công",
                                    style: TextStyle(color: Colors.white),
                                  )),
                              Positioned(
                                top: 10,
                                right: 10,
                                child: GestureDetector(
                                  onTap: () {
                                    _cubitSignUp.signMeUpAgain();
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
                    ))
              ],
            );
          },
        )
    )
    );
  }
}
