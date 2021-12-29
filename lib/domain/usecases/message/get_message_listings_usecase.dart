import 'dart:async';

import 'package:dazle/data/repositories/data_message_repository.dart';
import 'package:dazle/domain/entities/message.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

class GetMessageListingsUseCase extends UseCase<GetMessageListingsUseCaseResponse, GetMessageListingsUseCaseParams> {
  final DataMessageRepository dataMessageRepository;
  GetMessageListingsUseCase(this.dataMessageRepository);

  @override
  Future<Stream<GetMessageListingsUseCaseResponse>> buildUseCaseStream(GetMessageListingsUseCaseParams params) async {
    final controller = StreamController<GetMessageListingsUseCaseResponse>();
    
    try {
      // get message listings
      final messageListings = await dataMessageRepository.getMessageListings();
      controller.add(GetMessageListingsUseCaseResponse(messageListings));
      logger.finest('Get Message Listings successful.');
      
      controller.close();
    } catch (e) {
      logger.severe('Get Message Listings fail.');
      // Trigger .onError
      controller.addError(e);
    }
    return controller.stream;
  }

  
}


class GetMessageListingsUseCaseParams {
  GetMessageListingsUseCaseParams();
}

class GetMessageListingsUseCaseResponse {
  List<Message> messageListings;
  GetMessageListingsUseCaseResponse(this.messageListings);
}