import 'dart:async';

import 'package:dazle/data/repositories/data_listing_repository.dart';
import 'package:dazle/domain/entities/property.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';


class CreateListingUseCase extends UseCase<CreateListingUseCaseResponse, CreateListingUseCaseParams> {
  final DataListingRepository dataListingRepository;
  CreateListingUseCase(this.dataListingRepository);

  @override
  Future<Stream<CreateListingUseCaseResponse>> buildUseCaseStream(CreateListingUseCaseParams params) async {
    final controller = StreamController<CreateListingUseCaseResponse>();
    
    try {
      final listing = await dataListingRepository.create(
        listing: params.listing
      );
      
      logger.finest('Create Listing successful.');
      controller.add(CreateListingUseCaseResponse(listing));
      controller.close();

    } 
    catch (e) {
      logger.severe('Create Listing fail.');
      // Trigger .onError
      controller.addError(e);
    }
    return controller.stream;
  }
  
}


class CreateListingUseCaseParams {
  final Map listing;

  CreateListingUseCaseParams(this.listing);
}


class CreateListingUseCaseResponse {
  final Property listing;

  CreateListingUseCaseResponse(this.listing);
}