import 'dart:async';
import 'package:dazle/data/repositories/data_listing_repository.dart';
import 'package:dazle/domain/entities/property.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

class GetSelectedListingUseCase extends UseCase<
    GetSelectedListingUseCaseResponse, GetSelectedListingUseCaseParams> {
  final DataListingRepository dataListingRepository;
  GetSelectedListingUseCase(this.dataListingRepository);

  @override
  Future<Stream<GetSelectedListingUseCaseResponse>> buildUseCaseStream(
      GetSelectedListingUseCaseParams? params) async {
    final controller = StreamController<GetSelectedListingUseCaseResponse>();

    try {
      final selectedListing =
          await dataListingRepository.getListingDetails(params!.listingId);
      controller.add(GetSelectedListingUseCaseResponse(selectedListing));
      logger.finest('Get Selected Listing Successful.');

      controller.close();
    } catch (e) {
      logger.severe('Get Selected Listing fail.');
      controller.addError(e);
    }

    return controller.stream;
  }
}

class GetSelectedListingUseCaseParams {
  String listingId;
  GetSelectedListingUseCaseParams(this.listingId);
}

class GetSelectedListingUseCaseResponse {
  Property selectedListing;
  GetSelectedListingUseCaseResponse(this.selectedListing);
}
