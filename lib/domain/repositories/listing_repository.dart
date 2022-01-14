import 'package:dazle/domain/entities/property.dart';

abstract class ListingRepository {
  Future<Property> create({ Map listing });

  Future<List<Property>> getMyListing();

  Future<List<Property>> getMyCollection();
}