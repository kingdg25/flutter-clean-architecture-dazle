import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:dazle/data/repositories/data_authentication_repository.dart';
import 'package:dazle/domain/entities/todo_user.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
// import 'package:flutter_facebook_login/flutter_facebook_login.dart';


class SocialLoginUseCase extends UseCase<SocialLoginUseCaseResponse, SocialLoginUseCaseParams> {
  final DataAuthenticationRepository dataAuthenticationRepository;
  SocialLoginUseCase(this.dataAuthenticationRepository);
  final GoogleSignIn googleSignIn = GoogleSignIn();


  userSignOut() async {
    await FacebookAuth.instance.logOut();
    await googleSignIn.signOut();
  }


  @override
  Future<Stream<SocialLoginUseCaseResponse>> buildUseCaseStream(SocialLoginUseCaseParams params) async {
    final controller = StreamController<SocialLoginUseCaseResponse>();
    
    try {
      if( params.type == 'gmail' ){
        GoogleSignInAccount googleUser = await googleSignIn.signIn();
        
        if(googleUser != null){
          GoogleSignInAuthentication googleAuth = await googleUser.authentication;  
          // print('$googleUser');
          // logger.shout('${googleAuth.idToken}');

          final user = await dataAuthenticationRepository.socialLogin(type: params.type, email: googleUser.email, token: googleAuth.idToken);
          controller.add(SocialLoginUseCaseResponse(user));
          
          logger.finest('Google login successful.');
        }
        else {
          logger.severe('Google login in fail.');
          controller.addError('${params.type} login fail.');
        }

      }

      else if ( params.type == 'facebook' ){
        AccessToken accessToken = await FacebookAuth.instance.login(
          permissions: ['email', 'public_profile']
        );
        
        if(accessToken != null){
          final userData = await FacebookAuth.instance.getUserData();
          // final graphResponse = await http.get('https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email&access_token=${accessToken.token}');
          // final profile = await convert.jsonDecode(graphResponse.body);
          // print('facebook data $userData $profile');

          final user = await dataAuthenticationRepository.socialLogin(type: params.type, email: userData['email'], token: accessToken.token);
          controller.add(SocialLoginUseCaseResponse(user));

          logger.finest('Facebook login successful.');
        }
        else {
          logger.finest('Facebook login fail.');
          controller.addError('${params.type} login fail.');
        }
        
      }
      
      else {
        logger.severe('Social login in fail.');
        controller.addError('No ${params.type} login type implemented');
      }

      controller.close();
    } 
    on FacebookAuthException catch (e) {
      switch (e.errorCode) {
          case FacebookAuthErrorCode.OPERATION_IN_PROGRESS:
            controller.addError("You have a previous login operation in progress");
            break;
          case FacebookAuthErrorCode.CANCELLED:
            controller.addError("login cancelled");
            break;
          case FacebookAuthErrorCode.FAILED:
            controller.addError("login failed");
            break;
      }
    }
    catch (e) {
      logger.severe('Social login in fail.');
      userSignOut();
      // Trigger .onError
      controller.addError(e);
    }
    return controller.stream;
  }

}




class SocialLoginUseCaseParams {
  final String type;
  SocialLoginUseCaseParams(this.type);
}

class SocialLoginUseCaseResponse {
  final TodoUser user;
  SocialLoginUseCaseResponse(this.user);
}
