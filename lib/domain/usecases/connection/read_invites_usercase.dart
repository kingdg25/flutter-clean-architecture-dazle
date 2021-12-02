import 'dart:async';
import 'package:dazle/data/repositories/data_connection_repository.dart';
import 'package:dazle/domain/entities/invite_tile.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

class ReadInvitesUseCase extends UseCase<ReadInvitesUseCaseResponse, ReadInvitesUseCaseParams> {
  final DataConnectionRepository dataConnectionRepository;
  ReadInvitesUseCase(this.dataConnectionRepository);

  @override
  Future<Stream<ReadInvitesUseCaseResponse>> buildUseCaseStream(ReadInvitesUseCaseParams params) async {
    final controller = StreamController<ReadInvitesUseCaseResponse>();
    
    try {
      // read invites
      final invites = await dataConnectionRepository.readInvites(email: params.email);

      controller.add(ReadInvitesUseCaseResponse(invites));
      logger.finest('Read Invites successful.');
      controller.close();
    } catch (e) {
      logger.severe('Read Invites fail.');
      // Trigger .onError
      controller.addError(e);
    }
    return controller.stream;
  }

  
}


class ReadInvitesUseCaseParams {
  final String email;
  ReadInvitesUseCaseParams(this.email);
}

class ReadInvitesUseCaseResponse {
  List<InviteTile> invites;
  ReadInvitesUseCaseResponse(this.invites);
}