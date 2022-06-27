
import 'package:mynotes/services/auth/auth_user.dart';
//  this defines the interface for every auth provider e.g gmail auth provider, firebase auth provider or facebook auth provider
abstract class AuthProvider {
  Future<void>initialize();
  AuthUser? get currentUser;
  Future<AuthUser> logIn({
    required String email,
    required String password,
  });
  Future<AuthUser> createUser({
    required String email,
    required String password,
  });
  Future<void> logOut();
  Future<void> sendEmailVerification();
  Future<void> sendPasswordReset({required String toEmail});
}