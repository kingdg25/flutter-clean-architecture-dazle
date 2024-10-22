import 'dart:async';
import 'package:dazle/app/utils/app.dart';
import 'package:dazle/data/repositories/data_connection_repository.dart';
import 'package:dazle/domain/entities/my_connection_tile.dart';
import 'package:dazle/domain/entities/user.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

class ReadMyConnectionUseCase extends UseCase<ReadMyConnectionUseCaseResponse,
    ReadMyConnectionUseCaseParams> {
  final DataConnectionRepository dataConnectionRepository;
  ReadMyConnectionUseCase(this.dataConnectionRepository);

  @override
  Future<Stream<ReadMyConnectionUseCaseResponse>> buildUseCaseStream(
      ReadMyConnectionUseCaseParams? params) async {
    final controller = StreamController<ReadMyConnectionUseCaseResponse>();

    try {
      // read my connection
      User user = await App.getUser();
      // if (user != null) {
      final myConnection = await dataConnectionRepository.readMyConnection(
          email: user.email, filterByName: params!.filterByName);
      controller.add(ReadMyConnectionUseCaseResponse(myConnection));
      logger.finest('Read My Connection successful.');
      // }
      // else {
      //   logger.severe('Read My Connection fail.');
      //   controller.addError('user data is null');
      // }

      controller.close();
    } catch (e) {
      logger.severe('Read My Connection fail.');
      // Trigger .onError
      controller.addError(e);
    }
    return controller.stream;
  }
}

class ReadMyConnectionUseCaseParams {
  final String? filterByName;
  ReadMyConnectionUseCaseParams(this.filterByName);
}

class ReadMyConnectionUseCaseResponse {
  List<MyConnectionTile>? myConnection;
  ReadMyConnectionUseCaseResponse(this.myConnection);
}
