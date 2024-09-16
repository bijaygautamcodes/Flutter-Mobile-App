import 'package:boxicons/boxicons.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:rootnode/app/constant/api.dart';
import 'package:rootnode/model/post.dart';
import 'package:rootnode/widgets/placeholder.dart';

class ViewPost extends StatelessWidget {
  const ViewPost({
    super.key,
    required this.post,
    required this.likedMeta,
  });
  final Post post;
  final bool likedMeta;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Hero(
        tag: post.id!,
        child: SizedBox(
            height: double.infinity,
            width: double.infinity,
            child: PageView.builder(
              itemBuilder: (context, index) => InteractiveViewer(
                child: CachedNetworkImage(
                  imageUrl:
                      "${ApiConstants.baseUrl}/${post.mediaFiles[index].url!}",
                  fit: BoxFit.fitWidth,
                  progressIndicatorBuilder: (context, url, progress) =>
                      MediaLoading(
                          label: "Loading Image",
                          icon: Boxicons.bx_image,
                          progress: progress),
                ),
              ),
              itemCount: post.mediaFiles.length,
            )),
      ),
    );
  }
}
