import 'dart:async';

import 'package:dazle/domain/entities/connections.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

import '../../../app/utils/app.dart';
import '../../../data/repositories/data_connection_repository.dart';
import '../../entities/user.dart';

class ReadConnectionsUseCase extends UseCase<ReadConnectionsUseCaseResponse,
    ReadConnectionsUseCaseParams> {
  final DataConnectionRepository dataConnectionRepository;
  ReadConnectionsUseCase(this.dataConnectionRepository);

  @override
  Future<Stream<ReadConnectionsUseCaseResponse>> buildUseCaseStream(
      ReadConnectionsUseCaseParams? params) async {
    final controller = StreamController<ReadConnectionsUseCaseResponse>();

    try {
      // read my connection
      User user = await App.getUser();
      final myConnection = await dataConnectionRepository.readConnections(
          email: user.email, filterByName: params!.filterByName);
      controller.add(ReadConnectionsUseCaseResponse(myConnection));
      logger.finest('Read  Connection successful.');
      controller.close();
    } catch (e) {
      logger.severe('Read  Connection fail.');
      // Trigger .onError
      controller.addError(e);
    }
    return controller.stream;
  }
}

class ReadConnectionsUseCaseParams {
  final String? filterByName;
  ReadConnectionsUseCaseParams(this.filterByName);
}

class ReadConnectionsUseCaseResponse {
  List<Connections>? connection;
  ReadConnectionsUseCaseResponse(this.connection);
}
