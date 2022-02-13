import 'dart:async';

import 'package:dazle/data/repositories/data_connection_repository.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';


class NotifyUserUseCase extends UseCase<void, NotifyUserUseCaseParams> {
  final DataConnectionRepository dataConnectionRepository;
  NotifyUserUseCase(this.dataConnectionRepository);

  @override
  Future<Stream<void>> buildUseCaseStream(NotifyUserUseCaseParams? params) async {
    final controller = StreamController();
    
    try {
      await dataConnectionRepository.notifyUser(
        email: params!.email,
        mobileNumber: params.mobileNumber,
      );
      
      logger.finest('Notify User successful.');
      controller.close();

    } 
    catch (e) {
      logger.severe('Notify User fail.');
      // Trigger .onError
      controller.addError(e);
    }
    return controller.stream;
  }
  
}


class NotifyUserUseCaseParams {
  final String? email;
  final String? mobileNumber;

  NotifyUserUseCaseParams(
    this.email,
    this.mobileNumber
  );
}