import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mynotes/services/auth/auth_provider.dart';
import 'package:mynotes/services/auth/bloc/auth_event.dart';
import 'package:mynotes/services/auth/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {


  AuthBloc(AuthProvider provider) : super(const AuthStateLoading()) {
    on<AuthEventInitialize>((event, emit) async{ // emit help to send state from your authbloc out
     await provider.initialize();
     final user = provider.currentUser;
     // initializing
     if (user == null){
      emit(const AuthStateLoggedOut(null));
     }
     else if (!user.isEmailVerified){
      emit(const AuthStateNeedsVerification());
     }else {
      emit(AuthStateLoggedIn(user));
     }
     // login
     on<AuthEventLogIn >((event, emit) async{ // emit help to send state from your authbloc out
     final email = event.email;
     final password = event.password;
     try{
      final user = await provider.logIn(
        email: email,
        password: password,
      );
      emit(AuthStateLoggedIn(user));
     } on Exception catch(e) {
      emit(AuthStateLoggedOut(e));
     }
    });
    // log out
    on<AuthEventLogOut>((event, emit) async{ // emit help to send state from your authbloc out
     emit(const AuthStateLoading());
     
     try{
      await provider.logOut();
      emit(const AuthStateLoggedOut(null));
     }on  Exception catch(e) {
      emit(AuthStateLogOutFailure(e));
     }
    });
  });
  }
}