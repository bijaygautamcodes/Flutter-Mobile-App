import 'package:boxicons/boxicons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rootnode/app/constant/font.dart';
import 'package:rootnode/app/utils/snackbar.dart';
import 'package:rootnode/model/post.dart';
import 'package:rootnode/model/user/user.dart';
import 'package:rootnode/repository/post_repo.dart';
import 'package:rootnode/widgets/add_media.dart';
import 'package:rootnode/widgets/radio_button.dart';
import 'package:rootnode/widgets/selection_tile.dart';
import 'package:rootnode/widgets/switch_button.dart';

class CreatePostScreen extends ConsumerStatefulWidget {
  const CreatePostScreen({super.key, this.user, required this.type});
  final User? user;
  final RNContentType type;
  @override
  ConsumerState<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends ConsumerState<CreatePostScreen> {
  late final PostRepo _postRepo;
  final _globalkey = GlobalKey<FormState>();
  final _headingController = TextEditingController();
  final _captionFieldController = TextEditingController();
  List<String> visibilityOption = ['Private', 'Mutual', 'Public'];
  String title = "Create Post";
  bool mediaDisabled = false;
  bool showHeading = false;
  bool disableTextField = false;
  Post post = Post();
  List<XFile>? files;

  bool disableThis = false;

  @override
  void initState() {
    _postRepo = ref.read(postRepoProvider);
    if (widget.type == RNContentType.markdown) {
      title = "Create Markdown";
      post.isMarkdown = true;
      mediaDisabled = true;
    } else if (widget.type == RNContentType.text) {
      title = "Create Text Post";
      mediaDisabled = true;
      showHeading = true;
    } else if (widget.type == RNContentType.video) {
      title = "Create Video Post";
      disableTextField = true;
    } else {
      title = "Create Image Post";
    }
    super.initState();
  }

  @override
  void dispose() {
    _headingController.dispose();
    _captionFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          style: RootNodeFontStyle.header,
        ),
        leadingWidth: 40,
        leading: IconButton(
          icon: const Icon(
            Boxicons.bx_chevron_left,
            color: Colors.white70,
            size: 40,
          ),
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop('Canceled!');
          },
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: const Color(0xFF111111),
        padding: const EdgeInsets.all(10),
        child: Form(
          key: _globalkey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                disableTextField
                    ? const SizedBox.shrink()
                    : Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        child: TextFormField(
                          onTapOutside: (event) =>
                              FocusScope.of(context).unfocus(),
                          onEditingComplete: () =>
                              FocusScope.of(context).unfocus(),
                          controller: _captionFieldController,
                          maxLines: 3,
                          textAlign: TextAlign.center,
                          cursorColor: Colors.cyan[400],
                          cursorHeight: 5,
                          cursorWidth: 3,
                          style: RootNodeFontStyle.captionDefault,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white10,
                            hintText: "What's on your mind?",
                            hintStyle: RootNodeFontStyle.body,
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                          ),
                        ),
                      ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  width: double.infinity,
                  child: RootNodeRadioButton<String>(
                    selected: 2,
                    name: "Visibility",
                    options: const ["Private", "Mutual", "Public"],
                    value: const ["private", "mutual", "public"],
                    onChanged: (value) {
                      debugPrint(value);
                      post.visibility = value;
                    },
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    // color: Colors.white10,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: RootNodeSwitchButton(
                    isChecked: true,
                    name: "Likeable",
                    onChanged: (value) => post.likeable = value,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    // color: Colors.white10,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: RootNodeSwitchButton(
                    isChecked: true,
                    name: "Commentable",
                    onChanged: (value) => post.commentable = value,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    // color: Colors.white10,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: RootNodeSwitchButton(
                    isChecked: true,
                    name: "Shareable",
                    onChanged: (value) => post.shareable = value,
                  ),
                ),
                mediaDisabled
                    ? const SizedBox.shrink()
                    : Container(
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        width: double.infinity,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: RootNodeAddMedia(
                            onChanged: (value) {
                              debugPrint("==FILES AT CREATE POST==");
                              if (value == null || value.isEmpty) return;
                              files = value;
                            },
                            type: widget.type,
                          ),
                        ),
                      ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: ElevatedButton(
                        onPressed: () {
                          _craftPost(context);
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 20),
                          child: Text(
                            "Create Now!",
                            style: RootNodeFontStyle.body,
                          ),
                        )),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _craftPost(context) {
    String caption = _captionFieldController.text;
    if (caption == "" && (files == null || files!.isEmpty)) {
      return showSnackbar(
        context,
        "Post must contain media or caption",
        Colors.red[400]!,
      );
    }
    if (caption != "") post.caption = caption;
    _uploadPost(context);
  }

  void _uploadPost(context) async {
    if (disableThis) return;
    disableThis = true;
    bool res = await _postRepo.createPost(post: post, files: files);
    if (res) {
      Navigator.pop(context, "New post created!");
    } else {
      disableThis = false;
      showSnackbar(context, "Something went wrong!", Colors.red[400]!);
    }
  }
}
