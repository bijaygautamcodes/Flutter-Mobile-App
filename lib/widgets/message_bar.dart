import 'package:flutter/material.dart';
import 'package:rootnode/app/constant/font.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rootnode/app/utils/snackbar.dart';
import 'package:rootnode/helper/message_service.dart';
import 'package:rootnode/model/message/message.dart';
import 'package:rootnode/provider/session_provider.dart';

class BottomMessageBar extends ConsumerStatefulWidget {
  const BottomMessageBar({
    required this.onSuccess,
    required this.id,
    required this.messageService,
    Key? key,
  }) : super(key: key);
  final String id;
  final Function onSuccess;
  final MessageService messageService;

  @override
  ConsumerState<BottomMessageBar> createState() => _BottomChatFieldState();
}

class _BottomChatFieldState extends ConsumerState<BottomMessageBar> {
  final _controller = TextEditingController();
  FocusNode focusNode = FocusNode();
  bool isDisabled = true;

  @override
  void initState() {
    super.initState();
  }

  void showKeyboard() => focusNode.requestFocus();
  void hideKeyboard() => focusNode.unfocus();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              disabledColor: Colors.white10,
              color: Colors.white70,
              visualDensity: VisualDensity.adaptivePlatformDensity,
              icon: const Icon(Icons.emoji_emotions),
              onPressed: null,
            ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextFormField(
                  focusNode: focusNode,
                  controller: _controller,
                  onChanged: _toggleSend,
                  style: RootNodeFontStyle.caption.copyWith(height: 1.4),
                  textAlign: TextAlign.start,
                  onEditingComplete: hideKeyboard,
                  cursorWidth: 6,
                  cursorRadius: const Radius.circular(2),
                  onFieldSubmitted: (value) =>
                      isDisabled ? null : _sendMessage(),
                  textInputAction: TextInputAction.send,
                  cursorColor: Colors.grey,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white10,
                    hintText: "Message...",
                    hintStyle: RootNodeFontStyle.caption
                        .copyWith(color: Colors.white24, height: 1.4),
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.all(5),
                  ),
                ),
              ),
            ),
            IconButton(
              disabledColor: Colors.white10,
              color: Colors.white70,
              visualDensity: VisualDensity.adaptivePlatformDensity,
              icon: const Icon(Icons.send),
              onPressed: isDisabled ? null : _sendMessage,
            ),
          ],
        ),
      ],
    );
  }

  _toggleSend(String value) {
    if (value.trim() == "" && !isDisabled) {
      setState(() {
        isDisabled = true;
      });
      return;
    }
    isDisabled ? setState(() => isDisabled = false) : null;
  }

  _sendMessage() {
    final rootnode = ref.read(sessionProvider.select((value) => value.user!));
    String message = _controller.text;
    _controller.clear();
    _toggleSend("");
    debugPrint(message);
    if (message.trim() == "") {
      showSnackbar(context, "Invalid comment", Colors.red[400]!);
      return;
    }
    widget.messageService.sendMessage(Message(
      from: rootnode.id!,
      to: widget.id,
      text: message,
    ));
    widget.onSuccess();
  }
}
