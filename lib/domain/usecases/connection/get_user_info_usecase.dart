import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

import '../../../data/repositories/data_connection_repository.dart';
import '../../entities/user.dart';

class GetUserInfoUseCase
    extends UseCase<GetUserInfoUseCaseResponse, GetUserInfoUseCaseParams> {
  final DataConnectionRepository _userRepository;
  GetUserInfoUseCase(this._userRepository);
  @override
  Future<Stream<GetUserInfoUseCaseResponse?>> buildUseCaseStream(
      GetUserInfoUseCaseParams? params) async {
    //  initialize Stream
    final controller = StreamController<GetUserInfoUseCaseResponse>();
    try {
      //  implementation from repo
      final user = await _userRepository.getUserInfo(uid: params!.uid);
      //  add to controller

      controller.add(GetUserInfoUseCaseResponse(user));
      //  logger finest message
      logger.finest("GetUserUseCase successful");
      //  close the controller
      controller.close();
    } catch (e) {
      //  logger severe message
      print(e);
      logger.severe("GetUserUseCase unsuccessful");
      //  add error to controller
      controller.addError(e);
    }

    return controller.stream;
  }
}

class GetUserInfoUseCaseResponse {
  final User user;

  GetUserInfoUseCaseResponse(this.user);
}

class GetUserInfoUseCaseParams {
  final String uid;

  GetUserInfoUseCaseParams(this.uid);
}
