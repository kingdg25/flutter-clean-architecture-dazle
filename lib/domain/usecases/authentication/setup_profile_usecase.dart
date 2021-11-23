import 'dart:async';

import 'package:dazle/domain/entities/todo_user.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:dazle/data/repositories/data_authentication_repository.dart';


class SetupProfileUseCase extends UseCase<SetupProfileUseCaseResponse, SetupProfileUseCaseParams> {
  final DataAuthenticationRepository dataAuthenticationRepository;
  SetupProfileUseCase(this.dataAuthenticationRepository);

  @override
  Future<Stream<SetupProfileUseCaseResponse>> buildUseCaseStream(SetupProfileUseCaseParams params) async {
    final controller = StreamController<SetupProfileUseCaseResponse>();
    
    try {
      TodoUser user = await dataAuthenticationRepository.setupProfile(
        firstName: params.firstName, 
        lastName: params.lastName,
        mobileNumber: params.mobileNumber,
        position: params.position,
        licenseNumber: params.licenseNumber,
        email: params.email
      );
      
      controller.add(SetupProfileUseCaseResponse(user));
      logger.finest('Update User successful.');
      controller.close();

    } 
    catch (e) {
      logger.severe('Update User fail.');
      // Trigger .onError
      controller.addError(e);
    }
    return controller.stream;
  }
  
}


class SetupProfileUseCaseParams {
  final String firstName;
  final String lastName;
  final String mobileNumber;
  final String position;
  final String licenseNumber;
  final String email;

  SetupProfileUseCaseParams(
    this.firstName,
    this.lastName,
    this.mobileNumber,
    this.position,
    this.licenseNumber,
    this.email
  );
}


class SetupProfileUseCaseResponse {
  final TodoUser user;
  SetupProfileUseCaseResponse(this.user);
}