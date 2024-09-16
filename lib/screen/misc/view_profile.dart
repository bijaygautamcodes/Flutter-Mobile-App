import 'package:boxicons/boxicons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rootnode/app/constant/font.dart';
import 'package:rootnode/data_source/remote_data_store/response/res_post.dart';
import 'package:rootnode/data_source/remote_data_store/response/res_story.dart';
import 'package:rootnode/helper/responsive_helper.dart';
import 'package:rootnode/helper/switch_route.dart';
import 'package:rootnode/model/post.dart';
import 'package:rootnode/model/story.dart';
import 'package:rootnode/model/user/user.dart';
import 'package:rootnode/provider/connection_provider.dart';
import 'package:rootnode/provider/session_provider.dart';
import 'package:rootnode/repository/conn_repo.dart';
import 'package:rootnode/repository/post_repo.dart';
import 'package:rootnode/repository/story_repo.dart';
import 'package:rootnode/repository/user_repo.dart';
import 'package:rootnode/screen/misc/edit_profile.dart';
import 'package:rootnode/screen/misc/message_screen.dart';
import 'package:rootnode/widgets/buttons.dart';
import 'package:rootnode/widgets/placeholder.dart';
import 'package:rootnode/widgets/posts.dart';
import 'package:rootnode/widgets/profile_card.dart';
import 'package:rootnode/widgets/stories.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key, required this.id, this.isOwn = false});
  final String id;
  final bool isOwn;

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  late User rootnode;
  late final UserRepo _userRepo;
  late final StoryRepo _storyRepo;
  late final ConnRepo _connRepo;
  late final PostRepo _postRepo;
  late PostResponse? _postResponse;
  User? user;
  double maxContentWidth = 720;

  late final ScrollController _storyScrollController;
  late final ScrollController _postScrollController;
  late StoryResponse? _storyResponse;
  late int storyTotal;

  final List<Story> _stories = [];
  int storyPage = 1;

  final List<Post> _posts = [];
  final List<bool> _postsLiked = [];
  late int totalPage;
  int currentPage = 1;

  bool noPost = false;
  bool noStory = false;

  bool? hasConn;

  _fetchFollowData() async {
    hasConn = await _connRepo.hasConnection(id: widget.id);
    if (mounted) setState(() {});
  }

  _fetchUser() async {
    user = await _userRepo.getUserById(widget.id);
    if (mounted) setState(() {});
  }

  void _getInitialStoryData() async {
    _storyResponse = await _storyRepo.getStoryByUser(
        page: storyPage, refresh: 1, id: widget.id);
    if (_storyResponse!.stories!.isEmpty) noStory = true;
    setState(() {
      _stories.addAll(_storyResponse!.stories!);
      storyTotal = _storyResponse!.totalPages!;
    });
  }

  void _fetchMoreStoryData() async {
    if (storyPage == storyTotal) return;
    storyPage = storyPage == storyTotal ? storyTotal : storyPage + 1;
    _storyResponse = await _storyRepo.getStoryByUser(
        page: storyPage, refresh: 0, id: widget.id);
    setState(() {
      _stories.addAll(_storyResponse!.stories!);
    });
  }

  void _clearInitials() async {
    setState(() {
      _posts.clear();
      _postsLiked.clear();
      currentPage = 1;
    });
  }

  void _getInitialData({int refresh = 0}) async {
    _postResponse = await _postRepo.getPostByUser(
        page: currentPage, refresh: refresh, id: widget.id);
    if (_postResponse!.data!.posts!.isEmpty) noPost = true;
    _posts.addAll(_postResponse!.data!.posts ?? []);
    _postsLiked.addAll(_postResponse!.data!.meta!.isLiked ?? []);
    totalPage = _postResponse!.totalPages ?? 1;
    // runs after stretch animation finishes
    WidgetsBinding.instance
        .addPostFrameCallback((timeStamp) => mounted ? setState(() {}) : null);
  }

  void _fetchMoreData() async {
    bool condn = currentPage >= totalPage;
    if (condn) return;

    condn ? currentPage = totalPage : currentPage++;

    _postResponse = await _postRepo.getPostByUser(
        page: currentPage, refresh: 0, id: widget.id);
    totalPage = _postResponse!.totalPages ?? 1;
    _posts.addAll(_postResponse!.data!.posts ?? []);
    _postsLiked.addAll(_postResponse!.data!.meta!.isLiked ?? []);
    if (mounted) setState(() {});
  }

  @override
  void initState() {
    _connRepo = ref.read(connRepoProvider);
    _postRepo = ref.read(postRepoProvider);
    _storyRepo = ref.read(storyRepoProvider);
    _userRepo = ref.read(userRepoProvider);
    _getInitialData();
    _postScrollController = ScrollController()
      ..addListener(() {
        if (_postScrollController.position.maxScrollExtent ==
            _postScrollController.offset) {
          _fetchMoreData();
        }
      });
    _fetchFollowData();
    _fetchUser();
    _storyScrollController = ScrollController()
      ..addListener(() {
        if (_storyScrollController.position.maxScrollExtent ==
            _storyScrollController.offset) {
          _fetchMoreStoryData();
        }
      });
    _getInitialStoryData();
    super.initState();
  }

  @override
  void dispose() {
    _storyScrollController.dispose();
    _postScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    rootnode = ref.watch(sessionProvider.select((value) => value.user!));
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: const Color(0xFF111111),
        child: RefreshIndicator(
          backgroundColor: const Color(0xFF111111),
          color: Colors.cyan,
          onRefresh: () async {
            _clearInitials();
            _getInitialData(refresh: 1);
          },
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(
                decelerationRate: ScrollDecelerationRate.normal),
            controller: _postScrollController,
            slivers: [
              SliverAppBar(
                stretch: true,
                pinned: true,
                leadingWidth: 40,
                expandedHeight: 350 + 134,
                collapsedHeight: 180,
                backgroundColor: const Color(0xFF111111),
                title: Text("Back", style: RootNodeFontStyle.header),
                flexibleSpace: FlexibleSpaceBar(
                  expandedTitleScale: 1,
                  titlePadding: EdgeInsets.zero,
                  title: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                    decoration: const BoxDecoration(
                        gradient: LinearGradient(
                      colors: [
                        Color(0xFF111111),
                        Color(0xFF111111),
                        Color(0x55111111),
                        Colors.transparent,
                      ],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    )),
                    width: double.infinity,
                    height: 124 + 20,
                    child: noStory
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: const MediaEmpty(
                                icon: Icons.error, message: "No story posted"),
                          )
                        : ListView.builder(
                            controller: _storyScrollController,
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 0, vertical: 10.0),
                            itemCount: _stories.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 4.0),
                                child: StoryCard(
                                    disableBorder: true,
                                    hideName: true,
                                    stories: _stories,
                                    index: index + 1,
                                    color: Color(_stories[index].color!),
                                    story: _stories[index]),
                              );
                            },
                          ),
                  ),
                  collapseMode: CollapseMode.parallax,
                  stretchModes: const [StretchMode.blurBackground],
                  background: Consumer(builder: (context, ref, child) {
                    return ProfileCard(
                      actions: _actionButtons(ref),
                      hasConn: hasConn,
                      user: widget.isOwn ? rootnode : user,
                    );
                  }),
                  centerTitle: true,
                ),
                leading: IconButton(
                  icon: const Icon(Boxicons.bx_chevron_left,
                      color: Colors.white70, size: 40),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
              _posts.isEmpty && !noPost
                  ? SliverToBoxAdapter(
                      child: SizedBox(
                          width: double.infinity,
                          child: Column(
                            children: const [
                              PostShimmer(),
                              PostShimmer(isMedia: true, isText: false),
                              PostShimmer(isMedia: true),
                            ],
                          )),
                    )
                  : noPost
                      ? SliverToBoxAdapter(
                          child: Container(
                            clipBehavior: Clip.antiAlias,
                            width: double.infinity,
                            height: 200,
                            margin: const EdgeInsets.all(10),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20)),
                            child: const MediaEmpty(
                                icon: Boxicons.bx_border_none,
                                message: "Wow! Such empty"),
                          ),
                        )
                      : SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              return index < _posts.length
                                  ? ConstrainedSliverWidth(
                                      maxWidth: maxContentWidth,
                                      child: PostContainer(
                                          isOwn: rootnode.id ==
                                              _posts[index].owner!.id,
                                          post: _posts[index],
                                          likedMeta: _postsLiked[index]),
                                    )
                                  : PostLoader(
                                      page: currentPage,
                                      total: totalPage,
                                    );
                            },
                            childCount: _posts.length + 1,
                          ),
                        )
            ],
          ),
        ),
      ),
    );
  }

  _toggleFollow(WidgetRef ref) async {
    bool? res = await _connRepo.toggleConnection(id: widget.id);
    ref.read(connOverviewProvider.notifier).fetchOverview();
    if (res != null) {
      setState(() {
        hasConn = res;
      });
    }
  }

  List<RootNodeOutlinedButton> _actionButtons(WidgetRef ref) {
    return [
      RootNodeOutlinedButton(
        onPressed: () => debugPrint("Share Button Pressed!"),
        child: Text("Share", style: RootNodeFontStyle.body),
      ),
      RootNodeOutlinedButton(
        onPressed: () async {
          if (widget.id == rootnode.id!) {
            debugPrint("Edit Button Pressed!");
            switchRouteByPush(context, EditProfile(user: rootnode));
          } else {
            _toggleFollow(ref);
            debugPrint("Follow Button Pressed!");
          }
        },
        child: hasConn != null
            ? widget.id != rootnode.id
                ? Text(hasConn! ? "Unfollow" : "Follow",
                    style: RootNodeFontStyle.body)
                : Text("Edit", style: RootNodeFontStyle.body)
            : const SizedBox.shrink(),
      ),
      RootNodeOutlinedButton(
        onPressed: () =>
            switchRouteByPushReplace(context, MessageScreen(node: user!)),
        child:
            const Icon(Boxicons.bxs_message_square_dots, color: Colors.white54),
      ),
    ];
  }
}
