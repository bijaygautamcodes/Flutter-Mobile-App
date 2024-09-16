// ignore_for_file: use_build_context_synchronously

import 'package:boxicons/boxicons.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:like_button/like_button.dart';
import 'package:rootnode/app/constant/api.dart';
import 'package:rootnode/app/constant/font.dart';
import 'package:rootnode/app/constant/layout.dart';
import 'package:rootnode/app/utils/snackbar.dart';
import 'package:rootnode/helper/utils.dart';
import 'package:rootnode/model/comment/comment.dart';
import 'package:rootnode/repository/cmnt_repo.dart';

class CommentContainer extends StatelessWidget {
  const CommentContainer(
      {super.key,
      required this.comment,
      this.isOwn = false,
      required this.isLiked,
      required this.onDelete});
  final Comment comment;
  final bool isLiked;
  final bool isOwn;
  final Function onDelete;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Stack(
        fit: StackFit.loose,
        children: [
          Container(
            margin: const EdgeInsets.only(left: 5),
            height: 50,
            width: MediaQuery.of(context).size.width * 0.5,
            decoration: BoxDecoration(
                color: const Color(0xFF252525),
                borderRadius: BorderRadius.circular(40)),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    left: 10, right: 0, top: 5, bottom: 5),
                child: CircleAvatar(
                  backgroundColor: Colors.white10,
                  foregroundColor: Colors.white10,
                  foregroundImage: CachedNetworkImageProvider(
                    "${ApiConstants.baseUrl}/${comment.user!.avatar!}",
                    cacheKey: comment.user!.avatar,
                    maxHeight: 256,
                    maxWidth: 256,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Consumer(builder: (context, ref, child) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.8),
                      margin: const EdgeInsets.only(left: 0, right: 10),
                      padding: LayoutConstants.postPaddingTLR,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: const Color(0xFF333333),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                comment.user!.fullname,
                                style: RootNodeFontStyle.title,
                              ),
                              Wrap(
                                spacing: 5,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  Text(
                                    Utils.getTimeAgo(comment.createdAt!),
                                    textAlign: TextAlign.center,
                                    style: RootNodeFontStyle.label,
                                  ),
                                  SizedBox(
                                    height: 24,
                                    width: 24,
                                    child: PopupMenuButton<int>(
                                      shadowColor: Colors.white,
                                      splashRadius: 24,
                                      offset: const Offset(0, 32),
                                      padding: EdgeInsets.zero,
                                      color: Colors.white70,
                                      surfaceTintColor: Colors.transparent,
                                      enableFeedback: true,
                                      elevation: 2,
                                      icon: const Icon(
                                        Boxicons.bx_dots_vertical_rounded,
                                        size: LayoutConstants.postIcon,
                                      ),
                                      onSelected: (value) =>
                                          _handleThreeDots(context, value, ref),
                                      itemBuilder: (BuildContext context) =>
                                          <PopupMenuItem<int>>[
                                        isOwn
                                            ? const PopupMenuItem<int>(
                                                height: 24,
                                                value: -1,
                                                child: Text('Remove'))
                                            : const PopupMenuItem<int>(
                                                height: 24,
                                                value: 1,
                                                child: Text('Report')),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.only(
                                left: 5, top: 5, bottom: 10, right: 5),
                            child: Text(
                              comment.comment!,
                              softWrap: true,
                              overflow: TextOverflow.visible,
                              style:
                                  RootNodeFontStyle.body.copyWith(height: 1.2),
                            ),
                          ),
                          const SizedBox(height: 5)
                        ],
                      ),
                    ),
                    Wrap(
                      spacing: 5,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 10, left: 10),
                          child: LikeButton(
                            onTap: (isLiked) => _toggleCommentLike(ref),
                            isLiked: isLiked,
                            size: LayoutConstants.postIcon,
                            likeCount: comment.likesCount,
                            padding: const EdgeInsets.only(right: 10),
                            likeBuilder: (isLiked) {
                              return isLiked
                                  ? const Icon(
                                      Boxicons.bxs_like,
                                      color: Colors.white70,
                                      size: 18,
                                    )
                                  : const Icon(
                                      Boxicons.bx_like,
                                      color: Colors.white70,
                                      size: 18,
                                    );
                            },
                            likeCountPadding:
                                const EdgeInsets.only(top: 2, left: 8.0),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: LikeButton(
                            // onTap: (isLiked) => _toggleCommentLike(),
                            isLiked: false,
                            size: LayoutConstants.postIcon,
                            likeCount: 0,
                            padding: const EdgeInsets.only(right: 10),
                            likeBuilder: (isLiked) {
                              return isLiked
                                  ? const Icon(
                                      Boxicons.bxs_share,
                                      color: Colors.white70,
                                      size: 20,
                                    )
                                  : const Icon(
                                      Boxicons.bx_share,
                                      color: Colors.white70,
                                      size: 20,
                                    );
                            },
                            likeCountPadding:
                                const EdgeInsets.only(top: 2, left: 8.0),
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              }),
            ],
          ),
        ],
      ),
    );
  }

  Future<bool?> _toggleCommentLike(WidgetRef ref) async {
    final commentRepo = ref.read(commentRepoProvider);
    return await commentRepo.toggleCommentLike(id: comment.id!);
  }

  _handleThreeDots(BuildContext context, int value, WidgetRef ref) async {
    if (value == -1) {
      final commentRepo = ref.read(commentRepoProvider);
      bool res = await commentRepo.deleteCommentById(id: comment.id!);
      res
          ? onDelete()
          : showSnackbar(context, "Something went wrong", Colors.red[400]!);
    }
  }
}
