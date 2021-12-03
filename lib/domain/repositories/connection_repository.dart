import 'package:dazle/domain/entities/invite_tile.dart';
import 'package:dazle/domain/entities/my_connection_tile.dart';

abstract class ConnectionRepository {
  Future<void> notifyUser({String email, String mobileNumber});

  Future<List<InviteTile>> readInvites({String email});

  Future<List<MyConnectionTile>> readMyConnection({String email});

  Future<void> addConnection({String userId, String invitedId});

  Future<void> removeConnection({String userId, String invitedId});
}