import 'package:boxicons/boxicons.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:rootnode/app/constant/font.dart';

class MediaError extends StatelessWidget {
  const MediaError({super.key, required this.icon, this.minimal = false});

  final IconData icon;
  final bool minimal;

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (context, setState) => Container(
        color: const Color(0x47E57373),
        height: double.infinity,
        width: double.infinity,
        child: Center(
          child: minimal
              ? Icon(icon, size: 30, color: Colors.red[300])
              : Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  direction: Axis.vertical,
                  children: [
                      Icon(icon, size: 26, color: Colors.red[300]),
                      Text("Something went wrong!",
                          style: RootNodeFontStyle.body),
                    ]),
        ),
      ),
    );
  }
}

class MediaEmpty extends StatelessWidget {
  const MediaEmpty(
      {super.key,
      required this.icon,
      this.minimal = false,
      required this.message});

  final IconData icon;
  final String message;
  final bool minimal;

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (context, setState) => Container(
        color: Colors.white10,
        height: double.infinity,
        width: double.infinity,
        child: Center(
          child: minimal
              ? Icon(icon, size: 26, color: Colors.cyan)
              : Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  direction: Axis.vertical,
                  children: [
                      Icon(icon, size: 26, color: Colors.cyan),
                      Text(message, style: RootNodeFontStyle.body),
                    ]),
        ),
      ),
    );
  }
}

class MediaLoading extends StatelessWidget {
  const MediaLoading({
    super.key,
    required this.label,
    required this.icon,
    required this.progress,
  });
  final String label;
  final IconData icon;
  final DownloadProgress? progress;

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Wrap(
      direction: Axis.vertical,
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 5,
      children: [
        Icon(icon, size: 30, color: Colors.white54),
        Text(label, style: RootNodeFontStyle.body),
        SizedBox(
            width: 120,
            height: 6,
            child: LinearProgressIndicator(
              backgroundColor: Colors.white10,
              color: Colors.white54,
              value: progress != null ? progress!.progress : null,
              // strokeWidth: 5,
            )),
      ],
    ));
  }
}

class DummySearchField extends StatelessWidget {
  const DummySearchField({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
          color: const Color(0xFF333333),
          borderRadius: BorderRadius.circular(10)),
      child: Wrap(
        spacing: 10,
        children: [
          const Icon(Boxicons.bx_search, color: Colors.white54),
          Text(
            "Find people, events...",
            style: RootNodeFontStyle.label,
          )
        ],
      ),
    );
  }
}
