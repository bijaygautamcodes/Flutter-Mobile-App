import 'package:boxicons/boxicons.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:like_button/like_button.dart';
import 'package:rootnode/app/constant/api.dart';
import 'package:rootnode/app/constant/font.dart';
import 'package:rootnode/app/constant/layout.dart';
import 'package:rootnode/app/utils/snackbar.dart';
import 'package:rootnode/helper/switch_route.dart';
import 'package:rootnode/helper/utils.dart';
import 'package:rootnode/model/post.dart';
import 'package:rootnode/model/user/user.dart';
import 'package:rootnode/provider/session_provider.dart';
import 'package:rootnode/repository/post_repo.dart';
import 'package:rootnode/screen/misc/comment_screen.dart';
import 'package:rootnode/screen/misc/view_post_media.dart';
import 'package:rootnode/widgets/placeholder.dart';
import 'package:shimmer/shimmer.dart';

import 'package:string_extensions/string_extensions.dart';

class PostContainer extends StatelessWidget {
  const PostContainer({
    Key? key,
    required this.post,
    required this.likedMeta,
    this.tagPrefix,
    this.compact = false,
    this.isOwn = false,
    this.disableComment = false,
  }) : super(key: key);

  final Post post;
  final bool likedMeta;
  final String? tagPrefix;
  final bool compact;
  final bool isOwn;
  final bool disableComment;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: LayoutConstants.postMarginTLR,
      decoration: const BoxDecoration(
        color: Colors.white10,
        borderRadius: LayoutConstants.postCardBorderRadius,
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _PostHeader(
          isOwn: isOwn,
          post: post,
          compact: compact,
        ),
        SizedBox(
          height: compact || post.caption == null ? 5 : 10,
        ),
        _PostBody(
          compact: compact,
          tagPrefix: tagPrefix,
          post: post,
          isLiked: likedMeta,
        ),
        const Divider(thickness: 3, color: Color(0xFF111111)),
        _PostFooter(
          disableComment: disableComment,
          compact: compact,
          post: post,
          likedMeta: likedMeta,
        )
      ]),
    );
  }
}

class _PostHeader extends ConsumerWidget {
  const _PostHeader({
    Key? key,
    required this.post,
    required this.compact,
    this.isOwn = false,
  }) : super(key: key);

  final Post post;
  final bool isOwn;
  final bool compact;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    User? rootnode;
    if (isOwn) {
      rootnode = ref.watch(sessionProvider.select((value) => value.user!));
    }
    return Padding(
      padding: LayoutConstants.postPaddingTLR,
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Container(
          height: 40,
          width: 40,
          clipBehavior: Clip.antiAlias,
          decoration: const BoxDecoration(
            color: Colors.white10,
            shape: BoxShape.circle,
          ),
          child: FadeInImage.assetNetwork(
            imageCacheWidth: 128,
            imageCacheHeight: 128,
            fit: BoxFit.cover,
            image: post.owner!.avatar != null
                ? "${ApiConstants.baseUrl}\\${isOwn ? rootnode!.avatar : post.owner!.avatar}"
                : "https://icon-library.com/images/anonymous-user-icon/anonymous-user-icon-2.jpg",
            placeholder: 'assets/images/image_grey.png',
            imageErrorBuilder: (context, error, stackTrace) =>
                Icon(Icons.broken_image, color: Colors.red[400]!),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Wrap(direction: Axis.vertical, spacing: -5, children: [
            compact
                ? Text(post.owner!.fname!.toTitleCase!,
                    style: RootNodeFontStyle.title)
                : Text(isOwn ? rootnode!.fullname : post.owner!.fullname,
                    style: RootNodeFontStyle.title),
            compact
                ? Text(
                    "${Utils.getTimeAgo(post.createdAt!)} ago",
                    textAlign: TextAlign.center,
                    style: RootNodeFontStyle.label,
                  )
                : Text(
                    "@${isOwn ? rootnode!.username : post.owner!.username!}",
                    style: RootNodeFontStyle.subtitle,
                  ),
          ]),
        ),
        compact
            ? const SizedBox.shrink()
            : Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 10,
                children: [
                  Text(
                    Utils.getTimeAgo(post.createdAt!),
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
                                height: 42, value: 0, child: Text('Edit'))
                            : const PopupMenuItem<int>(
                                height: 42, value: 1, child: Text('Report')),
                        isOwn
                            ? const PopupMenuItem<int>(
                                height: 42, value: -1, child: Text('Remove'))
                            : const PopupMenuItem<int>(
                                height: 42, value: -2, child: Text('Hide')),
                      ],
                    ),
                  ),
                ],
              )
      ]),
    );
  }

  _handleThreeDots(BuildContext context, int value, WidgetRef ref) {
    if (value == -1) {
      final postRepo = ref.read(postRepoProvider);
      postRepo.deletePost(id: post.id!).then((value) => value
          ? showSnackbar(context, "Deletion successful!", Colors.green[400]!)
          : showSnackbar(context, "Something went wrong!", Colors.red[400]!));
      return;
    }
    showSnackbar(context, "Coming soon!", const Color(0xFF555555));
  }
}

class _PostBody extends StatelessWidget {
  const _PostBody({
    Key? key,
    required this.post,
    required this.isLiked,
    this.tagPrefix,
    required this.compact,
  }) : super(key: key);

  final Post post;
  final bool isLiked;
  final String? tagPrefix;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal: compact ? 10 : LayoutConstants.postPadding),
          child: post.type == "markdown"
              ? MarkdownBody(
                  data: post.caption!,
                  selectable: true,
                  styleSheet: MarkdownStyleSheet(
                    h1: RootNodeFontStyle.body,
                    p: RootNodeFontStyle.subtitle,
                  ),
                )
              : Text(
                  post.caption ?? "",
                  softWrap: true,
                  style: RootNodeFontStyle.caption,
                ),
        ),
        post.mediaFiles.isNotEmpty
            ? Center(
                child: GestureDetector(
                  onTap: () => switchRouteByPush(
                      context,
                      ViewPost(
                        post: post,
                        likedMeta: isLiked,
                      )),
                  child: Container(
                    width: double.maxFinite,
                    clipBehavior: Clip.antiAlias,
                    decoration: const BoxDecoration(
                        borderRadius: LayoutConstants.postContentBorderRadius),
                    margin: EdgeInsets.all(
                        compact ? 10 : LayoutConstants.postInnerMargin),
                    child: AnimatedSize(
                      curve: Curves.easeInQuad,
                      duration: const Duration(milliseconds: 500),
                      child: post.mediaFiles.length == 1 &&
                              post.mediaFiles[0].type == "image"
                          ? Hero(
                              tag: post.id.toString(),
                              child: AspectRatio(
                                aspectRatio: 4 / 3,
                                child: PostImage(url: post.mediaFiles[0].url!),
                              ),
                            )
                          : Stack(
                              children: [
                                CarouselSlider(
                                  options: CarouselOptions(
                                    enableInfiniteScroll: false,
                                    disableCenter: true,
                                    enlargeCenterPage: true,
                                    enlargeStrategy:
                                        CenterPageEnlargeStrategy.scale,
                                    viewportFraction: 1,
                                  ),
                                  items: post.mediaFiles.map((e) {
                                    return Builder(
                                      key: PageStorageKey(key),
                                      builder: (BuildContext context) {
                                        return e.type! == 'image'
                                            ? Hero(
                                                tag: tagPrefix != null
                                                    ? '$tagPrefix-${post.id!}'
                                                    : post.id!,
                                                child: PostImage(url: e.url!))
                                            : Container(color: Colors.cyan);
                                      },
                                    );
                                  }).toList(),
                                ),
                                const Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: Padding(
                                    padding: EdgeInsets.all(10),
                                    child: Icon(
                                      Boxicons.bx_images,
                                      size: 20,
                                      color: Colors.white54,
                                    ),
                                  ),
                                )
                              ],
                            ),
                    ),
                  ),
                ),
              )
            : SizedBox(height: post.caption != null ? 10 : 0),
      ],
    );
  }
}

class PostImage extends StatelessWidget {
  const PostImage({
    super.key,
    required this.url,
    this.tagPrefix,
  });

  final String url;
  final String? tagPrefix;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
      constraints: const BoxConstraints(maxHeight: 300, minHeight: 0),
      child: CachedNetworkImage(
        maxWidthDiskCache: 500,
        imageUrl: "${ApiConstants.baseUrl}/$url",
        fit: BoxFit.cover,
        errorWidget: (context, url, error) => const MediaError(
          icon: Icons.broken_image,
        ),
        progressIndicatorBuilder: (context, url, progress) => MediaLoading(
          label: "Loading Image",
          icon: Boxicons.bx_image,
          progress: progress,
        ),
      ),
    );
  }
}

class _PostFooter extends ConsumerStatefulWidget {
  const _PostFooter({
    Key? key,
    required this.post,
    required this.likedMeta,
    required this.compact,
    required this.disableComment,
  }) : super(key: key);

  final Post post;
  final bool likedMeta;
  final bool compact;
  final bool disableComment;

  @override
  ConsumerState<_PostFooter> createState() => _PostFooterState();
}

class _PostFooterState extends ConsumerState<_PostFooter> {
  late final PostRepo _postRepo;
  bool liking = false;
  Future<bool> togglePostLike() async {
    if (liking) return !widget.likedMeta;
    liking = true;
    bool res = await _postRepo.togglePostLike(id: widget.post.id!);
    liking = false;
    return res;
  }

  @override
  void initState() {
    _postRepo = ref.read(postRepoProvider);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: LayoutConstants.postActionPadding,
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Wrap(spacing: 20, children: [
          LikeButton(
            onTap: (isLiked) => togglePostLike(),
            isLiked: widget.likedMeta,
            size: LayoutConstants.postIcon,
            likeCount: widget.post.likesCount,
            likeBuilder: (isLiked) {
              return isLiked
                  ? const Icon(
                      Boxicons.bxs_like,
                      color: Colors.white70,
                      size: 22,
                    )
                  : const Icon(
                      Boxicons.bx_like,
                      color: Colors.white70,
                      size: 22,
                    );
            },
            likeCountPadding: const EdgeInsets.only(top: 2, left: 8.0),
          ),
          GestureDetector(
            onTap: () {
              if (widget.disableComment) return;
              switchRouteByPush(
                  context,
                  CommentScreen(
                    liked: widget.likedMeta,
                    id: widget.post.id!,
                  ));
            },
            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 8,
              children: [
                const Icon(
                  Boxicons.bx_message_square_detail,
                  color: Colors.white70,
                  size: 22,
                ),
                Text("${widget.post.commentsCount}",
                    style: RootNodeFontStyle.label)
              ],
            ),
          ),
        ]),
        widget.compact
            ? const SizedBox.shrink()
            : const Icon(
                Boxicons.bx_share,
                color: Colors.white70,
                size: 22,
              )
      ]),
    );
  }
}

class PostLoader extends StatelessWidget {
  const PostLoader({
    Key? key,
    required this.page,
    required this.total,
  }) : super(key: key);

  final int page;
  final int total;

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Padding(
        padding: const EdgeInsets.all(20),
        child: page == total
            ? const Text(
                "all caught up !",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white70),
              )
            : const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  color: Colors.white10,
                ),
              ),
      ),
    ]);
  }
}

class PostShimmer extends StatelessWidget {
  const PostShimmer({super.key, this.isText = true, this.isMedia = false});
  final bool isText;
  final bool isMedia;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: LayoutConstants.postMarginTLR,
      padding: const EdgeInsets.only(top: 5),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: LayoutConstants.postCardBorderRadius,
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        RootNodeShimmer(
          child: Padding(
            padding: LayoutConstants.postPaddingTLR,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 40,
                  width: 40,
                  decoration: const BoxDecoration(
                    color: Colors.white10,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Wrap(direction: Axis.vertical, spacing: 6, children: [
                    Container(
                      height: 18,
                      constraints: const BoxConstraints(maxWidth: 200),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: Colors.white10,
                      ),
                    ),
                    Container(
                      height: 12,
                      constraints: const BoxConstraints(maxWidth: 150),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(3),
                        color: Colors.white10,
                      ),
                    ),
                  ]),
                ),
              ],
            ),
          ),
        ),
        RootNodeShimmer(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            isText
                ? Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: LayoutConstants.postPadding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 14),
                          height: 14,
                          constraints: const BoxConstraints(maxWidth: 300),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(3),
                            color: Colors.white10,
                          ),
                        ),
                        Container(
                          height: 14,
                          margin: const EdgeInsets.only(top: 5),
                          constraints: const BoxConstraints(maxWidth: 200),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(3),
                            color: Colors.white10,
                          ),
                        ),
                      ],
                    ),
                  )
                : const SizedBox.shrink(),
            isMedia
                ? Center(
                    child: Container(
                      width: double.maxFinite,
                      clipBehavior: Clip.antiAlias,
                      decoration: const BoxDecoration(
                          borderRadius:
                              LayoutConstants.postContentBorderRadius),
                      margin:
                          const EdgeInsets.all(LayoutConstants.postInnerMargin),
                      child: AspectRatio(
                        aspectRatio: 4 / 3,
                        child: Container(
                          color: Colors.white10,
                        ),
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
          ]),
        ),
        SizedBox(height: isMedia ? 0 : 10),
        const Divider(thickness: 3, color: Color(0xFF111111)),
        Padding(
          padding: LayoutConstants.postActionPadding,
          child: RootNodeShimmer(
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Wrap(spacing: 20, children: [
                    Container(
                      height: 24,
                      width: 32,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(3),
                        color: Colors.white10,
                      ),
                    ),
                    Container(
                      height: 24,
                      width: 32,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(3),
                        color: Colors.white10,
                      ),
                    ),
                  ]),
                  Container(
                    height: 24,
                    width: 32,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(3),
                      color: Colors.white10,
                    ),
                  ),
                ]),
          ),
        )
      ]),
    );
  }
}

class RootNodeShimmer extends StatelessWidget {
  const RootNodeShimmer({super.key, required this.child, this.darkmode = true});
  final Widget child;
  final bool darkmode;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: darkmode ? Colors.white24 : Colors.grey.shade900,
      highlightColor: Colors.white54,
      child: child,
    );
  }
}
