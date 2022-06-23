import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mynotes/services/auth/auth_provider.dart';
import 'package:mynotes/services/auth/bloc/auth_event.dart';
import 'package:mynotes/services/auth/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {


  AuthBloc(AuthProvider provider) : super(const AuthStateUninitialized()) {
    // send email verification
    on<AuthEventSendEmailVerification>((event, emit) async {
      await provider.sendEmailVerification();
      emit(state); // this means after clicking the sendemailver button no other page is push it still remain on the same page
    });
// Registering
on<AuthEventRegister>((event, emit) async{
  final email = event.email;
  final password = event.password;
  
  try{
    await provider.createUser(
    email: email,
    password: password,
  );
  await provider.sendEmailVerification();
    emit(const AuthStateNeedsVerification());
  }on Exception catch(e){
    emit(AuthStateRegistering(e));
  }

});
  on<AuthEventInitialize>((event, emit) async{ // emit help to send state from your authbloc out
     await provider.initialize();
     final user = provider.currentUser;
     // initializing
     if (user == null){
      emit(const AuthStateLoggedOut(
        exception: null,
        isLoading: false,
      ));
     }
     else if (!user.isEmailVerified){
      emit(const AuthStateNeedsVerification());
     }else {
      emit(AuthStateLoggedIn(user));
     }
     // login
     on<AuthEventLogIn >((event, emit) async{ // emit help to send state from your authbloc out
     emit(const AuthStateLoggedOut(exception: null, isLoading: true));
     final email = event.email;
     final password = event.password;
    //  await Future.delayed(const Duration(seconds: 3));
     try{
      final user = await provider.logIn(
        email: email,
        password: password,
      );
      if(!user.isEmailVerified){
         emit(const AuthStateLoggedOut(exception: null, isLoading: false));
         emit(const AuthStateNeedsVerification());
      }
      else{
        emit(const AuthStateLoggedOut(exception: null, isLoading: false));
        emit(AuthStateLoggedIn(user));
      }
      
     } on Exception catch(e) {
      emit(
        AuthStateLoggedOut(
        exception: e,
        isLoading: false,
      ));
     }
    });
    // log out
    on<AuthEventLogOut>((event, emit) async{ // emit help to send state from your authbloc out
     emit(const AuthStateUninitialized());
     
     try{
      await provider.logOut();
      emit(const AuthStateLoggedOut(exception: null, isLoading: false));
     }on  Exception catch(e) {
      emit(AuthStateLoggedOut(exception: e, isLoading: false));
     }
    });
  });
  }
}