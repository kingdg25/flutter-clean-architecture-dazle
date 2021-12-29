import 'dart:async';

import 'package:dazle/data/repositories/data_message_repository.dart';
import 'package:dazle/domain/entities/message.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

class GetMessageLeadsUseCase extends UseCase<GetMessageLeadsUseCaseResponse, GetMessageLeadsUseCaseParams> {
  final DataMessageRepository dataMessageRepository;
  GetMessageLeadsUseCase(this.dataMessageRepository);

  @override
  Future<Stream<GetMessageLeadsUseCaseResponse>> buildUseCaseStream(GetMessageLeadsUseCaseParams params) async {
    final controller = StreamController<GetMessageLeadsUseCaseResponse>();
    
    try {
      // get message leads
      final messageLeads = await dataMessageRepository.getMessageLeads();
      controller.add(GetMessageLeadsUseCaseResponse(messageLeads));
      logger.finest('Get Message Leads successful.');
      
      controller.close();
    } catch (e) {
      logger.severe('Get Message Leads fail.');
      // Trigger .onError
      controller.addError(e);
    }
    return controller.stream;
  }

  
}


class GetMessageLeadsUseCaseParams {
  GetMessageLeadsUseCaseParams();
}

class GetMessageLeadsUseCaseResponse {
  List<Message> messageLeads;
  GetMessageLeadsUseCaseResponse(this.messageLeads);
}