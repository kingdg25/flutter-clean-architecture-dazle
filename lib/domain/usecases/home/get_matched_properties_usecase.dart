import 'dart:async';
import 'package:dazle/data/repositories/data_home_repository.dart';
import 'package:dazle/domain/entities/property.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

class GetMatchedPropertiesUseCase extends UseCase<GetMatchedPropertiesUseCaseResponse, GetMatchedPropertiesUseCaseParams> {
  final DataHomeRepository dataHomeRepository;
  GetMatchedPropertiesUseCase(this.dataHomeRepository);

  @override
  Future<Stream<GetMatchedPropertiesUseCaseResponse>> buildUseCaseStream(GetMatchedPropertiesUseCaseParams params) async {
    final controller = StreamController<GetMatchedPropertiesUseCaseResponse>();
    
    try {
      // get matched properties
      final matchedProperties = await dataHomeRepository.getMatchedProperties();
      controller.add(GetMatchedPropertiesUseCaseResponse(matchedProperties));
      logger.finest('Get Matched Properties successful.');
      
      controller.close();
    } catch (e) {
      logger.severe('Get Matched Properties fail.');
      // Trigger .onError
      controller.addError(e);
    }
    return controller.stream;
  }

  
}


class GetMatchedPropertiesUseCaseParams {
  GetMatchedPropertiesUseCaseParams();
}

class GetMatchedPropertiesUseCaseResponse {
  List<Property> matchedProperties;
  GetMatchedPropertiesUseCaseResponse(this.matchedProperties);
}