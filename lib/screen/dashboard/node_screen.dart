import 'package:avatar_glow/avatar_glow.dart';
import 'package:boxicons/boxicons.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rootnode/app/constant/api.dart';
import 'package:rootnode/app/constant/font.dart';
import 'package:rootnode/data_source/remote_data_store/response/res_conn.dart';
import 'package:rootnode/helper/responsive_helper.dart';
import 'package:rootnode/helper/switch_route.dart';
import 'package:rootnode/helper/utils.dart';
import 'package:rootnode/model/user/user.dart';
import 'package:rootnode/provider/connection_provider.dart';
import 'package:rootnode/provider/session_provider.dart';
import 'package:rootnode/repository/conn_repo.dart';
import 'package:rootnode/screen/misc/browse_conn.dart';
import 'package:rootnode/screen/misc/view_conn.dart';
import 'package:rootnode/screen/misc/view_profile.dart';
import 'package:rootnode/widgets/placeholder.dart';

class NodeScreen extends ConsumerStatefulWidget {
  const NodeScreen({super.key});
  @override
  ConsumerState<NodeScreen> createState() => _NodeScreenState();
}

class _NodeScreenState extends ConsumerState<NodeScreen> {
  late User rootnode;
  late final ConnRepoImpl _connRepo;
  late final ScrollController _scrollController;
  late final ScrollController _recomScrollController;
  late final ScrollController _randomScrollController;

  final List<User> recom = [];
  int recomCurrentPage = 1;
  int recomTotalPage = 1;

  final List<User> random = [];
  int randomCurrentPage = 1;
  int randomTotalPage = 1;

  Future<void> _initRandom() async {
    random.clear();
    randomCurrentPage = 1;
    final randomResponse =
        await _connRepo.getRandomConns(page: randomCurrentPage, refresh: 1);
    if (randomResponse != null) {
      randomTotalPage = randomResponse.totalPages ?? 1;
      randomTotalPage > randomCurrentPage ? randomCurrentPage++ : null;
      random.addAll(randomResponse.users ?? []);
    }
  }

  Future<void> _initRecom() async {
    recom.clear();
    recomCurrentPage = 1;
    final recomResponse =
        await _connRepo.getRecommendedConns(page: recomCurrentPage, refresh: 1);
    if (recomResponse != null) {
      recomTotalPage = recomResponse.totalPages ?? 1;
      recomTotalPage > recomCurrentPage ? recomCurrentPage++ : null;
      recom.addAll(recomResponse.users ?? []);
      recomCurrentPage = recomResponse.currentPage ?? 1;
    }
  }

  void _fetchMoreRecom() async {
    if (recomCurrentPage >= recomTotalPage) return;
    final recomResponse =
        await _connRepo.getRecommendedConns(page: recomCurrentPage);
    if (recomResponse != null) {
      recomResponse.totalPages! > randomCurrentPage
          ? randomCurrentPage++
          : null;
      recom.addAll(recomResponse.users ?? []);
      setState(() {});
    }
  }

  void _fetchMoreRandom() async {
    if (randomCurrentPage >= randomTotalPage) return;
    final randomResponse =
        await _connRepo.getRecommendedConns(page: randomCurrentPage);
    if (randomResponse != null) {
      randomResponse.totalPages! > randomCurrentPage
          ? randomCurrentPage++
          : null;
      random.addAll(randomResponse.users ?? []);
      setState(() {});
    }
  }

  Future<void> _getRecomAndRandom() async {
    await _initRandom();
    await _initRecom();
  }

  @override
  void didUpdateWidget(covariant NodeScreen oldWidget) {
    if (mounted) {
      setState(() {});
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    _connRepo = ref.read(connRepoProvider);
    ref.read(connOverviewProvider.notifier).fetchOverview();
    _getRecomAndRandom().then((value) => setState(() {}));
    _scrollController = ScrollController();
    _randomScrollController = ScrollController()
      ..addListener(() {
        if (_randomScrollController.position.maxScrollExtent ==
            _randomScrollController.offset) {
          _fetchMoreRandom();
        }
      });
    _recomScrollController = ScrollController()
      ..addListener(() {
        if (_recomScrollController.position.maxScrollExtent ==
            _recomScrollController.offset) {
          _fetchMoreRecom();
        }
      });

    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _randomScrollController.dispose();
    _recomScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    rootnode = ref.watch(sessionProvider.select((value) => value.user!));
    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        const SliverToBoxAdapter(
            child: ConstrainedSliverWidth(
                maxWidth: 720, child: DummySearchField())),
        SliverToBoxAdapter(
          child: ConstrainedSliverWidth(
              maxWidth: 720, child: ConnOverview(user: rootnode)),
        ),
        SliverToBoxAdapter(
          child: ConstrainedSliverWidth(
            maxWidth: 720,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
              child: Text(
                "Discover",
                style: RootNodeFontStyle.header,
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: ConstrainedSliverWidth(
            maxWidth: 720,
            child: NewConnectionList(
              rootnode: rootnode,
              users: recom,
              scrollController: _recomScrollController,
              type: NewConnectionListType.recommended,
              title: "Recommended Nodes",
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: ConstrainedSliverWidth(
            maxWidth: 720,
            child: NewConnectionList(
              rootnode: rootnode,
              users: random,
              scrollController: _randomScrollController,
              type: NewConnectionListType.random,
              title: "Random Nodes",
            ),
          ),
        ),
      ],
    );
  }
}

enum NewConnectionListType { recommended, random }

class NewConnectionList extends StatelessWidget {
  const NewConnectionList({
    super.key,
    required ScrollController scrollController,
    required this.title,
    required this.type,
    required this.users,
    required this.rootnode,
  }) : _scrollController = scrollController;

  final ScrollController _scrollController;
  final String title;
  final NewConnectionListType type;
  final List<User> users;
  final User rootnode;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
            child: Text(title,
                style: RootNodeFontStyle.title
                    .copyWith(fontWeight: FontWeight.w400),
                textAlign: TextAlign.start),
          ),
          SizedBox(
            width: double.infinity,
            height: 128,
            child: users.isNotEmpty
                ? ListView.builder(
                    controller: _scrollController,
                    scrollDirection: Axis.horizontal,
                    itemCount: users.length,
                    itemBuilder: (context, index) =>
                        _card(users[index], context))
                : Container(
                    clipBehavior: Clip.antiAlias,
                    margin: const EdgeInsets.all(10),
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Colors.white10,
                        borderRadius: BorderRadius.circular(20)),
                    child: Wrap(
                      runAlignment: WrapAlignment.center,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      alignment: WrapAlignment.center,
                      direction: Axis.vertical,
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          spacing: 5,
                          children: [
                            const Icon(
                              Boxicons.bx_error,
                              color: Colors.cyan,
                              size: 20,
                            ),
                            Text(
                              "Oops!",
                              textAlign: TextAlign.center,
                              style: RootNodeFontStyle.caption.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.cyan),
                            ),
                          ],
                        ),
                        Text(
                          "Not many nodes to show at the time. \nTry adding some ${type == NewConnectionListType.random ? 'recommend' : 'random'} nodes.",
                          textAlign: TextAlign.center,
                          style: RootNodeFontStyle.caption,
                        )
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _card(User user, BuildContext context) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: Container(
                height: double.infinity,
                width: 110.0,
                color: Colors.transparent,
                child: CachedNetworkImage(
                  imageUrl: "${ApiConstants.baseUrl}/${user.avatar!}",
                  fit: BoxFit.cover,
                  errorWidget: (context, url, error) => const MediaError(
                    icon: Icons.broken_image,
                    minimal: true,
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 2,
                color: const Color(0xFF111111),
              ),
            ),
            Consumer(builder: (context, ref, child) {
              return GestureDetector(
                  onTap: () {
                    switchRouteByPush(context, ProfileScreen(id: user.id!));
                    debugPrint("Discover > User: ${user.fname}");
                  },
                  onLongPress: () => _toggleFollow(ref, user.id!),
                  child: Container(
                    alignment: Alignment.center,
                    height: double.infinity,
                    width: 110.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                          color: const Color(0xFF111111),
                          width: 1.0,
                          strokeAlign: BorderSide.strokeAlignOutside),
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF111111),
                          Colors.transparent,
                        ],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                    ),
                  ));
            }),
            Positioned(
              bottom: 8.0,
              left: 8.0,
              right: 8.0,
              child: Text(
                user.fullnameMin,
                style: RootNodeFontStyle.subtitle,
                overflow: TextOverflow.fade,
                textAlign: TextAlign.center,
                maxLines: 1,
              ),
            ),
          ],
        ),
      );

  _toggleFollow(WidgetRef ref, String id) async {
    final connRepo = ref.read(connRepoProvider);
    await connRepo.toggleConnection(id: id);
    ref.read(connOverviewProvider.notifier).fetchOverview();
  }
}

class ConnOverview extends ConsumerWidget {
  const ConnOverview({super.key, required this.user});
  final User user;

  List<Widget> _generateNodeAvatar(
      {required List<Node> nodes, bool isOld = true, int limit = 3}) {
    List<NodeAvatar>? dummys, generated;
    int length = nodes.length;
    int dummyCount = limit - length;
    if (dummyCount > 0) {
      dummys = _generateDummyAvatar(count: dummyCount, isOld: isOld);
    }
    if (isOld) {
      generated = nodes
          .map((e) => NodeAvatar(date: Utils.getTimeAgo(e.date!), user: e.user))
          .toList();
      generated.addAll(dummys ?? []);
      generated.insert(
          0, NodeAvatar(isOwn: true, user: user, date: "this", isAction: true));
      generated.last.settings['hideDate'] = true;
    } else {
      generated = nodes
          .map((e) => NodeAvatar(
              date: Utils.getTimeAgo(e.date!), user: e.user, invert: true))
          .toList();
      generated.insertAll(0, dummys ?? []);
      generated.add(NodeAvatar(date: "this.add", invert: true, isAction: true));
      generated.first.settings['hideDate'] = true;
    }
    return generated;
  }

  List<NodeAvatar> _generateDummyAvatar(
      {required int count, required bool isOld}) {
    return List<NodeAvatar>.generate(
        count,
        (index) => NodeAvatar(
              invert: !isOld,
              isDummy: true,
              date: "?",
            ));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(connOverviewProvider);
    return AnimatedContainer(
      width: double.infinity,
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Container(
        constraints: const BoxConstraints(maxHeight: 500),
        height: MediaQuery.of(context).size.width <= 480
            ? 300
            : MediaQuery.of(context).size.width * 0.5,
        // color: Colors.white10,
        child: Stack(
          alignment: Alignment.center,
          children: [
            SizedBox.expand(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                child: CustomPaint(
                  isComplex: true,
                  foregroundPainter: PolyLinePainter(),
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 100,
                  child: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 28),
                        child: SizedBox.expand(
                          child: CustomPaint(
                            foregroundPainter: LinePainter(),
                          ),
                        ),
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: _generateNodeAvatar(
                              nodes: state.old, limit: state.limit)),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(5),
                  child: GestureDetector(
                    onTap: () {
                      debugPrint("MyNodes");
                      switchRouteByPush(context, ViewConnScreen(user: user));
                    },
                    child: AvatarGlow(
                      endRadius: 35,
                      child: CircleAvatar(
                        backgroundColor: const Color(0xFFCCCCCC),
                        maxRadius: 25,
                        child: Text("+${state.count}",
                            style: RootNodeFontStyle.caption.copyWith(
                              color: const Color(0xFF111111),
                              fontWeight: FontWeight.bold,
                            )),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  height: 100,
                  child: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: SizedBox.expand(
                          child: CustomPaint(
                            foregroundPainter: LinePainter(),
                          ),
                        ),
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: _generateNodeAvatar(
                            nodes: state.recent,
                            isOld: false,
                            limit: state.limit,
                          )),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class NodeAvatar extends StatelessWidget {
  NodeAvatar({
    super.key,
    this.user,
    required this.date,
    this.invert = false,
    this.isDummy = false,
    this.isAction = false,
    this.isOwn = false,
  });
  final User? user;
  final String date;
  final bool invert;
  final bool isDummy;
  final bool isAction;
  final bool isOwn;
  final Map<String, bool> settings = {"hideDate": false};

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Stack(
        children: [
          Container(
            padding:
                EdgeInsets.only(bottom: !invert ? 20 : 0, top: invert ? 20 : 0),
            child: GestureDetector(
              onTap: () {
                debugPrint(
                    "User: ${isDummy ? 'Dummy Node' : user != null ? user!.fname : 'No user'} | Action: $isAction");
                if (isAction && user == null) {
                  switchRouteByPush(context, const BrowseConnScreen());
                }
                if (user != null) {
                  switchRouteByPush(
                      context, ProfileScreen(isOwn: isOwn, id: user!.id!));
                }
              },
              child: Container(
                padding: const EdgeInsets.all(3),
                height: 56,
                width: 56,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isAction ? Colors.cyan[400] : const Color(0xFFCCCCCC),
                ),
                child: CircleAvatar(
                  maxRadius: 30,
                  backgroundColor: const Color(0xFFCCCCCC),
                  foregroundImage: user != null
                      ? CachedNetworkImageProvider(
                          "${ApiConstants.baseUrl}/${user!.avatar}",
                          maxHeight: 256,
                          maxWidth: 256,
                          cacheKey: isOwn ? null : user!.id,
                        )
                      : null,
                  child: date == "this.add"
                      ? const Icon(
                          Boxicons.bx_plus,
                          size: 30,
                          color: Color(0xFF111111),
                        )
                      : user == null
                          ? const Icon(Boxicons.bx_question_mark,
                              size: 30, color: Color(0x22111111))
                          : null,
                ),
              ),
            ),
          ),
          settings['hideDate']!
              ? const SizedBox.shrink()
              : Positioned(
                  top: invert ? 0 : null,
                  bottom: !invert ? 0 : null,
                  left: 0,
                  right: 0,
                  child: Text(
                    date,
                    textAlign: TextAlign.center,
                    style: RootNodeFontStyle.labelSmall.copyWith(
                      color: date.contains('this')
                          ? Colors.cyan[400]
                          : Colors.white54,
                    ),
                  ),
                )
        ],
      ),
    );
  }
}

class LinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFCCCCCC)
      ..strokeWidth = 3;
    canvas.drawLine(
      Offset(0, size.height * 0.5),
      Offset(size.width, size.height * 0.5),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class PolyLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFCCCCCC)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeMiterLimit = 1;
    final path = Path();

    path.moveTo(0, size.height - 80);
    path.lineTo(0, size.height * 0.5);
    path.lineTo(size.width, size.height * 0.5);
    path.lineTo(size.width, 71);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
