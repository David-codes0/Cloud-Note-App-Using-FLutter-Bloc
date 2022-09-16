part of 'onboard_bloc_bloc.dart';

abstract class OnboardBlocEvent extends Equatable{
  const OnboardBlocEvent();

  @override
  List<Object> get props => [];
}



class  SeenOnBoardEvent extends OnboardBlocEvent {
  final bool seenOnboard;

  const SeenOnBoardEvent(this.seenOnboard);

}

class OnboardCurrentPageEvent extends OnboardBlocEvent {
  final int currentPage;

  const OnboardCurrentPageEvent(this.currentPage);
}

