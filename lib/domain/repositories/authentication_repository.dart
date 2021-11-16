import 'package:dazle/domain/entities/todo_user.dart';

abstract class AuthenticationRepository {
  Future<void> register({
    String firstName,
    String lastName,
    String mobileNumber,
    String position,
    String licenseNumber,
    String email,
    String password
  });

  Future<TodoUser> login({String email, String password});

  Future<String> forgotPassword(String email);

  Future<void> resetPassword(String email, String code, String password);

  Future<bool> isAuthenticated();

  Future<TodoUser> socialLogin({String email, String type, String token});
}