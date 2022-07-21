import 'dart:async';
import 'dart:io';

import 'package:dazle/data/repositories/data_profile_repository.dart';
import 'package:dazle/domain/entities/user.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

class CheckLoginTypeUseCase extends UseCase<CheckLoginTypeUseCaseResponse,
    CheckLoginTypeUseCaseParams> {
  final DataProfileRepository dataProfileRepository;

  CheckLoginTypeUseCase(this.dataProfileRepository);

  @override
  Future<Stream<CheckLoginTypeUseCaseResponse>> buildUseCaseStream(
      CheckLoginTypeUseCaseParams? params) async {
    final controller = StreamController<CheckLoginTypeUseCaseResponse>();

    try {
      final loginType =
          await dataProfileRepository.checkLoginType(user: params!.user);
      controller.add(CheckLoginTypeUseCaseResponse(loginType));
      logger.finest('Check login type success.');
    } catch (e) {
      logger.severe('Check login type fail.');
      //Trigger .onError
      controller.addError(e);
    }
    return controller.stream;
  }
}

class CheckLoginTypeUseCaseParams {
  final User? user;

  CheckLoginTypeUseCaseParams(this.user);
}

class CheckLoginTypeUseCaseResponse {
  final String loginType;

  CheckLoginTypeUseCaseResponse(this.loginType);
}
