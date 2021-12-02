import 'dart:async';
import 'package:dazle/app/utils/app.dart';
import 'package:dazle/data/repositories/data_connection_repository.dart';
import 'package:dazle/domain/entities/user.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';


class AddConnectionUseCase extends UseCase<AddConnectionUseCaseResponse, AddConnectionUseCaseParams>{
  final DataConnectionRepository dataConnectionRepository;
  AddConnectionUseCase(this.dataConnectionRepository);

  @override
  Future<Stream<AddConnectionUseCaseResponse>> buildUseCaseStream(AddConnectionUseCaseParams params) async {
    final controller = StreamController<AddConnectionUseCaseResponse>();

    try {
      // add connection
      User user = await App.getUser();
      if (user != null) {
        await dataConnectionRepository.addConnection(userId: user.id, invitedId: params.invitedId);
        logger.finest('Add Connection successful.');
      }
      else {
        logger.severe('Add Connection fail.');
        controller.addError('user data is null');
      }

      controller.close();
    } catch (e) {
      logger.severe('Add Connection fail.');
      // Trigger .onError
      controller.addError(e);
    }
    return controller.stream;
  }
  
}




class AddConnectionUseCaseParams {
  final String invitedId;
  AddConnectionUseCaseParams(this.invitedId);
}

class AddConnectionUseCaseResponse {
  AddConnectionUseCaseResponse();
}
