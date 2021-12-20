import 'package:dazle/domain/repositories/listing_repository.dart';

class DataListingRepository extends ListingRepository {
  static DataListingRepository _instance = DataListingRepository._internal();
  DataListingRepository._internal();
  factory DataListingRepository() => _instance;

  @override
  Future<void> create({Map listing}) async {
    print('creating listing $listing');
  }
  
}