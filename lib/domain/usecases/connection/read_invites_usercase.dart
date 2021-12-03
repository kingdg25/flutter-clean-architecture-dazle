import 'dart:async';
import 'package:dazle/app/utils/app.dart';
import 'package:dazle/data/repositories/data_connection_repository.dart';
import 'package:dazle/domain/entities/invite_tile.dart';
import 'package:dazle/domain/entities/user.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

class ReadInvitesUseCase extends UseCase<ReadInvitesUseCaseResponse, ReadInvitesUseCaseParams> {
  final DataConnectionRepository dataConnectionRepository;
  ReadInvitesUseCase(this.dataConnectionRepository);

  @override
  Future<Stream<ReadInvitesUseCaseResponse>> buildUseCaseStream(ReadInvitesUseCaseParams params) async {
    final controller = StreamController<ReadInvitesUseCaseResponse>();
    
    try {
      // read invites
      User user = await App.getUser();
      if (user != null) {
        final invites = await dataConnectionRepository.readInvites(email: user.email, filterByName: params.filterByName);
        controller.add(ReadInvitesUseCaseResponse(invites));
        logger.finest('Read Invites successful.');
      }
      else {
        logger.severe('Read Invites fail.');
        controller.addError('user data is null');
      }
      
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
  final String filterByName;
  ReadInvitesUseCaseParams(this.filterByName);
}

class ReadInvitesUseCaseResponse {
  List<InviteTile> invites;
  ReadInvitesUseCaseResponse(this.invites);
}