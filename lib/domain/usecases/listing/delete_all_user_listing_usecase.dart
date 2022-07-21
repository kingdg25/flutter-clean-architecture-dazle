import 'dart:async';
import 'dart:io';

import 'package:dazle/data/repositories/data_listing_repository.dart';
import 'package:dazle/domain/entities/property.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

class DeleteAllUserListingUseCase
    extends UseCase<void, DeleteAllUserListingUseCaseParams> {
  final DataListingRepository dataListingRepository;

  DeleteAllUserListingUseCase(this.dataListingRepository);

  @override
  Future<Stream<void>> buildUseCaseStream(
      DeleteAllUserListingUseCaseParams? params) async {
    final controller = StreamController();

    try {
      await dataListingRepository.deleteAllUserListing(
          createdById: params!.createdById);
      logger.finest('Delete All User Listing successful.');
      controller.close();
    } catch (e) {
      logger.severe('Delete All User Listing fail.');
      // Trigger .onError
      controller.addError(e);
    }
    return controller.stream;
  }
}

class DeleteAllUserListingUseCaseParams {
  final String? createdById;

  DeleteAllUserListingUseCaseParams(this.createdById);
}
