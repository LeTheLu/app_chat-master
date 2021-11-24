import 'package:equatable/equatable.dart';

enum EnumHome{
  initHome,
  loadingHome,
  errHome,
  doneHome,

  initSearch,
  loadingSearch,
  doneSearch,
  errSearch

}

class StateHome extends Equatable{
  final EnumHome enumHome;
  const StateHome({this.enumHome = EnumHome.initHome});

  StateHome copyWith({required EnumHome enumHome}){
    return StateHome(
      enumHome: enumHome
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [enumHome];
}