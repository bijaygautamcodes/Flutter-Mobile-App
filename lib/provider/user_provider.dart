import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rootnode/model/user/user.dart';
import 'package:rootnode/repository/user_repo.dart';

final userDetailsProvider =
    FutureProvider.family<User?, String>((ref, id) async {
  final userRepo = ref.watch(userRepoProvider);
  return userRepo.getUserById(id);
});
