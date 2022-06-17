import 'dart:async';
import 'dart:io';

import 'package:dazle/data/repositories/data_profile_repository.dart';
import 'package:dazle/domain/entities/user.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

class CreateFeedbackUsecase extends UseCase<CreateFeedbackUsecaseResponse,
    CreateFeedbackUsecaseParams> {
  final DataProfileRepository dataProfileRepository;

  CreateFeedbackUsecase(this.dataProfileRepository);

  @override
  Future<Stream<CreateFeedbackUsecaseResponse>> buildUseCaseStream(
      CreateFeedbackUsecaseParams? params) async {
    final controller = StreamController<CreateFeedbackUsecaseResponse>();

    try {
      final feedback = await dataProfileRepository.createFeedback(
          feedback: params!.feedback);
      logger.finest('Create Feedback successful');
      controller.add(CreateFeedbackUsecaseResponse(feedback));
      controller.close();
    } catch (e) {
      logger.severe('Create Feedback fail.');
      //Trigger .onError
      controller.addError(e);
    }

    return controller.stream;
  }
}

class CreateFeedbackUsecaseParams {
  final UserFeedback? feedback;

  CreateFeedbackUsecaseParams(this.feedback);
}

class CreateFeedbackUsecaseResponse {
  final UserFeedback feedback;

  CreateFeedbackUsecaseResponse(this.feedback);
}
