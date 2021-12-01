import 'package:dazle/domain/entities/invite_tile.dart';

abstract class ConnectionRepository {
  Future<void> notifyUser({String email, String mobileNumber});

  Future<List<InviteTile>> readInvites({String email});
}