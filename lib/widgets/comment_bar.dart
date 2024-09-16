import 'package:flutter/material.dart';
import 'package:rootnode/app/constant/font.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rootnode/app/utils/snackbar.dart';
import 'package:rootnode/repository/cmnt_repo.dart';

class BottomCommentBar extends ConsumerStatefulWidget {
  const BottomCommentBar({
    required this.onSuccess,
    required this.id,
    Key? key,
  }) : super(key: key);
  final String id;
  final Function onSuccess;

  @override
  ConsumerState<BottomCommentBar> createState() => _BottomChatFieldState();
}

class _BottomChatFieldState extends ConsumerState<BottomCommentBar> {
  final _controller = TextEditingController();
  FocusNode focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
  }

  void showKeyboard() => focusNode.requestFocus();
  void hideKeyboard() => focusNode.unfocus();

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
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
            Expanded(
              child: TextFormField(
                focusNode: focusNode,
                controller: _controller,
                textAlignVertical: TextAlignVertical.center,
                style: RootNodeFontStyle.label,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white10,
                  hintText: 'Write a comment...',
                  hintStyle: RootNodeFontStyle.label,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.all(10),
                  suffix: GestureDetector(
                    onTap: () => _postComment(),
                    child: Container(
                      height: 40,
                      width: 40,
                      alignment: Alignment.center,
                      child: const Icon(
                        Icons.send,
                        size: 22,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  _postComment() async {
    final commentRepo = ref.read(commentRepoProvider);
    String comment = _controller.text;
    if (comment.trim() == "") {
      showSnackbar(context, "Invalid comment", Colors.red[400]!);
      return;
    }
    final res =
        await commentRepo.createComment(id: widget.id, comment: comment);
    if (res != null) {
      hideKeyboard();
      _controller.clear();
      widget.onSuccess();
      return;
    }
    // ignore: use_build_context_synchronously
    showSnackbar(context, "Something went wrong", Colors.red[400]!);
  }
}
