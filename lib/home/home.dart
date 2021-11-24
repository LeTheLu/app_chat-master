import 'dart:async';
import 'package:app_chat/chat/chat.dart';
import 'package:app_chat/home/cubit_home.dart';
import 'package:app_chat/home/state_home.dart';
import 'package:app_chat/model/user.dart';
import 'package:app_chat/servies/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool searchCheck = false;
  DatabaseMethod userData = DatabaseMethod();

  final TextEditingController _controllerSearch = TextEditingController();

  Delay debouncer = Delay(500);
  String emailUser = '';

  final CubitHome _cubitHome = CubitHome();


  List<Map<String, String>> listFriend = [];
  List<UserData> listSearch = [];


  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {
      listFriend = await _cubitHome.getListHistory(context);
    });
    super.initState();
    _controllerSearch.addListener(() async {
      if(_controllerSearch.text == ""){
        listFriend = await _cubitHome.getListHistory(context);
      }
      Delay(700);
      listSearch = await _cubitHome.getListSearch(context,name: _controllerSearch.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.cyan[200],
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      avatarUser(),
                      const SizedBox(
                        width: 10,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            UserInheritedWidget.of(context).user.name ?? 'User',
                            style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                                fontSize: 20),
                          ),
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(50),
                                  child: Container(
                                    color: Colors.green,
                                    height: 10,
                                    width: 10,
                                  ),
                                ),
                              ),
                              Text(
                                "Đang hoạt động",
                                style: TextStyle(color: Colors.grey[900]),
                              )
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        searchCheck = !searchCheck;
                      });
                    },
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white54,
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                      ),
                      height: 40,
                      width: 40,
                      child: const Icon(Icons.search, color: Colors.black),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Visibility(
                  visible: searchCheck,
                  child: SizedBox(
                    height: 50,
                    width: MediaQuery.of(context).size.width - 20,
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                          const BorderRadius.all(Radius.circular(30)),
                          border: Border.all(color: Colors.teal)),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: TextField(
                            controller: _controllerSearch,
                            decoration: const InputDecoration.collapsed(
                                hintText: "Search ... "),
                          ),
                        ),
                      ),
                    ),
                  )),
            ),
            Expanded(
                child: Opacity(
                    opacity: 0.7,
                    child: Container(
                        decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(50),
                                topRight: Radius.circular(50))),
                        height: double.infinity,
                        width: double.infinity,
                        child: BlocBuilder<CubitHome, StateHome>(
                          buildWhen: (pre, cur) => pre.enumHome != cur.enumHome,
                          bloc: _cubitHome,
                          builder: (context, state) {
                            if (state.enumHome == EnumHome.loadingHome) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            } else if (state.enumHome == EnumHome.errHome) {
                              return Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: const [
                                    Text("Bạn chưa có cuộc trò chuyện nào!", style: TextStyle(color: Colors.grey, fontSize: 20, fontWeight: FontWeight.w600),),
                                    Text("Hãy nói chuyện với bạn bè của bạn nhé!", style: TextStyle(color: Colors.grey, fontSize: 15, fontWeight: FontWeight.w600))
                                  ],
                                ),
                              );
                            } else if (state.enumHome == EnumHome.doneHome){
                              return ListView.separated(
                                  separatorBuilder: (context, index) =>
                                  const Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10.0),
                                    child: Divider(),
                                  ),
                                  itemCount: listFriend.length,
                                  itemBuilder: (context, index) {
                                    return UserFriend(idChatRoom: listFriend[index].keys.first, nameFriend:listFriend[index].values.first);
                                  });

                            } else if (state.enumHome == EnumHome.initSearch) {

                            }
                            else if (state.enumHome == EnumHome.loadingSearch) {
                            } else if (state.enumHome == EnumHome.doneSearch) {
                              return ListView.separated(
                                  separatorBuilder: (context, index) =>
                                  const Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10.0),
                                    child: Divider(),
                                  ),
                                  itemCount: listSearch.length,
                                  itemBuilder: (context, index) {
                                    return UserFriendSearch(userFriend: listSearch[index],);
                                  });
                            } else if (state.enumHome == EnumHome.errSearch) {}
                            return const SizedBox();
                          },
                        )))),
          ],
        ),
      ),
    );
  }
}

class UserFriend extends StatefulWidget {
  final String idChatRoom;
  final String nameFriend;

  const UserFriend(
      {Key? key, required this.idChatRoom, required this.nameFriend})
      : super(key: key);

  @override
  State<UserFriend> createState() => _UserFriendState();
}

class _UserFriendState extends State<UserFriend> {
  DatabaseMethod userData = DatabaseMethod();

  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => Chat(
                      idChatRoom: widget.idChatRoom,
                      nameFriend: widget.nameFriend,
                    )));
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                avatarUser(),
                const SizedBox(
                  width: 10,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.nameFriend,
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text("messenger",
                        style: TextStyle(color: Colors.grey, fontSize: 15))
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class UserFriendSearch extends StatefulWidget {
  final UserData userFriend;
  const UserFriendSearch({Key? key, required this.userFriend})
      : super(key: key);

  @override
  State<UserFriendSearch> createState() => _UserFriendSearchState();
}

class _UserFriendSearchState extends State<UserFriendSearch> {
  DatabaseMethod userData = DatabaseMethod();
  String idChatRoom = "";

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        idChatRoom = await userData.getIdChatRoomBy2Email(
            emailUser: UserInheritedWidget.of(context).user.email ?? "",
            emailFriend: widget.userFriend.email ?? "");
        await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => Chat(
                      idChatRoom: idChatRoom,
                      nameFriend: widget.userFriend.name ?? "",
                    )));
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.blue[200],
          borderRadius: const BorderRadius.all(Radius.circular(50))
        ),
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                avatarUser(),
                const SizedBox(
                  width: 10,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.userFriend.name ?? "",
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text("messenger",
                        style: TextStyle(color: Colors.grey, fontSize: 15))
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class Delay {
  final int _durationMilliseconds;
  Timer? _timer;
  Function? _currentFn;
  List? _arguments;
  Delay(this._durationMilliseconds) {
    _resetTimer();
  }

  _resetTimer() {
    if (_timer != null && _timer!.isActive) {
      _timer!.cancel();
    }
    _timer = Timer(Duration(milliseconds: _durationMilliseconds), () {
      if (_currentFn != null) {
        Function.apply(_currentFn!, _arguments);
      }
    });
  }

  run(Function fn, [List args = const []]) {
    _currentFn = fn;
    _arguments = args;
    _resetTimer();
  }
}

Widget avatarUser() {
  return ClipRRect(
    borderRadius: BorderRadius.circular(50),
    child: Container(
      color: Colors.teal,
      height: 70,
      width: 70,
    ),
  );
}
