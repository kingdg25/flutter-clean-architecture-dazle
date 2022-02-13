import 'dart:async';

import 'package:dazle/data/repositories/data_profile_repository.dart';
import 'package:dazle/domain/entities/user.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';


class UpdateUserUseCase extends UseCase<void, UpdateUserUseCaseParams> {
  final DataProfileRepository dataProfileRepository;
  UpdateUserUseCase(this.dataProfileRepository);

  @override
  Future<Stream<void>> buildUseCaseStream(UpdateUserUseCaseParams? params) async {
    final controller = StreamController();
    
    try {
      await dataProfileRepository.update(user: params!.user);
      
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
  final User? user;

  UpdateUserUseCaseParams(
    this.user
  );
}