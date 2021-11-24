import 'package:equatable/equatable.dart';

enum EnumSignUp{
  initSignUp,
  loadingSignUp,
  errSignUp,
  doneSignUp,
  signUpAgain
}
class SignUpState extends Equatable{
  final EnumSignUp enumSignUp;
  const SignUpState({this.enumSignUp = EnumSignUp.initSignUp});

  SignUpState copyWith({required EnumSignUp enumSignUp}){
    return SignUpState(
      enumSignUp: enumSignUp
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [enumSignUp];


}