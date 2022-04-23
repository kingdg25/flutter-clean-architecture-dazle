import '../entities/connections.dart';
import '../entities/invite_tile.dart';
import '../entities/my_connection_tile.dart';
import '../entities/property.dart';
import '../entities/user.dart';

abstract class ConnectionRepository {
  Future<void> notifyUser({String? email, String? mobileNumber});

  Future<List<InviteTile>?> readInvites({String? email, String? filterByName});

  Future<List<MyConnectionTile>?> readMyConnection(
      {String? email, String? filterByName});

  Future<List<Connections>?> readConnections(
      {String? email, String? filterByName});

  Future<void> addConnection({String? userId, String? invitedId});

  Future<void> removeConnection({String? userId, String? invitedId});

  Future<List<Property>> getAgentListings({String? uid});

  Future<User> getAgentInfo({String? uid});

  Future<List<String>?> searchUser(
      {String? userId, String? pattern, bool? invited});
}
