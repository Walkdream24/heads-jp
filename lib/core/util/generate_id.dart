import 'dart:math';

class GeneratedId {
  String generateIdFromUuid() {
  // Commented out UUID-related line from original implementation
  // String uuid = Uuid().v4().replaceAll('-', '');

  const String base62Characters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
  String customId = '';

  while (customId.length < 28) {
    final randomIndex = Random().nextInt(base62Characters.length);
    customId += base62Characters[randomIndex];
  }

  return customId;
}

}