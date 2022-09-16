import 'dart:convert';


import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'onboard_bloc_event.dart';
part 'onboard_bloc_state.dart';

class OnboardBlocBloc extends Bloc<OnboardBlocEvent, SeenOnBoardState>
    with HydratedMixin {
  OnboardBlocBloc() : super(SeenOnBoardState(true)) {
    on<SeenOnBoardEvent>(
      (event, emit) {
        final choosenBool = event.seenOnboard;
        emit(SeenOnBoardState(choosenBool));
      },
    );
  }

  @override
  SeenOnBoardState? fromJson(Map<String, dynamic> json) {
    return SeenOnBoardState.fromMap(json);
  }

  @override
  Map<String, dynamic>? toJson(SeenOnBoardState state) {
    return state.toMap();
  }
}
