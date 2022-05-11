import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

import '../../../data/repositories/data_connection_repository.dart';
import '../../entities/user.dart';

class GetAgentInfoUseCase
    extends UseCase<GetAgentInfoUseCaseResponse, GetAgentInfoUseCaseParams> {
  final DataConnectionRepository _agentRepository;
  GetAgentInfoUseCase(this._agentRepository);
  @override
  Future<Stream<GetAgentInfoUseCaseResponse?>> buildUseCaseStream(
      GetAgentInfoUseCaseParams? params) async {
    //  initialize Stream
    final controller = StreamController<GetAgentInfoUseCaseResponse>();
    try {
      //  implementation from repo
      final agent = await _agentRepository.getAgentInfo(uid: params!.uid);
      //  add to controller

      controller.add(GetAgentInfoUseCaseResponse(agent));
      //  logger finest message
      logger.finest("GetAgentUseCase successful");
      //  close the controller
      controller.close();
    } catch (e) {
      //  logger severe message
      print(e);
      logger.severe("GetAgentUseCase unsuccessful");
      //  add error to controller
      controller.addError(e);
    }

    return controller.stream;
  }
}

class GetAgentInfoUseCaseResponse {
  final User agent;

  GetAgentInfoUseCaseResponse(this.agent);
}

class GetAgentInfoUseCaseParams {
  final String uid;

  GetAgentInfoUseCaseParams(this.uid);
}
