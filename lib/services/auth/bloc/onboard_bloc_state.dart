part of 'onboard_bloc_bloc.dart';

abstract class OnboardBlocState extends Equatable {
   
}



class SeenOnBoardState extends OnboardBlocState {
final bool seenOnboard;
   SeenOnBoardState(this.seenOnboard);
  
  @override
  List<Object> get props => [seenOnboard];
  

  @override
  String toString() {
   
    return 'seenOnboard $seenOnboard';
  }




  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'seenOnboard': seenOnboard,
    };
  }

  factory SeenOnBoardState.fromMap(Map<String, dynamic> map) {
    return SeenOnBoardState(
      map['seenOnboard'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory SeenOnBoardState.fromJson(String source) => SeenOnBoardState.fromMap(json.decode(source) as Map<String, dynamic>);
}

class OnboardCurrentPageState extends OnboardBlocState {
  final int currentPage;

   OnboardCurrentPageState({this.currentPage = 0});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'currentPage': currentPage,
    };
  }

  factory OnboardCurrentPageState.fromMap(Map<String, dynamic> map) {
    return OnboardCurrentPageState(
      currentPage: map['currentPage'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory OnboardCurrentPageState.fromJson(String source) => OnboardCurrentPageState.fromMap(json.decode(source) as Map<String, dynamic>);
  
  @override

  List<Object?> get props =>[currentPage];
}
