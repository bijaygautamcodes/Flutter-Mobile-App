import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:rootnode/app/constant/api.dart';
import 'package:rootnode/app/constant/font.dart';
import 'package:rootnode/model/user/user.dart';

class UserCard extends StatelessWidget {
  const UserCard({
    super.key,
    required this.user,
  });

  final User user;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      crossAxisAlignment: WrapCrossAlignment.center,
      alignment: WrapAlignment.center,
      children: [
        SizedBox(
          width: 50,
          height: 50,
          child: CircleAvatar(
            maxRadius: 20,
            backgroundColor: Colors.white10,
            foregroundImage: CachedNetworkImageProvider(
              "${ApiConstants.baseUrl}/${user.avatar!}",
              cacheKey: user.avatar,
              maxHeight: 256,
              maxWidth: 256,
            ),
          ),
        ),
        Wrap(
          direction: Axis.vertical,
          crossAxisAlignment: WrapCrossAlignment.start,
          runSpacing: 5,
          spacing: -3,
          children: [
            Text(
              user.fullname,
              style: RootNodeFontStyle.title,
            ),
            Text(
              "@${user.username}",
              style: RootNodeFontStyle.caption,
            ),
          ],
        )
      ],
    );
  }
}
