



import 'package:flutter/foundation.dart';
import 'package:mynotes/services/auth/auth_user.dart';
import 'package:equatable/equatable.dart';
@immutable
abstract class AuthState{
  const AuthState();
}

// A state of loading
// class AuthStateLoading extends AuthState { // for the State to not be dormant when 
// //firebase auth is just begining to initialize. it can be use when the user just open
// // the application or when trying to communicate with firebase(when user click the login in button)
// const AuthStateLoading();
// }  

class AuthStateUninitialized extends AuthState {
  const AuthStateUninitialized();
}

class AuthStateRegistering extends AuthState {
  final Exception? exception;
  const AuthStateRegistering(this.exception);
}
class AuthStateLoggedIn extends AuthState{
  final AuthUser user;
  const AuthStateLoggedIn(this.user);
  
}

class AuthStateNeedsVerification extends AuthState {
  const AuthStateNeedsVerification();
}

class AuthStateLoggedOut extends AuthState with EquatableMixin {
  final Exception?  exception;
  final bool isLoading;
  const AuthStateLoggedOut({ 
    required this.exception,
    required this.isLoading,
    });
    
      @override
      List<Object?> get props => [exception,isLoading]; // the log out state in itself doesnt have to carry anything
}

