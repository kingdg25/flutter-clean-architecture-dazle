import 'package:dazle/domain/entities/invite_tile.dart';
import 'package:dazle/domain/entities/my_connection_tile.dart';
import 'package:dazle/domain/entities/user.dart';

import '../entities/connections.dart';
import '../entities/property.dart';

abstract class ConnectionRepository {
  Future<void> notifyUser({String? email, String? mobileNumber});

  Future<List<InviteTile>?> readInvites({String? email, String? filterByName});

  Future<List<MyConnectionTile>?> readMyConnection(
      {String? email, String? filterByName});

  Future<List<Connections>?> readConnections(
      {String? email, String? filterByName});

  Future<void> addConnection({String? userId, String? invitedId});

  Future<void> removeConnection({String? userId, String? invitedId});

  Future<List<Property>> getUserListings({String? uid});

  Future<User> getUserInfo(String uid);

  Future<List<String>?> searchUser(
      {String? userId, String? pattern, bool? invited});
}
