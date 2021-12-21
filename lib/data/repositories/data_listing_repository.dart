import 'package:dazle/domain/entities/property.dart';
import 'package:dazle/domain/repositories/listing_repository.dart';

class DataListingRepository extends ListingRepository {
  List<Property> myListing;
  List<Property> myCollection;

  static DataListingRepository _instance = DataListingRepository._internal();
  DataListingRepository._internal() {
    myListing = <Property>[];
    myCollection = <Property>[];
  }
  factory DataListingRepository() => _instance;

  @override
  Future<void> create({Map listing}) async {
    print('creating listing $listing');
  }

  @override
  Future<List<Property>> getMyListing() async {
    return [
      Property(
        'https://picsum.photos/id/73/200/300',
        ['aa', 'ss'],
        '540,735.12',
        '213',
        '321',
        '22',
        '432 sqft',
        'Lapasan',
        'Cagayan de Oro City'
      )
    ];
  }
  
  @override
  Future<List<Property>> getMyCollection() async {
    return [
      Property(
        'https://picsum.photos/id/76/200/300',
        ['qq', 'ww'],
        '664,321.12',
        '11',
        '22',
        '33',
        '64 sqft',
        'Lapasan',
        'Cagayan de Oro City'
      )
    ];
  }

}