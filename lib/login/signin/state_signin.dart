import 'package:equatable/equatable.dart';

enum EnumStateSignIn{
  initSignIn,
  loadingSignIn,
  errSignIn,
  doneSignIn,
  signInAgain,
  passHind,
  passShow
}

class SignInState extends Equatable{
  final EnumStateSignIn enumStateSignIn ;


  const SignInState({this.enumStateSignIn = EnumStateSignIn.initSignIn});

  SignInState copyWith({required EnumStateSignIn enumStateSignIn}){
    return SignInState(
      enumStateSignIn: enumStateSignIn
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [enumStateSignIn];
}