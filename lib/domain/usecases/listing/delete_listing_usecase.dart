import 'dart:async';
import 'dart:io';

import 'package:dazle/data/repositories/data_listing_repository.dart';
import 'package:dazle/domain/entities/property.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

class DeleteListingUseCase extends UseCase<void, DeleteListingUseCaseParams> {
  final DataListingRepository dataListingRepository;
  DeleteListingUseCase(this.dataListingRepository);

  @override
  Future<Stream<void>> buildUseCaseStream(
      DeleteListingUseCaseParams? params) async {
    final controller = StreamController();

    try {
      await dataListingRepository.deleteListing(listingId: params!.listingId);

      logger.finest('Delete Listing successful.');
      controller.close();
    } catch (e) {
      logger.severe('Delete Listing fail.');
      // Trigger .onError
      controller.addError(e);
    }
    return controller.stream;
  }
}

class DeleteListingUseCaseParams {
  final String listingId;

  DeleteListingUseCaseParams(this.listingId);
}
