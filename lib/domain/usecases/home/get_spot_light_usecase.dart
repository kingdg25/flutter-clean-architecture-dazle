import 'dart:async';
import 'package:dazle/data/repositories/data_home_repository.dart';
import 'package:dazle/domain/entities/photo_tile.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

class GetSpotLightUseCase extends UseCase<GetSpotLightUseCaseResponse, GetSpotLightUseCaseParams> {
  final DataHomeRepository dataHomeRepository;
  GetSpotLightUseCase(this.dataHomeRepository);

  @override
  Future<Stream<GetSpotLightUseCaseResponse>> buildUseCaseStream(GetSpotLightUseCaseParams? params) async {
    final controller = StreamController<GetSpotLightUseCaseResponse>();
    
    try {
      // get spot light
      final spotLight = await dataHomeRepository.getSpotLight();
      controller.add(GetSpotLightUseCaseResponse(spotLight));
      logger.finest('Get Spot Light successful.');
      
      controller.close();
    } catch (e) {
      logger.severe('Get Spot Light fail.');
      // Trigger .onError
      controller.addError(e);
    }
    return controller.stream;
  }

  
}


class GetSpotLightUseCaseParams {
  GetSpotLightUseCaseParams();
}

class GetSpotLightUseCaseResponse {
  List<PhotoTile> spotLight;
  GetSpotLightUseCaseResponse(this.spotLight);
}