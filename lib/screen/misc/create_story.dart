import 'dart:io';

import 'package:boxicons/boxicons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rootnode/app/constant/font.dart';
import 'package:rootnode/app/utils/snackbar.dart';
import 'package:rootnode/helper/utils.dart' show Utils;
import 'package:rootnode/model/story.dart';
import 'package:rootnode/repository/story_repo.dart';
import 'package:rootnode/screen/misc/view_story.dart';
import 'package:rootnode/widgets/add_media.dart';
import 'package:rootnode/widgets/radio_button.dart';
import 'package:rootnode/widgets/selection_tile.dart';
import 'package:rootnode/widgets/switch_button.dart';

class CreateStoryScreen extends ConsumerStatefulWidget {
  const CreateStoryScreen({super.key, required this.type});
  final RNContentType type;

  @override
  ConsumerState<CreateStoryScreen> createState() => _CreateStoryScreenState();
}

class _CreateStoryScreenState extends ConsumerState<CreateStoryScreen> {
  late final StoryRepo _storyRepo;
  XFile? file;

  bool appBar = true;

  @override
  void initState() {
    _storyRepo = ref.read(storyRepoProvider);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar:
          (file != null && widget.type != RNContentType.video) ||
              widget.type == RNContentType.text,
      appBar: appBar
          ? AppBar(
              elevation: 0,
              backgroundColor: Colors.transparent,
              title: Text(
                "Create Story",
                style: RootNodeFontStyle.header.copyWith(color: Colors.white70),
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
            )
          : null,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: const Color(0xFF111111),
        padding: const EdgeInsets.all(00),
        child: widget.type == RNContentType.text
            ? CreateTextStory(
                toggleAppbarOff: () => setState(() {
                  appBar = false;
                }),
                toggleAppbarOn: () => setState(() {
                  appBar = true;
                }),
                onSubmit: (value) => _uploadStory(context, value),
              )
            : CreateMediaStory(
                toggleAppbarOff: () => setState(() {
                  appBar = false;
                }),
                toggleAppbarOn: () => setState(() {
                  appBar = true;
                }),
                onSubmit: (value) => _uploadStory(context, value),
                type: widget.type,
                onChanged: (value) => setState(() {
                  file = value;
                }),
              ),
      ),
    );
  }

  void _uploadStory(context, Story story) async {
    bool res = await _storyRepo.createStory(story: story, file: file);
    if (res) {
      Navigator.pop(context, "New story created!");
    } else {
      showSnackbar(context, "Something went wrong!", Colors.red[400]!);
    }
  }
}

class CreateMediaStory extends StatefulWidget {
  const CreateMediaStory({
    super.key,
    required this.type,
    required this.onChanged,
    required this.toggleAppbarOn,
    required this.toggleAppbarOff,
    required this.onSubmit,
  });

  final RNContentType type;
  final ValueChanged<XFile?> onChanged;
  final VoidCallback toggleAppbarOn;
  final VoidCallback toggleAppbarOff;
  final ValueSetter<Story> onSubmit;

  @override
  State<CreateMediaStory> createState() => _CreateMediaStoryState();
}

class _CreateMediaStoryState extends State<CreateMediaStory> {
  final List<String> visibilityOption = ['Private', 'Mutual', 'Public'];
  final _quoteFieldController = TextEditingController();
  Story story = Story(likeable: true);
  XFile? file;

  bool darkenImage = false;

  double _getDynamicHeight(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    if (height > 1080) return height / 2;
    return 300;
  }

  int _getHeightAlias(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    if (height <= 720) return 0;
    if (height > 720 && height <= 1080) return 1;
    if (height > 1080 && height <= 1280) return 2;
    return 3;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: file != null && widget.type != RNContentType.video
                ? _getDynamicHeight(context)
                : null,
            child: file != null && widget.type == RNContentType.image
                ? Stack(fit: StackFit.expand, children: [
                    Image.file(
                      File(file!.path),
                      fit: BoxFit.cover,
                    ),
                    AnimatedContainer(
                      duration: const Duration(seconds: 1),
                      color: darkenImage ? Colors.black54 : Colors.transparent,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: Utils.getViewShadow(),
                      ),
                    ),
                    _quoteFieldController.text.trim().length > 1
                        ? Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: Center(
                              child: StoryHeading(
                                solid: true,
                                story: Story(quote: _quoteFieldController.text),
                              ),
                            ),
                          )
                        : const SizedBox.shrink(),
                    Positioned(
                      right: 10,
                      bottom: -10,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: IconButton(
                          color: Colors.red[300],
                          iconSize: 24,
                          onPressed: () => setState(() {
                            file = null;
                            widget.onChanged(null);
                          }),
                          icon: Icon(Boxicons.bx_trash, color: Colors.red[300]),
                        ),
                      ),
                    ),
                    Positioned(
                        right: 0,
                        left: 0,
                        bottom: -1,
                        child: Container(
                            width: double.infinity,
                            height: 2,
                            color: const Color(0xFF111111)))
                  ])
                : Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      padding: const EdgeInsets.only(
                          top: 20, left: 20, right: 20, bottom: 0),
                      child: RootNodeAddMedia(
                        single: true,
                        onChanged: (List<XFile>? files) => setState(() {
                          if (files != null) {
                            file = files.first;
                            widget.onChanged(file);
                          } else {
                            widget.onChanged(null);
                          }
                        }),
                        type: widget.type,
                      ),
                    ),
                  ),
          ),
          widget.type != RNContentType.video
              ? Container(
                  margin: const EdgeInsets.only(top: 10),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: TextFormField(
                    onTapOutside: (event) {
                      setState(() {
                        darkenImage = false;
                      });
                      FocusScope.of(context).unfocus();
                      widget.toggleAppbarOn();
                    },
                    onEditingComplete: () {
                      setState(() {
                        darkenImage = false;
                      });
                      FocusScope.of(context).unfocus();
                      widget.toggleAppbarOn();
                    },
                    onTap: () {
                      setState(() {
                        darkenImage = true;
                      });
                      widget.toggleAppbarOff();
                    },
                    controller: _quoteFieldController,
                    onChanged: (value) => setState(() {}),
                    maxLines: 1,
                    textAlign: TextAlign.center,
                    cursorColor: Colors.cyan[400],
                    cursorHeight: 5,
                    cursorWidth: 15,
                    validator: (value) {
                      if (value == null || value == "" || value.length < 5) {
                        return "Quote must be 5 char long";
                      }
                      return null;
                    },
                    style: RootNodeFontStyle.captionDefault,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white10,
                      hintText: 'Add a Quote',
                      hintStyle: RootNodeFontStyle.body,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 20),
                    ),
                  ),
                )
              : const SizedBox.shrink(),
          Container(
            padding: const EdgeInsets.only(top: 5),
            margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            width: double.infinity,
            child: RootNodeRadioButton<String>(
              selected: 2,
              name: "Visibility",
              options: visibilityOption,
              value: const ["private", "mutual", "public"],
              onChanged: (value) {
                debugPrint(value);
                story.visibility = value;
              },
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            width: double.infinity,
            decoration: BoxDecoration(
              // color: Colors.white10,
              borderRadius: BorderRadius.circular(10),
            ),
            child: RootNodeSwitchButton(
              isChecked: story.likeable!,
              name: "Likeable",
              onChanged: (value) => story.likeable = value,
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: ElevatedButton(
                  onPressed: () => _handleProcessing(context),
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
    );
  }

  _handleProcessing(BuildContext context) {
    if (file == null) {
      String msg = widget.type == RNContentType.image
          ? "An image is required for the story"
          : "A video is required for the story";
      showSnackbar(context, msg, Colors.red[400]!);
      return;
    }
    if (widget.type == RNContentType.image) {
      if (_quoteFieldController.text != "") {
        story.quote = _quoteFieldController.text;
      }
    }
    widget.onSubmit(story);
  }
}

class CreateTextStory extends StatefulWidget {
  const CreateTextStory({
    super.key,
    required this.toggleAppbarOn,
    required this.toggleAppbarOff,
    required this.onSubmit,
  });
  final VoidCallback toggleAppbarOn;
  final VoidCallback toggleAppbarOff;
  final ValueSetter<Story> onSubmit;

  @override
  State<CreateTextStory> createState() => _CreateTextStoryState();
}

class _CreateTextStoryState extends State<CreateTextStory> {
  final List<String> visibilityOption = ['Private', 'Mutual', 'Public'];
  final _quoteFieldController = TextEditingController();
  final _globalkey = GlobalKey<FormState>();
  MaterialColor color = Colors.cyan;
  final Story story = Story(likeable: true);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _globalkey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 360,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  AnimatedContainer(
                    duration: const Duration(seconds: 1),
                    curve: Curves.easeInOut,
                    color: color,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: Utils.getViewShadow(),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Center(
                      child: StoryHeading(
                        story: Story(quote: _quoteFieldController.text),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: TextFormField(
                onTapOutside: (event) {
                  FocusScope.of(context).unfocus();
                  widget.toggleAppbarOn();
                },
                onEditingComplete: () {
                  FocusScope.of(context).unfocus();
                  widget.toggleAppbarOn();
                },
                onTap: () => widget.toggleAppbarOff(),
                controller: _quoteFieldController,
                onChanged: (value) => setState(() {}),
                maxLines: 1,
                textAlign: TextAlign.center,
                cursorColor: Colors.cyan[400],
                cursorHeight: 5,
                cursorWidth: 15,
                validator: (value) {
                  if (value == null || value == "" || value.length < 5) {
                    return "Quote must be 5 char long";
                  }
                  return null;
                },
                style: RootNodeFontStyle.captionDefault,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white10,
                  hintText: 'Add a Quote',
                  hintStyle: RootNodeFontStyle.body,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                ),
              ),
            ),
            RootNodeRadioButton<MaterialColor>(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              isColors: true,
              value: const [
                Colors.cyan,
                Colors.green,
                Colors.amber,
                Colors.pink,
                Colors.red,
                Colors.purple,
              ],
              options: List.filled(6, ""),
              onChanged: (value) {
                setState(() {
                  color = value;
                });
              },
              selected: 0,
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              width: double.infinity,
              child: RootNodeRadioButton<String>(
                selected: 2,
                name: "Visibility",
                options: visibilityOption,
                value: const ["private", "mutual", "public"],
                onChanged: (value) {
                  debugPrint(value);
                  story.visibility = value;
                },
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              width: double.infinity,
              decoration: BoxDecoration(
                // color: Colors.white10,
                borderRadius: BorderRadius.circular(10),
              ),
              child: RootNodeSwitchButton(
                isChecked: story.likeable!,
                name: "Likeable",
                onChanged: (value) => story.likeable = value,
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: ElevatedButton(
                    onPressed: () => _handleProcessing(context),
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
    );
  }

  _handleProcessing(BuildContext context) {
    if (!_globalkey.currentState!.validate()) {
      return;
    }
    story.quote = _quoteFieldController.text;
    story.color = color.value;
    widget.onSubmit(story);
  }
}
