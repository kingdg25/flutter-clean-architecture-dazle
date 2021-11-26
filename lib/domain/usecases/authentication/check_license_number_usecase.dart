import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:dazle/data/repositories/data_authentication_repository.dart';


class CheckLicenseNumberUseCase extends UseCase<CheckLicenseNumberUseCaseResponse, CheckLicenseNumberUseCaseParams> {
  final DataAuthenticationRepository dataAuthenticationRepository;
  CheckLicenseNumberUseCase(this.dataAuthenticationRepository);


  @override
  Future<Stream<CheckLicenseNumberUseCaseResponse>> buildUseCaseStream(CheckLicenseNumberUseCaseParams params) async {
    final controller = StreamController<CheckLicenseNumberUseCaseResponse>();
    
    try {
      bool check = await dataAuthenticationRepository.checkLicenseNumber(
        brokerLicenseNumber: params.licenseNumber
      );
      controller.add(CheckLicenseNumberUseCaseResponse(check));

      logger.finest('Check License Number successful.');
      controller.close();
    }
    catch (e) {
      logger.severe('Check License Number fail.');
      // Trigger .onError
      controller.addError(e);
    }
    return controller.stream;
  }

}




class CheckLicenseNumberUseCaseParams {
  final String licenseNumber;
  CheckLicenseNumberUseCaseParams(this.licenseNumber);
}

class CheckLicenseNumberUseCaseResponse {
  final bool check;
  CheckLicenseNumberUseCaseResponse(this.check);
}
