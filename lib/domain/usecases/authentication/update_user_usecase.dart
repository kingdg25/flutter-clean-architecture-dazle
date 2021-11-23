import 'dart:async';

import 'package:dazle/domain/entities/todo_user.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:dazle/data/repositories/data_authentication_repository.dart';


class UpdateUserUseCase extends UseCase<UpdateUserUseCaseResponse, UpdateUserUseCaseParams> {
  final DataAuthenticationRepository dataAuthenticationRepository;
  UpdateUserUseCase(this.dataAuthenticationRepository);

  @override
  Future<Stream<UpdateUserUseCaseResponse>> buildUseCaseStream(UpdateUserUseCaseParams params) async {
    final controller = StreamController<UpdateUserUseCaseResponse>();
    
    try {
      TodoUser user = await dataAuthenticationRepository.update(
        firstName: params.firstName, 
        lastName: params.lastName,
        mobileNumber: params.mobileNumber,
        position: params.position,
        licenseNumber: params.licenseNumber,
      );
      
      controller.add(UpdateUserUseCaseResponse(user));
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


class UpdateUserUseCaseParams {
  final String firstName;
  final String lastName;
  final String mobileNumber;
  final String position;
  final String licenseNumber;

  UpdateUserUseCaseParams(
    this.firstName,
    this.lastName,
    this.mobileNumber,
    this.position,
    this.licenseNumber
  );
}


class UpdateUserUseCaseResponse {
  final TodoUser user;
  UpdateUserUseCaseResponse(this.user);
}