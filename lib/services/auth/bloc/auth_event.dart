

import 'package:flutter/foundation.dart' show immutable;

@immutable
abstract class AuthEvent{
  const AuthEvent();
}

class AuthEventInitialize extends AuthEvent { // upon starting your auth process we start ny initializing
  const AuthEventInitialize(); // from main file (future: AuthService.firebase().initialize(),)
}


class AuthEventLogIn extends AuthEvent {
  final String email;
  final String password;
  const AuthEventLogIn(this.email, this.password); 
}

class AuthEventLogOut extends AuthEvent {
  const AuthEventLogOut(); // from  note_view line 49
}