import 'package:boxicons/boxicons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:rootnode/app/constant/api.dart';
import 'package:rootnode/app/constant/font.dart';
import 'package:rootnode/app/constant/layout.dart';
import 'package:rootnode/helper/socket_service.dart';
import 'package:rootnode/helper/switch_route.dart';
import 'package:rootnode/helper/utils.dart';
import 'package:rootnode/model/user/user.dart';
import 'package:rootnode/provider/session_provider.dart';
import 'package:rootnode/screen/auth/login_screen.dart';
import 'package:rootnode/screen/dashboard/event_screen.dart';
import 'package:rootnode/screen/dashboard/home_screen.dart';
import 'package:rootnode/screen/dashboard/messenger_screen.dart';
import 'package:rootnode/screen/dashboard/node_screen.dart';
import 'package:rootnode/screen/misc/create_post.dart';
import 'package:rootnode/screen/misc/setting.dart';
import 'package:rootnode/widgets/selection_tile.dart';
import 'package:shake/shake.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  static const String route = "dashboardScreen";

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  late User rootnode;
  late final ShakeDetector shakeDetector;
  Future<void> _navigateToCreatePost(
      BuildContext context, RNContentType type) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) =>
            CreatePostScreen(user: rootnode, type: type),
      ),
    );
    if (!mounted) return;
    if (result == null) return;
    Navigator.of(context, rootNavigator: true).pop('dialog');

    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(SnackBar(
        content: Text(
          '$result',
          style: RootNodeFontStyle.label.copyWith(color: Colors.cyan),
          textAlign: TextAlign.center,
        ),
        backgroundColor: const Color(0xFF111111),
      ));
  }

  int _selectedIndex = 0;
  double triggerResponsiveNav = 480;
  double _getWidth(context) {
    return MediaQuery.of(context).size.width;
  }

  @override
  void initState() {
    shakeDetector =
        ShakeDetector.waitForStart(onPhoneShake: () => _showLogout());
    shakeDetector.startListening();
    super.initState();
  }

  @override
  void dispose() {
    shakeDetector.stopListening();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    rootnode = ref.watch(sessionProvider.select((value) => value.user!));

    return Scaffold(
      extendBody: _getWidth(context) > 480,
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: mqSmallH(context) ? 60 : 60, // 80 : 60
        backgroundColor: const Color(0xFF111111),
        title: RootNodeBar(user: rootnode),
        actions: [
          Container(
            padding: const EdgeInsets.only(right: 10),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              _selectedIndex == 2
                  ? IconButton(
                      splashRadius: 20,
                      onPressed: () {},
                      icon: const Icon(Icons.visibility,
                          color: Colors.white70, size: 22),
                    )
                  : const SizedBox(),
              _selectedIndex == 0
                  ? IconButton(
                      splashRadius: 20,
                      onPressed: () => _showPostOptions(context),
                      icon: const Icon(Icons.add,
                          color: Colors.white70, size: 24),
                    )
                  : const SizedBox(),
              mqSmallW(context)
                  ? IconButton(
                      splashRadius: 20,
                      onPressed: () {},
                      icon: const Icon(Icons.notifications,
                          color: Colors.white70, size: 22),
                    )
                  : const SizedBox()
            ]),
          ),
        ],
      ),
      body: IndexedStack(index: _selectedIndex, children: const [
        HomeScreen(),
        NodeScreen(),
        MessengerScreen(),
        EventScreen(),
      ]),
      bottomNavigationBar: Container(
        margin: _getWidth(context) > triggerResponsiveNav
            ? const EdgeInsets.symmetric(horizontal: 180, vertical: 30)
            : EdgeInsets.zero,
        height: kBottomNavigationBarHeight + 8,
        padding: _getWidth(context) > triggerResponsiveNav
            ? const EdgeInsets.symmetric(horizontal: 10, vertical: 0)
            : EdgeInsets.zero,
        decoration: BoxDecoration(
          color: const Color(0xFF111111),
          borderRadius: BorderRadius.circular(50),
        ),
        child: GNav(
          tabMargin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          tabBorderRadius: 50,
          tabBackgroundColor:
              mqSmallW(context) ? Colors.white12 : Colors.transparent,
          curve: Curves.easeInQuad,
          duration: const Duration(milliseconds: 300),
          color: Colors.white54,
          activeColor: Colors.cyan,
          iconSize: mqSmallW(context)
              ? LayoutConstants.postIconBig
              : LayoutConstants.postIcon,
          backgroundColor: const Color(0x00111111),
          padding: mqSmallW(context)
              ? const EdgeInsets.symmetric(horizontal: 10, vertical: 8)
              : const EdgeInsets.all(5),
          gap: mqSmallW(context) ? 10 : 0,
          tabs: [
            GButton(
                icon: Boxicons.bxs_home,
                text: mqSmallW(context) ? 'Home' : "" /***/),
            GButton(
                icon: Boxicons.bx_stats,
                text: mqSmallW(context) ? 'Node' : "" /***/),
            GButton(
                icon: Boxicons.bxs_message_square_dots,
                text: mqSmallW(context) ? 'Chat' : ""),
            GButton(
                icon: Boxicons.bxs_calendar_event,
                text: mqSmallW(context) ? 'Event' : ""),
          ],
          selectedIndex: _selectedIndex,
          onTabChange: (value) => setState(() {
            _selectedIndex = value;
          }),
        ),
      ),
    );
  }

  Future<dynamic> _showPostOptions(BuildContext context) {
    return showDialog(
      barrierColor: const Color(0xEE000000),
      context: context,
      builder: (context) => SelectionTile(
        title: "Create Post",
        tileButton: [
          TileButton(
            type: RNContentType.text,
            icon: Boxicons.bx_text,
            label: "Text",
            onPressed: (RNContentType type) =>
                _navigateToCreatePost(context, type),
          ),
          TileButton(
            type: RNContentType.markdown,
            icon: Boxicons.bxl_markdown,
            label: "Markdown",
            onPressed: (RNContentType type) =>
                _navigateToCreatePost(context, type),
          ),
          TileButton(
            type: RNContentType.video,
            icon: Boxicons.bx_video,
            label: "Video",
            onPressed: (RNContentType type) =>
                _navigateToCreatePost(context, type),
          ),
          TileButton(
            type: RNContentType.image,
            icon: Boxicons.bx_image,
            label: "Image",
            onPressed: (RNContentType type) =>
                _navigateToCreatePost(context, type),
          ),
        ],
        widthFraction: 0.7,
        column: 2,
        bottomLabel: "Select a type of post you want to create",
      ),
    );
  }

  _showLogout() {
    return showDialog(
      barrierColor: const Color(0xEE000000),
      context: context,
      builder: (context) => SelectionTile(
        title: "Do you want to logout?",
        tileButton: [
          TileButton(
              type: RNContentType.text,
              icon: Boxicons.bx_check,
              label: "Yes",
              onPressed: (RNContentType type) {
                ref.read(socketServiceProvider).disconnect();
                Navigator.of(context).pushNamedAndRemoveUntil(
                    LoginScreen.route, (route) => false);
              }),
          TileButton(
              type: RNContentType.markdown,
              icon: Boxicons.bx_x,
              label: "No",
              onPressed: (RNContentType type) => Navigator.pop(context, false)),
        ],
        widthFraction: 0.7,
        column: 2,
        bottomLabel: "A shake has been detected",
      ),
    );
  }

  bool mqSmallW(BuildContext context) =>
      MediaQuery.of(context).size.width > 320;
  bool mqSmallH(BuildContext context) =>
      MediaQuery.of(context).size.height > 320;
}

class RootNodeBar extends StatelessWidget {
  final User user;
  const RootNodeBar({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(50),
          onTap: () => switchRouteByPush(context, const SettingScreen()),
          child: Container(
            height: 40,
            width: 40,
            margin: const EdgeInsets.all(3),
            clipBehavior: Clip.antiAlias,
            decoration: const BoxDecoration(
              color: Colors.white10,
              shape: BoxShape.circle,
            ),
            child: FadeInImage.assetNetwork(
              imageCacheHeight: 256,
              imageCacheWidth: 256,
              fit: BoxFit.cover,
              image: "${ApiConstants.baseUrl}/${user.avatar}",
              placeholder: 'assets/images/image_grey.png',
            ),
          ),
        ),
        const SizedBox(width: 10 - 3),
        Expanded(
          child: Wrap(
            direction: Axis.vertical,
            spacing: -5,
            children: [
              Text(Utils.greetings(), style: RootNodeFontStyle.label),
              Text(user.fullname, style: RootNodeFontStyle.title),
            ],
          ),
        ),
      ],
    );
  }
}
