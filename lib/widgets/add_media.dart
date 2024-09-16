import 'dart:io';

import 'package:boxicons/boxicons.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rootnode/app/constant/font.dart';
import 'package:rootnode/helper/media_helper.dart';
import 'package:rootnode/widgets/selection_tile.dart';

class RootNodeAddMedia extends StatefulWidget {
  const RootNodeAddMedia({
    super.key,
    required this.onChanged,
    required this.type,
    this.single = false,
  });
  final ValueChanged<List<XFile>?> onChanged;
  final RNContentType type;
  final bool single;

  @override
  State<RootNodeAddMedia> createState() => _RootNodeAddMediaState();
}

class _RootNodeAddMediaState extends State<RootNodeAddMedia> {
  MediaHelper helper = MediaHelper.instance;
  List<XFile> xFiles = [];
  int selected = 0;
  String label = "Select image";
  IconData icon = Boxicons.bx_image_add;

  @override
  void initState() {
    if (widget.type == RNContentType.video) {
      label = "Select video";
      icon = Boxicons.bx_video_plus;
    }
    super.initState();
  }

  @override
  void dispose() {
    xFiles.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: () => xFiles.isEmpty
              ? showDialog(
                  barrierColor: Colors.black87,
                  context: context,
                  builder: (dialogContex) => AlertDialog(
                    backgroundColor: Colors.white70,
                    title: Text('Choose an option',
                        textAlign: TextAlign.center,
                        style: RootNodeFontStyle.body
                            .copyWith(color: Colors.black)),
                    actions: [
                      TextButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateColor.resolveWith(
                              (states) => Colors.black12),
                          minimumSize: MaterialStateProperty.resolveWith(
                              (states) => const Size(double.infinity, 50)),
                        ),
                        onPressed: () => _pickFiles(ImageSource.camera),
                        child: const Text('Camera',
                            style: TextStyle(color: Colors.black)),
                      ),
                      TextButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateColor.resolveWith(
                              (states) => Colors.black12),
                          minimumSize: MaterialStateProperty.resolveWith(
                              (states) => const Size(double.infinity, 50)),
                        ),
                        onPressed: () => _pickFiles(ImageSource.gallery),
                        child: const Text('Gallery',
                            style: TextStyle(color: Colors.black)),
                      )
                    ],
                    icon:
                        const Icon(Boxicons.bx_image_add, color: Colors.black),
                    actionsAlignment: MainAxisAlignment.spaceEvenly,
                    alignment: Alignment.center,
                    actionsOverflowButtonSpacing: 10,
                  ),
                )
              : null,
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: xFiles.isEmpty
                  ? Colors.white10
                  : const Color.fromRGBO(0, 188, 212, 0.1),
            ),
            child: DottedBorder(
              padding: const EdgeInsets.symmetric(vertical: 20),
              borderType: BorderType.RRect,
              color: Colors.white54,
              strokeWidth: 2,
              dashPattern: const [8, 4],
              radius: const Radius.circular(10),
              strokeCap: StrokeCap.round,
              child: xFiles.isEmpty || widget.type == RNContentType.video
                  ? Center(
                      child: Wrap(
                        direction: Axis.horizontal,
                        alignment: WrapAlignment.center,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 10,
                        children: [
                          Text(
                            xFiles.isEmpty
                                ? label
                                : "${xFiles.length} selected",
                            style: RootNodeFontStyle.body,
                          ),
                          Icon(
                            icon,
                            size: 30,
                            color: Colors.white54,
                          ),
                        ],
                      ),
                    )
                  : Container(
                      padding: const EdgeInsets.only(
                          left: 10, right: 10, top: 10, bottom: 10),
                      width: double.infinity,
                      child: Wrap(
                        direction: Axis.horizontal,
                        alignment: WrapAlignment.center,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        runSpacing: 5,
                        spacing: 5,
                        children: List.generate(
                          xFiles.length,
                          (index) => Stack(
                            children: [
                              Container(
                                margin: const EdgeInsets.all(10),
                                height: 64,
                                width: 64,
                                clipBehavior: Clip.antiAlias,
                                decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(30),
                                  topLeft: Radius.circular(10),
                                  bottomRight: Radius.circular(10),
                                  bottomLeft: Radius.circular(10),
                                )),
                                child: Image.file(
                                  File(xFiles[index].path),
                                  height: 64,
                                  width: 64,
                                  fit: BoxFit.cover,
                                  filterQuality: FilterQuality.low,
                                ),
                              ),
                              Positioned(
                                top: 0,
                                right: 0,
                                child: GestureDetector(
                                  onTap: () {
                                    xFiles.removeAt(index);
                                    setState(() {});
                                  },
                                  child: Icon(
                                    Boxicons.bxs_x_circle,
                                    color: Colors.red[300],
                                    size: 20,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
            ),
          ),
        ),
        xFiles.isNotEmpty && widget.type == RNContentType.video
            ? Positioned(
                right: 10,
                top: 1,
                bottom: 1,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: IconButton(
                    color: Colors.red[300],
                    iconSize: 24,
                    onPressed: _clearFiles,
                    icon: Icon(Boxicons.bx_trash, color: Colors.red[300]),
                  ),
                ),
              )
            : const SizedBox()
      ],
    );
  }

  _clearFiles() {
    if (xFiles.isEmpty) return;
    xFiles.clear();
    widget.onChanged(null);
    setState(() {});
  }

  _pickImageFiles(ImageSource source) async {
    Navigator.of(context, rootNavigator: true).pop('dialog');
    if (source == ImageSource.camera || widget.single) {
      XFile? image = await helper.pickImage(source: source);
      if (image != null) xFiles.add(image);
    } else {
      xFiles = await helper.pickMultipleImages();
    }
    if (xFiles.isNotEmpty) {
      debugPrint("=====FILES=====");
      debugPrint(xFiles.map((e) => e.name).toString());
      debugPrint("===============");
      widget.onChanged(xFiles);
      setState(() {});
    }
    return null;
  }

  _pickVideoFile(ImageSource source) async {
    Navigator.of(context, rootNavigator: true).pop('dialog');
    XFile? video = await helper.pickVideo(source: source);
    if (video != null) xFiles.add(video);
    if (xFiles.isNotEmpty) {
      debugPrint("=====FILES=====");
      debugPrint(xFiles.map((e) => e.name).toString());
      debugPrint("===============");
      widget.onChanged(xFiles);
      setState(() {});
    }
    return null;
  }

  _pickFiles(ImageSource source) {
    if (widget.type == RNContentType.video) {
      _pickVideoFile(source);
      return;
    }
    _pickImageFiles(source);
  }
}
