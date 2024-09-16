import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rootnode/app/constant/font.dart';
import 'package:rootnode/data_source/remote_data_store/response/res_post.dart';
import 'package:rootnode/helper/responsive_helper.dart';
import 'package:rootnode/model/post.dart';
import 'package:rootnode/model/user/user.dart';
import 'package:rootnode/provider/session_provider.dart';
import 'package:rootnode/repository/post_repo.dart';
import 'package:rootnode/widgets/placeholder.dart';
import 'package:rootnode/widgets/posts.dart';
import 'package:rootnode/widgets/stories.dart';

class HomeScreen extends ConsumerStatefulWidget {
  static const String route = "home";
  const HomeScreen({
    super.key,
  });

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with TickerProviderStateMixin {
  late User rootnode;
  late final PostRepo _postRepo;
  late final ScrollController _scrollController;
  late final TabController _tabController;
  bool privateFeed = false;
  bool postScopeDisabled = false;

  late PostResponse? _postResponse;

  List<Post> _posts = [];
  List<bool> _postsLiked = [];

  final List<Post> _publicFeed = [];
  final List<Post> _privateFeed = [];
  late int privateTotal;
  late int publicTotal;
  int privatePage = 1;
  int publicPage = 1;

  double maxContentWidth = 720;

  void _clearInitials() async {
    setState(() {
      _posts.clear();
      privateFeed ? _privateFeed.clear() : _publicFeed.clear();
      privateFeed ? privatePage = 1 : publicPage = 1;
    });
  }

  Future<void> _getInitialData({int refresh = 0}) async {
    _postResponse = await _postRepo.getPostFeed(
      page: privateFeed ? privatePage : publicPage,
      refresh: refresh,
      private: privateFeed,
    );
    Future.delayed(const Duration(seconds: 1), () {
      privateFeed
          ? _privateFeed.addAll(_postResponse!.data!.posts!)
          : _publicFeed.addAll(_postResponse!.data!.posts!);
      privateFeed
          ? privateTotal = _postResponse!.totalPages!
          : publicTotal = _postResponse!.totalPages!;
      _posts = privateFeed ? _privateFeed : _publicFeed;
      _postsLiked = _postResponse!.data!.meta!.isLiked!;
      setState(() {
        postScopeDisabled = false;
      });
    });
  }

  void _fetchMoreData() async {
    if (postScopeDisabled) return;
    bool condn =
        privateFeed ? privatePage == privateTotal : publicPage == publicTotal;
    if (condn) return;
    privateFeed
        ? privatePage == privateTotal
            ? privatePage = privateTotal
            : privatePage++
        : publicPage == publicTotal
            ? publicTotal
            : publicPage++;
    _postResponse = await _postRepo.getPostFeed(
      page: privateFeed ? privatePage : publicPage,
      refresh: 0,
      private: privateFeed,
    );
    Future.delayed(const Duration(seconds: 1)).then((value) {
      privateFeed
          ? _privateFeed.addAll(_postResponse!.data!.posts!)
          : _publicFeed.addAll(_postResponse!.data!.posts!);
      _posts = privateFeed ? _privateFeed : _publicFeed;
      _postsLiked.addAll(_postResponse!.data!.meta!.isLiked!);
      setState(() {});
    });
  }

  @override
  void initState() {
    _postRepo = ref.read(postRepoProvider);
    _scrollController = ScrollController();
    _tabController = TabController(length: 2, vsync: this);
    _getInitialData().then((value) => setState(() {}));
    _scrollController.addListener(() {
      if (_scrollController.position.maxScrollExtent ==
          _scrollController.offset) {
        _fetchMoreData();
      }
    });
    super.initState();
  }

  void _switchPostScope(value) {
    if (postScopeDisabled) {
      return setState(() {
        _tabController.index = privateFeed ? 1 : 0;
      });
    }

    postScopeDisabled = true;
    _clearInitials();
    privateFeed = value == 0 ? false : true;
    _getInitialData();
    setState(() {});
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    rootnode = ref.watch(sessionProvider.select((value) => value.user!));
    return RefreshIndicator(
      color: Colors.cyan,
      backgroundColor: Colors.transparent,
      onRefresh: () async {
        _clearInitials();
        _getInitialData(refresh: 1);
      },
      child: CustomScrollView(
        controller: _scrollController,
        physics: _posts.isEmpty ? const NeverScrollableScrollPhysics() : null,
        slivers: [
          SliverToBoxAdapter(
            child: ConstrainedSliverWidth(
              maxWidth: maxContentWidth,
              child: const DummySearchField(),
            ),
          ),
          SliverToBoxAdapter(
            child: ConstrainedSliverWidth(
              maxWidth: maxContentWidth,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: StoriesWidget(currentUser: rootnode),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: ConstrainedSliverWidth(
              maxWidth: maxContentWidth,
              child: Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                decoration: BoxDecoration(
                    color: Colors.white10,
                    borderRadius: BorderRadius.circular(20)),
                child: TabBar(
                  enableFeedback: true,
                  overlayColor: MaterialStateProperty.resolveWith(
                      (states) => Colors.transparent),
                  onTap: (value) => _switchPostScope(value),
                  labelColor: Colors.white70,
                  indicatorColor:
                      postScopeDisabled ? Colors.white30 : Colors.cyan,
                  indicatorPadding: const EdgeInsets.all(10),
                  indicatorSize: TabBarIndicatorSize.label,
                  labelStyle: RootNodeFontStyle.body,
                  unselectedLabelColor: Colors.white30,
                  splashFactory: NoSplash.splashFactory,
                  isScrollable: false,
                  dividerColor: Colors.transparent,
                  padding: EdgeInsets.zero,
                  controller: _tabController,
                  tabs: const [Tab(text: "Public"), Tab(text: "Mutual")],
                ),
              ),
            ),
          ),
          _posts.isEmpty
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
              : SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return index < _posts.length
                          ? ConstrainedSliverWidth(
                              maxWidth: maxContentWidth,
                              child: PostContainer(
                                  isOwn: rootnode.id == _posts[index].owner!.id,
                                  post: _posts[index],
                                  likedMeta: _postsLiked[index]),
                            )
                          : PostLoader(
                              page: privateFeed ? privatePage : publicPage,
                              total: privateFeed ? privateTotal : publicTotal,
                            );
                    },
                    childCount: _posts.length + 1,
                  ),
                )
        ],
        // POST
      ),
    );
  }
}
