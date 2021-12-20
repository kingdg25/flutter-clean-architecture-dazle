import 'dart:async';

import 'package:dazle/data/repositories/data_listing_repository.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';


class CreateListingUseCase extends UseCase<void, CreateListingUseCaseParams> {
  final DataListingRepository dataListingRepository;
  CreateListingUseCase(this.dataListingRepository);

  @override
  Future<Stream<void>> buildUseCaseStream(CreateListingUseCaseParams params) async {
    final controller = StreamController();
    
    try {
      await dataListingRepository.create(
        listing: params.listing
      );
      
      logger.finest('Create Listing successful.');
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