import 'package:dazle/domain/entities/property.dart';

abstract class ListingRepository {
  Future<Property> create({Map? listing});

  Future<Property> update({Map? data});

  Future<List<Property>> getMyListing();

  Future<Property> getListingDetails(String id);

  Future<List<Property>> getUserListings({String? uid});

  Future<List<Property>> getMyCollection();

  Future<void> deleteListing({String? listingId});
}
