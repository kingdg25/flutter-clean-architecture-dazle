import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:dwellu/domain/repositories/todo_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';


class LogoutUserUseCase extends UseCase<LogoutUserUseCaseResponse, LogoutUserUseCaseParams> {
  final TodoRepository todoRepository;
  LogoutUserUseCase(this.todoRepository);
  final GoogleSignIn googleSignIn = GoogleSignIn();


  @override
  Future<Stream<LogoutUserUseCaseResponse>> buildUseCaseStream(LogoutUserUseCaseParams params) async {
    final controller = StreamController<LogoutUserUseCaseResponse>();
    
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
    
      await prefs.remove('accessToken');
      await prefs.remove('user');
      
      await FacebookAuth.instance.logOut();
      await googleSignIn.signOut();

      logger.finest('Logout User successful.');
      controller.close();
    }
    catch (e) {
      logger.severe('Logout User fail.');
      // Trigger .onError
      controller.addError(e);
    }
    return controller.stream;
  }

}




class LogoutUserUseCaseParams {
  LogoutUserUseCaseParams();
}

class LogoutUserUseCaseResponse {
  LogoutUserUseCaseResponse();
}
