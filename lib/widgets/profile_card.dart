import 'package:avatar_glow/avatar_glow.dart';
import 'package:boxicons/boxicons.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:rootnode/app/constant/api.dart';
import 'package:rootnode/app/constant/font.dart';
import 'package:rootnode/helper/utils.dart';
import 'package:rootnode/model/user/user.dart';
import 'package:rootnode/widgets/buttons.dart';

class ProfileCard extends StatelessWidget {
  const ProfileCard({
    super.key,
    required this.user,
    required this.hasConn,
    required this.actions,
  });

  final User? user;
  final bool? hasConn;
  final List<RootNodeOutlinedButton> actions;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 80),
      height: 300,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.cyan,
        gradient: LinearGradient(
          colors: [
            Colors.cyan,
            Colors.cyan,
            Colors.cyan.withAlpha(100),
            Colors.transparent,
            Colors.transparent,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Wrap(
          direction: Axis.vertical,
          alignment: WrapAlignment.start,
          runAlignment: WrapAlignment.spaceEvenly,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 10,
          runSpacing: 10,
          children: [
            Stack(
              children: [
                user != null
                    ? CircleAvatar(
                        maxRadius: 48,
                        backgroundColor: Colors.white10,
                        foregroundImage: CachedNetworkImageProvider(
                          "${ApiConstants.baseUrl}/${user!.avatar!}",
                          cacheKey: user!.avatar,
                          maxHeight: 256,
                          maxWidth: 256,
                        ),
                      )
                    : const AvatarGlow(
                        endRadius: 48,
                        glowColor: Colors.white10,
                        child: SizedBox.shrink(),
                      ),
                user != null
                    ? Positioned(
                        right: 0,
                        bottom: 5,
                        child: user!.isVerified!
                            ? const Icon(Boxicons.bxs_check_circle,
                                size: 20, color: Colors.green)
                            : const Icon(Boxicons.bxs_error_circle,
                                size: 20, color: Colors.amber),
                      )
                    : const SizedBox.shrink()
              ],
            ),
            user != null
                ? Wrap(
                    direction: Axis.vertical,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: -2,
                    children: [
                      Text(
                        user!.fullname,
                        style: RootNodeFontStyle.header,
                      ),
                      Text(
                        "@${user!.username}",
                        style: RootNodeFontStyle.caption,
                      ),
                    ],
                  )
                : _getNamePlaceholder(),
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              alignment: WrapAlignment.spaceEvenly,
              spacing: 30,
              children: [
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  runSpacing: 5,
                  spacing: -10,
                  direction: Axis.vertical,
                  children: [
                    user != null
                        ? Text(Utils.humanizeNumber(user!.postsCount ?? 0),
                            style: RootNodeFontStyle.title)
                        : _getCountPlaceHolder(),
                    Text("POSTS", style: RootNodeFontStyle.label),
                  ],
                ),
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  runSpacing: 5,
                  spacing: -10,
                  direction: Axis.vertical,
                  children: [
                    user != null
                        ? Text(Utils.humanizeNumber(user!.storiesCount ?? 0),
                            style: RootNodeFontStyle.title)
                        : _getCountPlaceHolder(),
                    Text("STORYS", style: RootNodeFontStyle.label),
                  ],
                ),
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  runSpacing: 5,
                  spacing: -10,
                  direction: Axis.vertical,
                  children: [
                    user != null
                        ? Text(Utils.humanizeNumber(user!.connsCount ?? 0),
                            style: RootNodeFontStyle.title)
                        : _getCountPlaceHolder(),
                    Text("CONNS", style: RootNodeFontStyle.label),
                  ],
                ),
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  runSpacing: 5,
                  spacing: -10,
                  direction: Axis.vertical,
                  children: [
                    user != null
                        ? Text(Utils.humanizeNumber(user!.nodesCount ?? 0),
                            style: RootNodeFontStyle.title)
                        : _getCountPlaceHolder(),
                    Text("NODES", style: RootNodeFontStyle.label),
                  ],
                )
              ],
            ),
            user != null
                ? Wrap(
                    spacing: 10,
                    runAlignment: WrapAlignment.center,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    alignment: WrapAlignment.spaceEvenly,
                    runSpacing: 10,
                    children: actions)
                : _getNamePlaceholder()
          ],
        ),
      ),
    );
  }

  Container _getCountPlaceHolder() {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      height: 20,
      width: 48,
      decoration: BoxDecoration(
          color: Colors.white24, borderRadius: BorderRadius.circular(10)),
    );
  }

  Container _getNamePlaceholder() {
    return Container(
      height: 48,
      width: 200,
      decoration: BoxDecoration(
          color: Colors.white24, borderRadius: BorderRadius.circular(10)),
    );
  }
}
