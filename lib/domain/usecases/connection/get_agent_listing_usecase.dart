import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

import '../../../data/repositories/data_connection_repository.dart';
import '../../entities/property.dart';

class GetAgentListingUsecase extends UseCase<GetAgentListingUsecaseResponse,
    GetAgentListingUsecaseParams> {
  final DataConnectionRepository _agentRepository;

  GetAgentListingUsecase(this._agentRepository);
  @override
  Future<Stream<GetAgentListingUsecaseResponse?>> buildUseCaseStream(
      GetAgentListingUsecaseParams? params) async {
    //  initialize Stream
    final controller = StreamController<GetAgentListingUsecaseResponse>();
    try {
      //  implementation from repo
      final listing = await _agentRepository.getAgentListings(uid: params!.uid);
      //  add to controller

      controller.add(GetAgentListingUsecaseResponse(listing));
      //  logger finest message
      logger.finest("GetAgentListingUsecase successful");
      //  close the controller
      controller.close();
    } catch (e) {
      //  logger severe message
      print(e);
      logger.severe("GetAgentListingUsecase unsuccessful");
      //  add error to controller
      controller.addError(e);
    }
    return controller.stream;
  }
}

class GetAgentListingUsecaseResponse {
  final List<Property> property;

  GetAgentListingUsecaseResponse(this.property);
}

class GetAgentListingUsecaseParams {
  final String uid;

  GetAgentListingUsecaseParams(this.uid);
}
