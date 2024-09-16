import 'package:boxicons/boxicons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rootnode/app/constant/font.dart';
import 'package:rootnode/data_source/remote_data_store/response/res_cmnt.dart';
import 'package:rootnode/model/comment/comment.dart';
import 'package:rootnode/model/post.dart';
import 'package:rootnode/model/user/user.dart';
import 'package:rootnode/provider/session_provider.dart';
import 'package:rootnode/repository/cmnt_repo.dart';
import 'package:rootnode/repository/post_repo.dart';
import 'package:rootnode/widgets/comment.dart';
import 'package:rootnode/widgets/comment_bar.dart';
import 'package:rootnode/widgets/posts.dart';

class CommentScreen extends ConsumerStatefulWidget {
  const CommentScreen({
    super.key,
    required this.id,
    required this.liked,
  });
  final String id;
  final bool liked;

  @override
  ConsumerState<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends ConsumerState<CommentScreen> {
  late final CommentRepo _cmntRepo;
  late final PostRepo _postRepo;
  late final ScrollController _controller;
  late User rootnode;
  Post? post;
  CommentResponse? commentResponse;
  final List<Comment> comments = [];
  List<bool> isLiked = [];
  late final bool isOwn;
  int currentPage = 1;
  int totalPages = 1;

  Future<void> _fetchPost() async =>
      post = await _postRepo.getPostById(id: widget.id);

  Future<void> _fetchComments() async =>
      commentResponse = await _cmntRepo.getPostComments(id: widget.id);

  Future<void> _refresh() async => {
        _fetchPost()
            .then((value) => _fetchComments().then((value) => setState(() {
                  setInitials();
                })))
      };

  void setInitials() {
    comments.clear();
    isLiked.clear();
    comments.addAll(commentResponse!.data!.comments ?? []);
    isLiked.addAll(commentResponse!.data!.meta!.isLiked ?? []);
    currentPage = commentResponse!.currentPage ?? 1;
    totalPages = commentResponse!.totalPages ?? 1;
  }

  void addUpdates(CommentResponse res) {
    comments.addAll(res.data!.comments ?? []);
    isLiked.addAll(res.data!.meta!.isLiked ?? []);
    currentPage = res.currentPage ?? 1;
    totalPages = res.totalPages ?? 1;
  }

  Future<void> _fetchMoreComments() async {
    if (currentPage < totalPages) {
      currentPage++;
      final res =
          await _cmntRepo.getPostComments(id: widget.id, page: currentPage);
      if (res == null) return;
      setState(() {
        addUpdates(res);
      });
      return;
    }
    currentPage = totalPages;
  }

  @override
  void initState() {
    _cmntRepo = ref.read(commentRepoProvider);
    _postRepo = ref.read(postRepoProvider);
    _controller = ScrollController()
      ..addListener(() {
        if (_controller.position.maxScrollExtent == _controller.offset) {
          _fetchMoreComments();
        }
      });
    rootnode = ref.read(sessionProvider.select((value) => value.user!));
    _fetchPost().then((value) => setState(() {
          isOwn = rootnode.id! == post!.owner!.id!;
        }));

    _fetchComments().then((value) {
      setInitials();
      setState(() {});
    });

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    rootnode = ref.watch(sessionProvider.select((value) => value.user!));
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Comment",
          style: RootNodeFontStyle.header,
        ),
        leadingWidth: 40,
        leading: IconButton(
          icon: const Icon(
            Boxicons.bx_chevron_left,
            color: Colors.white70,
            size: 40,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        commentResponse != null
            ? Expanded(
                child: ListView.builder(
                  controller: _controller,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return post != null
                          ? PostContainer(
                              post: post!,
                              likedMeta: widget.liked,
                              disableComment: true,
                            )
                          : Container(height: 200, color: Colors.white10);
                    }
                    return Padding(
                      padding: EdgeInsets.only(
                          bottom: index == comments.length ? 10 : 0),
                      child: Center(
                          child: CommentContainer(
                        isOwn: comments[index - 1].user!.id == rootnode.id,
                        comment: comments[index - 1],
                        isLiked: isLiked[index - 1],
                        onDelete: _refresh,
                      )),
                    );
                  },
                  itemCount: comments.length + 1,
                ),
              )
            : Expanded(
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return Container(
                        height: 200,
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        color: Colors.white10,
                      );
                    }
                    return Container(
                      height: 100,
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      color: Colors.white10,
                    );
                  },
                  itemCount: 5,
                ),
              ),
        BottomCommentBar(id: widget.id, onSuccess: _refresh),
      ]),
    );
  }
}
