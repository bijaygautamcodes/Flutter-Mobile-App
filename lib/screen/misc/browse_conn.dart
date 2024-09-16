import 'package:boxicons/boxicons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:rootnode/app/constant/font.dart';
import 'package:rootnode/helper/switch_route.dart';
import 'package:rootnode/model/user/user.dart';
import 'package:rootnode/repository/conn_repo.dart';
import 'package:rootnode/screen/misc/view_profile.dart';
import 'package:rootnode/widgets/placeholder.dart';
import 'package:rootnode/widgets/user_card.dart';

class BrowseConnScreen extends ConsumerStatefulWidget {
  const BrowseConnScreen({super.key});

  @override
  ConsumerState<BrowseConnScreen> createState() => _BrowseConnScreenState();
}

class _BrowseConnScreenState extends ConsumerState<BrowseConnScreen> {
  late User rootnode;
  late final ConnRepo _connRepo;
  late final ScrollController _scrollController;
  final List<User> random = [];
  int randomCurrentPage = 1;
  int randomTotalPage = 1;

  void _initRandom() async {
    random.clear();
    randomCurrentPage = 1;
    final randomResponse =
        await _connRepo.getRandomConns(page: randomCurrentPage, refresh: 1);
    if (randomResponse != null) {
      randomTotalPage = randomResponse.totalPages ?? 1;
      randomTotalPage > randomCurrentPage ? randomCurrentPage++ : null;
      random.addAll(randomResponse.users ?? []);
    }
    _smartSetState();
  }

  void _fetchMoreRandoms() async {
    if (randomCurrentPage >= randomTotalPage) return;
    final randomResponse =
        await _connRepo.getRecommendedConns(page: randomCurrentPage);
    if (randomResponse != null) {
      randomResponse.totalPages! > randomCurrentPage
          ? randomCurrentPage++
          : null;
      random.addAll(randomResponse.users ?? []);
      _smartSetState();
    }
  }

  _smartSetState() {
    WidgetsBinding.instance
        .addPostFrameCallback((timeStamp) => mounted ? setState(() {}) : null);
  }

  @override
  void initState() {
    _connRepo = ref.read(connRepoProvider);
    _scrollController = ScrollController()
      ..addListener(() {
        if (_scrollController.position.maxScrollExtent ==
            _scrollController.offset) {
          _fetchMoreRandoms();
        }
      });
    _initRandom();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: const Color(0xFF111111),
        child: RefreshIndicator(
          backgroundColor: Colors.cyan,
          color: const Color(0xFF111111),
          onRefresh: () async {
            _initRandom();
          },
          child: CustomScrollView(
            controller: _scrollController,
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverAppBar(
                stretch: true,
                pinned: true,
                leadingWidth: 40,
                expandedHeight: 180,
                collapsedHeight: 120,
                backgroundColor: const Color(0xFF111111),
                title: Text("Back", style: RootNodeFontStyle.header),
                flexibleSpace: FlexibleSpaceBar(
                  title: const SizedBox(height: 60, child: DummySearchField()),
                  titlePadding: const EdgeInsets.only(top: 10, bottom: 10),
                  collapseMode: CollapseMode.parallax,
                  stretchModes: const [
                    StretchMode.zoomBackground,
                    StretchMode.blurBackground
                  ],
                  background: Lottie.asset('assets/json/partical_orb.json',
                      fit: BoxFit.cover),
                  expandedTitleScale: 1,
                  centerTitle: true,
                ),
                leading: IconButton(
                  icon: const Icon(Boxicons.bx_chevron_left,
                      color: Colors.white70, size: 40),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
              SliverList(
                delegate: random.isNotEmpty
                    ? SliverChildBuilderDelegate(
                        (context, index) => GestureDetector(
                              onTap: () => switchRouteByPush(context,
                                  ProfileScreen(id: random[index].id!)),
                              child: Container(
                                height: 80,
                                color: Colors.white10,
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 20),
                                margin: EdgeInsets.only(
                                    bottom: 5, top: index == 0 ? 5 : 0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    UserCard(user: random[index]),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 2, horizontal: 10),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: Colors.black12),
                                      child: Wrap(
                                        crossAxisAlignment:
                                            WrapCrossAlignment.center,
                                        spacing: 5,
                                        children: [
                                          Icon(
                                            random[index].isVerified!
                                                ? Icons.verified_user
                                                : Icons.error,
                                            size: 20,
                                            color: random[index].isVerified!
                                                ? Colors.green
                                                : Colors.amber,
                                          ),
                                          Text(
                                              random[index].isVerified!
                                                  ? "verified"
                                                  : "unverified",
                                              style: RootNodeFontStyle.label)
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                        childCount: random.length)
                    : SliverChildListDelegate.fixed(_generateDummyListTile()),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Container> _generateDummyListTile() {
    return List<Container>.generate(
        6,
        (index) => Container(
              height: 80,
              color: Colors.white10,
              padding: const EdgeInsets.all(20),
              margin: EdgeInsets.only(bottom: 5, top: index == 0 ? 5 : 0),
            ));
  }
}
