import 'dart:async';
import 'package:dazle/data/repositories/data_listing_repository.dart';
import 'package:dazle/domain/entities/property.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

class GetMyListingUseCase extends UseCase<GetMyListingUseCaseResponse, GetMyListingUseCaseParams> {
  final DataListingRepository dataListingRepository;
  GetMyListingUseCase(this.dataListingRepository);

  @override
  Future<Stream<GetMyListingUseCaseResponse>> buildUseCaseStream(GetMyListingUseCaseParams? params) async {
    final controller = StreamController<GetMyListingUseCaseResponse>();
    
    try {
      // get my listing
      final myListing = await dataListingRepository.getMyListing();
      controller.add(GetMyListingUseCaseResponse(myListing));
      logger.finest('Get My Listing successful.');
      
      controller.close();
    } catch (e) {
      logger.severe('Get My Listing fail.');
      // Trigger .onError
      controller.addError(e);
    }
    return controller.stream;
  }

  
}


class GetMyListingUseCaseParams {
  GetMyListingUseCaseParams();
}

class GetMyListingUseCaseResponse {
  List<Property> myListing;
  GetMyListingUseCaseResponse(this.myListing);
}