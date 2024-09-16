import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:rootnode/app/constant/api.dart';
import 'package:rootnode/app/constant/font.dart';
import 'package:rootnode/helper/switch_route.dart';
import 'package:rootnode/model/user/user.dart';
import 'package:rootnode/screen/misc/message_screen.dart';

class MessengerCard extends ConsumerWidget {
  const MessengerCard({super.key, required this.node});
  final User node;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () => switchRouteByPush(context, MessageScreen(node: node)),
      child: Container(
        margin: const EdgeInsets.only(bottom: 5),
        color: Colors.white10,
        child: Slidable(
          direction: Axis.horizontal,
          endActionPane: _endActionPane(),
          startActionPane: _startActionPane(),
          child: ListTile(
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              margin: const EdgeInsets.only(top: 5),
              constraints: const BoxConstraints(maxWidth: 100, maxHeight: 60),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: _getColor(node.status ?? "unknown"),
              ),
              child: Text(
                node.status ?? "unknown",
                style: RootNodeFontStyle.labelSmall.copyWith(
                  color: const Color(0xFF111111),
                ),
              ),
            ),
            dense: true,
            contentPadding: const EdgeInsets.all(10),
            leading: CircleAvatar(
              foregroundColor: Colors.white10,
              backgroundColor: Colors.white10,
              foregroundImage: CachedNetworkImageProvider(
                  "${ApiConstants.baseUrl}/${node.avatar}"),
            ),
            title: Text(node.fullname, style: RootNodeFontStyle.title),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Thats so awesome! Thanks for the help",
                    style: RootNodeFontStyle.subtitle),
                Text("Sun at 4:30PM", style: RootNodeFontStyle.labelSmall),
              ],
            ),
            enableFeedback: true,
          ),
        ),
      ),
    );
  }

  Color _getColor(String stats) {
    switch (stats) {
      case "active":
        return Colors.lime[500]!;
      case "inactive":
        return Colors.grey[400]!;
      case "busy":
        return Colors.red[400]!;
      case "away":
        return Colors.yellow[400]!;
      default:
        return Colors.cyan[400]!;
    }
  }

  ActionPane _startActionPane() {
    return const ActionPane(
      extentRatio: 0.25,
      motion: ScrollMotion(),
      children: [
        SlidableAction(
          onPressed: null,
          backgroundColor: Colors.cyan,
          foregroundColor: Colors.white,
          icon: Icons.save,
          label: 'Save',
        ),
      ],
    );
  }

  ActionPane _endActionPane() {
    return const ActionPane(
      extentRatio: 0.25,
      motion: ScrollMotion(),
      children: [
        SlidableAction(
          onPressed: null,
          backgroundColor: Colors.cyan,
          foregroundColor: Colors.white,
          icon: Icons.save,
          label: 'Save',
        ),
      ],
    );
  }
}
