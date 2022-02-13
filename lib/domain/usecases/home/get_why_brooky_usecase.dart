import 'dart:async';
import 'package:dazle/data/repositories/data_home_repository.dart';
import 'package:dazle/domain/entities/photo_tile.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

class GetWhyBrookyUseCase extends UseCase<GetWhyBrookyUseCaseResponse, GetWhyBrookyUseCaseParams> {
  final DataHomeRepository dataHomeRepository;
  GetWhyBrookyUseCase(this.dataHomeRepository);

  @override
  Future<Stream<GetWhyBrookyUseCaseResponse>> buildUseCaseStream(GetWhyBrookyUseCaseParams? params) async {
    final controller = StreamController<GetWhyBrookyUseCaseResponse>();
    
    try {
      // get why brooky
      final whyBrooky = await dataHomeRepository.getWhyBrooky();
      controller.add(GetWhyBrookyUseCaseResponse(whyBrooky));
      logger.finest('Get Why Brooky successful.');
      
      controller.close();
    } catch (e) {
      logger.severe('Get Why Brooky fail.');
      // Trigger .onError
      controller.addError(e);
    }
    return controller.stream;
  }

  
}


class GetWhyBrookyUseCaseParams {
  GetWhyBrookyUseCaseParams();
}

class GetWhyBrookyUseCaseResponse {
  List<PhotoTile> whyBrooky;
  GetWhyBrookyUseCaseResponse(this.whyBrooky);
}