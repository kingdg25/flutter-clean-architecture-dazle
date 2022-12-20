import 'dart:async';

import 'package:dazle/data/repositories/data_listing_repository.dart';
// import 'package:dazle/data/repositories/data_profile_repository.dart';
import 'package:dazle/domain/entities/property.dart';
// import 'package:dazle/domain/entities/user.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

class GetUserListingsUseCase extends UseCase<GetUserListingsUseCaseResponse,
    GetUserListingsUseCaseParams> {
  final DataListingRepository dataListingRepository;
  GetUserListingsUseCase(this.dataListingRepository);

  @override
  Future<Stream<GetUserListingsUseCaseResponse>> buildUseCaseStream(
      GetUserListingsUseCaseParams? params) async {
    final controller = StreamController<GetUserListingsUseCaseResponse>();

    try {
      final listings =
          await dataListingRepository.getUserListings(uid: params!.uid);

      logger.finest('Fetching user listing success.');
      controller.add(GetUserListingsUseCaseResponse(listings: listings));
      controller.close();
    } catch (e) {
      logger.severe('Fetch user listings fail.');
      // Trigger .onError
      controller.addError(e);
    }
    return controller.stream;
  }
}

class GetUserListingsUseCaseParams {
  final String? uid; // user_id to view listings

  GetUserListingsUseCaseParams({this.uid});
}

class GetUserListingsUseCaseResponse {
  List<Property>? listings;
  GetUserListingsUseCaseResponse({this.listings});
}
