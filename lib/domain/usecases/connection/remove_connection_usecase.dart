import 'dart:async';
import 'package:dazle/app/utils/app.dart';
import 'package:dazle/data/repositories/data_connection_repository.dart';
import 'package:dazle/domain/entities/user.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';


class RemoveConnectionUseCase extends UseCase<RemoveConnectionUseCaseResponse, RemoveConnectionUseCaseParams>{
  final DataConnectionRepository dataConnectionRepository;
  RemoveConnectionUseCase(this.dataConnectionRepository);

  @override
  Future<Stream<RemoveConnectionUseCaseResponse>> buildUseCaseStream(RemoveConnectionUseCaseParams? params) async {
    final controller = StreamController<RemoveConnectionUseCaseResponse>();

    try {
      // add connection
      User user = await App.getUser();
      if (user != null) {
        await dataConnectionRepository.removeConnection(userId: user.id, invitedId: params!.invitedId);
        logger.finest('Remove Connection successful.');
      }
      else {
        logger.severe('Remove Connection fail.');
        controller.addError('user data is null');
      }

      controller.close();
    } catch (e) {
      logger.severe('Remove Connection fail.');
      // Trigger .onError
      controller.addError(e);
    }
    return controller.stream;
  }
  
}




class RemoveConnectionUseCaseParams {
  final String? invitedId;
  RemoveConnectionUseCaseParams(this.invitedId);
}

class RemoveConnectionUseCaseResponse {
  RemoveConnectionUseCaseResponse();
}
