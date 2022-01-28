import 'package:dazle/domain/entities/user.dart';

abstract class AuthenticationRepository {
  Future<void> register({
    String firstName,
    String lastName,
    String mobileNumber,
    String position,
    String brokerLicenseNumber,
    String email,
    String password
  });

  Future<User> login({String email, String password});

  Future<String> forgotPassword({String email});

  Future<void> resetPassword({String email, String code, String password});

  Future<bool> isAuthenticated();

  Future<User> socialLogin({String email, String loginType, String token});

  Future<User> setupProfile({
    String firstName,
    String lastName,
    String mobileNumber,
    String position,
    String brokerLicenseNumber,
    String email,
  });

  Future<bool> checkLicenseNumber({String brokerLicenseNumber});

  Future<void> sendEmailVerification();
}