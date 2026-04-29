import '../entities/blocked_users_entity.dart';

abstract class BlockedUsersRepository {
  Future<BlockRelationshipType> getBlockRelationship(BlockedUsersInput input);
  Future<void> addBlockedUser(BlockedUsersParams input); 
  Future<void> deleteBlcokedUser(BlockedUsersParams input);
}
