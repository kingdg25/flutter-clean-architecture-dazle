import 'package:dazle/domain/entities/photo_tile.dart';
import 'package:dazle/domain/entities/property.dart';

abstract class HomeRepository {
  Future<void> isNewUser({String? email, bool? isNewUser});

  Future<List<PhotoTile>> getSpotLight();

  Future<List<Property>> getMatchedProperties();

  Future<List<PhotoTile>> getWhyBrooky();

  Future<List<Property>> getNewHomes();
}