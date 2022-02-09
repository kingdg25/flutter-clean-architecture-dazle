import 'dart:async';
import 'dart:io';

import 'package:dazle/data/repositories/data_profile_repository.dart';
import 'package:dazle/domain/entities/user.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

class RequestVerificationUsecase extends UseCase<
    RequestVerificationUseCaseResponse, RequestVerificationUseCaseParams> {
  final DataProfileRepository dataProfileRepository;

  RequestVerificationUsecase(this.dataProfileRepository);

  @override
  Future<Stream<RequestVerificationUseCaseResponse>> buildUseCaseStream(
      RequestVerificationUseCaseParams params) async {
    final controller = StreamController<RequestVerificationUseCaseResponse>();

    try {
      final verification = await dataProfileRepository.requestVerification(
          attachment: params.attachment);

      logger.finest('Request Verification successful.');
      controller.add(RequestVerificationUseCaseResponse(verification));
      controller.close();
    } catch (e) {
      logger.severe('Request Verificaiton fail.');
      // Trigger .onError
      controller.addError(e);
    }
    return controller.stream;
  }
}

class RequestVerificationUseCaseParams {
  final File attachment;

  RequestVerificationUseCaseParams(this.attachment);
}

class RequestVerificationUseCaseResponse {
  final Verification verificaiton;

  RequestVerificationUseCaseResponse(this.verificaiton);
}
