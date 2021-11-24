import 'package:flutter/material.dart';

Widget logoFlutter(){
  return Container(
    margin: const EdgeInsets.only(bottom: 20),
    decoration: BoxDecoration(
      color: Colors.cyan[300],
      borderRadius: const BorderRadius.all(Radius.circular(15)),
    ),
    height: 150,
    width: 150,
    child: Container(
      margin: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
      child: const FlutterLogo(),
    ),
  );
}

Widget textFieldName(String name, TextEditingController? controller){
  return Container(
    margin: const EdgeInsets.all(10),
    decoration: const BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(30)),
      color: Colors.white,
    ),
    child: Padding(
      padding: const EdgeInsets.all(15.0),
      child: TextFormField(
        validator: (val){
          return val!.isEmpty || val.length < 2  ?"Tên không hợp lệ" : null;
        },
        controller: controller,
        decoration: InputDecoration.collapsed(
          hintText: name,
        ),
      ),
    ),
  );
}

Widget textFieldGmail(String name, TextEditingController? controller){
  return Container(
    margin: const EdgeInsets.all(10),
    decoration: const BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(30)),
      color: Colors.white,
    ),
    child: Padding(
      padding: const EdgeInsets.all(15.0),
      child: TextFormField(
        validator: (val){
          return RegExp(
              "^[a-z0-9](\.?[a-z0-9]){5,}@g(oogle)?mail\.com")
              .hasMatch(val!)  ? null : "Gmail không hợp lệ";
        },
        controller: controller,
        decoration: InputDecoration.collapsed(
          hintText: name,
        ),
      ),
    ),
  );
}

Widget buttonHome(
    {required BuildContext context,required String label,required VoidCallback onPressed, Color? colorButton, Color? colorText}){
  return GestureDetector(
    onTap: (){
      onPressed.call();
    },
    child: Container(
        decoration: BoxDecoration(
          color: colorButton?? Colors.teal[500],
          borderRadius: const BorderRadius.all(Radius.circular(30)),
          boxShadow: [
            BoxShadow(
              color: Colors.teal.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 2,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        height: 50,
        width: MediaQuery.of(context).size.width - 30,
        child: Center(child: Text(label, style: TextStyle(color: colorText?? Colors.white, fontSize: 20, fontWeight: FontWeight.w400)),)),
  );
}

Widget passWord({required bool checkHind,required VoidCallback onPressed, TextEditingController? controller}){
  return Container(
    margin: const EdgeInsets.all(10),
    decoration: const BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(30)),
      color: Colors.white,
    ),
    child: Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: TextFormField(
              validator: (val){
                return val!.isEmpty || val.length < 2  ?"Mật khẩu không hợp lệ" : null;
              },
              controller: controller,
              obscureText: checkHind,
              decoration: const InputDecoration.collapsed(
                hintText: "Password",
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: (){
            onPressed.call();
          },
          child: Container(
            margin: const EdgeInsets.only(right: 20),
            height: 20,
            width: 50,
            child: Text(checkHind ? "Show" : "Hind", style: const TextStyle(color: Colors.cyan),),
          ),
        ),
      ],
    ),
  );
}