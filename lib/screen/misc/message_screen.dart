import 'package:boxicons/boxicons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rootnode/app/constant/api.dart';
import 'package:rootnode/app/constant/font.dart';
import 'package:rootnode/app/utils/snackbar.dart';
import 'package:rootnode/helper/message_service.dart';
import 'package:rootnode/helper/switch_route.dart';
import 'package:rootnode/model/message/message.dart';
import 'package:rootnode/model/user/user.dart';
import 'package:rootnode/provider/session_provider.dart';
import 'package:rootnode/screen/misc/call_screen.dart';
import 'package:rootnode/screen/misc/view_profile.dart';
import 'package:rootnode/widgets/message_bar.dart';
import 'package:rootnode/widgets/message_card.dart';
import 'package:rootnode/widgets/such_empty.dart';

class MessageScreen extends ConsumerStatefulWidget {
  const MessageScreen({super.key, required this.node});
  final User node;
  @override
  ConsumerState<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends ConsumerState<MessageScreen> {
  late final User rootnode;
  late final ScrollController _controller;
  MessageService? _messageService;
  bool _autoScroll = true;

  @override
  void initState() {
    rootnode = ref.read(sessionProvider.select((value) => value.user!));
    _controller = ScrollController()
      ..addListener(() {
        if (_controller.position.maxScrollExtent == _controller.offset &&
            !_autoScroll) {
          _autoScroll = true;
        } else if (_autoScroll) {
          _autoScroll = false;
        }
      });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    _controller.animateTo(
      _controller.position.maxScrollExtent,
      duration: const Duration(milliseconds: 100),
      curve: Curves.linear,
    );
  }

  @override
  Widget build(BuildContext context) {
    _messageService = ref.watch(messageServiceProvider(widget.node.id!));
    return Scaffold(
      appBar: AppBar(
          elevation: 0,
          toolbarHeight: 60,
          title: Row(
            children: [
              InkWell(
                borderRadius: BorderRadius.circular(50),
                onTap: () =>
                    switchRouteByPush(context, ProfileScreen(id: rootnode.id!)),
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
                    image: "${ApiConstants.baseUrl}/${widget.node.avatar}",
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
                    Text(widget.node.fullname, style: RootNodeFontStyle.title),
                    Text('@${widget.node.username}',
                        style: RootNodeFontStyle.label),
                  ],
                ),
              ),
            ],
          ),
          automaticallyImplyLeading: false,
          actions: _getActions()),
      body: Padding(
        padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
        child: ShaderMask(
          blendMode: BlendMode.dstOut,
          shaderCallback: (bounds) => const LinearGradient(
            colors: [Color(0xFF111111), Colors.transparent],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.01, 0.1],
          ).createShader(bounds),
          child: Column(
            children: [
              Expanded(
                // This will be listview
                child: StreamBuilder<List<Message>>(
                  stream: _messageService!.messages,
                  initialData: _messageService!.initials,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final messages = snapshot.data!;
                      if (messages.isEmpty) return const SuchEmpty();
                      return ListView.builder(
                        addAutomaticKeepAlives: false,
                        controller: _controller,
                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                          final message = messages[index];

                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            _autoScroll
                                ? _scrollToBottom()
                                : showSnackbar(
                                    context,
                                    message.text ?? "",
                                    Colors.white10,
                                    margin: const EdgeInsets.only(
                                        bottom: 64, right: 30, left: 30),
                                    dismissable: false,
                                  );
                          });
                          return MessageCard(
                            message: message.text ?? "",
                            date: message.createdAt ?? DateTime.now(),
                            invert: rootnode.id == message.from,
                            avatarLeft:
                                "${ApiConstants.baseUrl}/${widget.node.avatar}",
                            avatarRight:
                                "${ApiConstants.baseUrl}/${rootnode.avatar}",
                          );
                        },
                      );
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                ),
              ),
              BottomMessageBar(
                onSuccess: _scrollToBottom,
                id: widget.node.id!,
                messageService: _messageService!,
              )
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _getActions() => [
        IconButton(
          visualDensity: VisualDensity.adaptivePlatformDensity,
          highlightColor: Colors.white10,
          onPressed: () =>
              switchRouteByPush(context, CallScreen(node: widget.node)),
          icon: const Icon(
            Boxicons.bxs_phone,
            color: Colors.white70,
          ),
        ),
        const SizedBox(width: 5),
        IconButton(
          visualDensity: VisualDensity.adaptivePlatformDensity,
          highlightColor: Colors.white10,
          onPressed: () {},
          icon: const Icon(
            Boxicons.bx_dots_vertical_rounded,
            color: Colors.white70,
          ),
        ),
        const SizedBox(width: 5),
      ];
}
