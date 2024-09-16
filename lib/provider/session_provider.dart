import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rootnode/helper/simple_storage.dart';
import 'package:rootnode/model/user/user.dart';
import 'package:rootnode/repository/user_repo.dart';

class SessionModel {
  final String? token;
  final User? user;
  final bool isAuthenticated;
  final bool ready;

  const SessionModel({
    this.token,
    this.isAuthenticated = false,
    this.user,
    this.ready = false,
  });

  SessionModel copyWith({
    String? token,
    User? user,
    bool? isAuthenticated,
    bool? ready,
  }) {
    return SessionModel(
      token: token ?? this.token,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      user: user ?? this.user,
      ready: ready ?? this.ready,
    );
  }
}

class SessionProvider extends StateNotifier<SessionModel> {
  final Ref ref;
  final UserRepo userRepo;
  static const _initial = SessionModel();

  SessionProvider(this.ref, this.userRepo,
      [SessionModel sessionModel = _initial])
      : super(sessionModel) {
    init();
  }
  void updateUser({required User user}) {
    if (state.user == null) {
      state = state.copyWith(user: user);
      return;
    }
    state = state.copyWith(
      user: state.user!.copyWith(
        usernameChangedAt:
            user.usernameChangedAt ?? state.user!.usernameChangedAt,
        showOnlineStatus: user.showOnlineStatus ?? state.user!.showOnlineStatus,
        emailVerified: user.emailVerified ?? state.user!.emailVerified,
        storiesCount: user.storiesCount ?? state.user!.storiesCount,
        connsCount: user.connsCount ?? state.user!.connsCount,
        nodesCount: user.nodesCount ?? state.user!.nodesCount,
        isVerified: user.isVerified ?? state.user!.isVerified,
        postsCount: user.postsCount ?? state.user!.postsCount,
        updatedAt: user.updatedAt ?? state.user!.updatedAt,
        createdAt: user.createdAt ?? state.user!.createdAt,
        username: user.username ?? state.user!.username,
        lastSeen: user.lastSeen ?? state.user!.lastSeen,
        status: user.status ?? state.user!.status,
        avatar: user.avatar ?? state.user!.avatar,
        fname: user.fname ?? state.user!.fname,
        lname: user.lname ?? state.user!.lname,
        email: user.email ?? state.user!.email,
        id: user.id ?? state.user!.id,
      ),
    );
  }

  User? getUser() {
    return state.user;
  }

  Future<void> init() async {
    final String? tokenString = await SimpleStorage.getStringData('token');
    state = state.copyWith(ready: true, isAuthenticated: false);
    if (tokenString != null) setToken(tokenString);
  }

  Future<void> setToken(String token) async {
    SimpleStorage.saveStringData('token', token);
    final user = await userRepo.getUserFromToken();
    state = state.copyWith(
      token: token,
      isAuthenticated: true,
      user: user,
      ready: true,
    );
  }
}

final sessionProvider = StateNotifierProvider<SessionProvider, SessionModel>(
  (ref) {
    final userRepo = ref.watch(userRepoProvider);
    return SessionProvider(ref, userRepo);
  },
);
