import 'package:dazle/domain/entities/property.dart';

abstract class ListingRepository {
  Future<void> create({ Map listing });

  Future<List<Property>> getMyListing();

  Future<List<Property>> getMyCollection();
}