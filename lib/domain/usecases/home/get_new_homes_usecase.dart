import 'dart:async';
import 'package:dazle/data/repositories/data_home_repository.dart';
import 'package:dazle/domain/entities/property.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

class GetNewHomesUseCase extends UseCase<GetNewHomesUseCaseResponse, GetNewHomesUseCaseParams> {
  final DataHomeRepository dataHomeRepository;
  GetNewHomesUseCase(this.dataHomeRepository);

  @override
  Future<Stream<GetNewHomesUseCaseResponse>> buildUseCaseStream(GetNewHomesUseCaseParams? params) async {
    final controller = StreamController<GetNewHomesUseCaseResponse>();
    
    try {
      // get new homes
      final newHomes = await dataHomeRepository.getNewHomes();
      controller.add(GetNewHomesUseCaseResponse(newHomes));
      logger.finest('Get New Homes successful.');
      
      controller.close();
    } catch (e) {
      logger.severe('Get New Homes fail.');
      // Trigger .onError
      controller.addError(e);
    }
    return controller.stream;
  }

  
}


class GetNewHomesUseCaseParams {
  GetNewHomesUseCaseParams();
}

class GetNewHomesUseCaseResponse {
  List<Property> newHomes;
  GetNewHomesUseCaseResponse(this.newHomes);
}