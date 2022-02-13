import 'dart:async';
import 'package:dazle/data/repositories/data_listing_repository.dart';
import 'package:dazle/domain/entities/property.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

class GetMyCollectionUseCase extends UseCase<GetMyCollectionUseCaseResponse, GetMyCollectionUseCaseParams> {
  final DataListingRepository dataListingRepository;
  GetMyCollectionUseCase(this.dataListingRepository);

  @override
  Future<Stream<GetMyCollectionUseCaseResponse>> buildUseCaseStream(GetMyCollectionUseCaseParams? params) async {
    final controller = StreamController<GetMyCollectionUseCaseResponse>();
    
    try {
      // get my collection
      final myCollection = await dataListingRepository.getMyCollection();
      controller.add(GetMyCollectionUseCaseResponse(myCollection));
      logger.finest('Get My Collection successful.');
      
      controller.close();
    } catch (e) {
      logger.severe('Get My Collection fail.');
      // Trigger .onError
      controller.addError(e);
    }
    return controller.stream;
  }

  
}


class GetMyCollectionUseCaseParams {
  GetMyCollectionUseCaseParams();
}

class GetMyCollectionUseCaseResponse {
  List<Property> myCollection;
  GetMyCollectionUseCaseResponse(this.myCollection);
}