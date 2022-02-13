import 'dart:async';

import 'package:dazle/data/repositories/data_listing_repository.dart';
import 'package:dazle/domain/entities/property.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';


class UpdateListingUseCase extends UseCase<UpdateListingUseCaseResponse, UpdateListingUseCaseParams> {
  final DataListingRepository dataListingRepository;
  UpdateListingUseCase(this.dataListingRepository);

  @override
  Future<Stream<UpdateListingUseCaseResponse>> buildUseCaseStream(UpdateListingUseCaseParams? params) async {
    final controller = StreamController<UpdateListingUseCaseResponse>();
    
    try {
      final listing = await dataListingRepository.update(
        data: params!.data
      );
      
      logger.finest('Update Listing successful.');
      controller.add(UpdateListingUseCaseResponse(listing));
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


class UpdateListingUseCaseParams {
  final Map data;

  UpdateListingUseCaseParams(this.data);
}


class UpdateListingUseCaseResponse {
  final Property listing;

  UpdateListingUseCaseResponse(this.listing);
}