import 'dart:async';
import 'dart:convert' as convert;

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:dazle/domain/entities/user.dart';
import 'package:shared_preferences/shared_preferences.dart';


class GetUserUseCase extends UseCase<GetUserUseCaseResponse, GetUserUseCaseParams> {


  @override
  Future<Stream<GetUserUseCaseResponse>> buildUseCaseStream(GetUserUseCaseParams params) async {
    final controller = StreamController<GetUserUseCaseResponse>();
    
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      var user = prefs.getString('user');
      var todoUser = convert.jsonDecode(user);
      print('getCurrentUser getCurrentUser getUser $todoUser ${todoUser.runtimeType}');

      if(todoUser != null){
        controller.add(GetUserUseCaseResponse(User.fromJson(todoUser)));

        logger.finest('Get User successful.');
      }
      else{
        logger.severe('Get User is null.');

        controller.addError('Get User is null');
      }

      controller.close();
    }
    catch (e) {
      logger.severe('Get User fail.');
      // Trigger .onError
      controller.addError(e);
    }
    return controller.stream;
  }

}




class GetUserUseCaseParams {
  GetUserUseCaseParams();
}

class GetUserUseCaseResponse {
  final User user;
  GetUserUseCaseResponse(this.user);
}
