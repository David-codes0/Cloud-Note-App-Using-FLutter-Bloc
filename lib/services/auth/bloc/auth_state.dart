



import 'package:flutter/foundation.dart';
import 'package:mynotes/services/auth/auth_user.dart';

@immutable
abstract class AuthState{
  const AuthState();
}

// A state of loading
class AuthStateLoading extends AuthState { // for the State to not be dormant when 
//firebase auth is just begining to initialize. it can be use when the user just open
// the application or when trying to communicate with firebase(when user click the login in button)
const AuthStateLoading();
}  

class AuthStateLoggedIn extends AuthState{
  final AuthUser user;
  const AuthStateLoggedIn(this.user);
  
}



class AuthStateNeedsVerification extends AuthState {
  const AuthStateNeedsVerification();
}

class AuthStateLoggedOut extends AuthState{
  final Exception?  exception;
  const AuthStateLoggedOut(this.exception); // the log out state in itself doesnt have to carry anything
}

class AuthStateLogOutFailure extends AuthState {
  final Exception  exception;
  const AuthStateLogOutFailure(this.exception);     // carrying the actual excpetion that cause the failure
}