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
        photoURL: 'https://picsum.photos/id/73/200/300',
        keywords: ['aa', 'ss'],
        amount: '540,735.12',
        totalBedRoom: '213',
        totalBathRoom: '321',
        totalParkingSpace: '22',
        totalArea: '432 sqft',
        district: 'Lapasan',
        city: 'Cagayan de Oro City',
        amenities: ['Shared Gym','Covered Parking','Central AC'],
        isYourProperty: 'unfurnished',
        timePeriod: 'month',
        description: "Property Description: Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s"
      )
    ];
  }
  
  @override
  Future<List<Property>> getMyCollection() async {
    return [
      Property(
        photoURL: 'https://picsum.photos/id/76/200/300',
        keywords: ['qq', 'ww'],
        amount: '664,321.12',
        totalBedRoom: '11',
        totalBathRoom: '22',
        totalParkingSpace: '33',
        totalArea: '64 sqft',
        district: 'Lapasan',
        city: 'Cagayan de Oro City',
        amenities: ['Kitchen','Wifi','Eco Friendly','Security'],
        isYourProperty: 'furnished',
        timePeriod: 'year',
        description: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum."
      )
    ];
  }

}