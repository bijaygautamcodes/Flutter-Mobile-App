import 'dart:io';

import 'package:boxicons/boxicons.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rootnode/app/constant/api.dart';
import 'package:rootnode/app/constant/font.dart';
import 'package:rootnode/helper/media_helper.dart';
import 'package:rootnode/model/user/user.dart';
import 'package:rootnode/provider/session_provider.dart';
import 'package:rootnode/repository/user_repo.dart';
import 'package:rootnode/widgets/text_field.dart';

class EditProfile extends ConsumerStatefulWidget {
  const EditProfile({super.key, required this.user});
  final User user;

  @override
  ConsumerState<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends ConsumerState<EditProfile> {
  late final UserRepo _userRepo;
  XFile? avatar;
  bool hasSelectedAnImage = false;
  late final TextEditingController _fNameController;
  late final TextEditingController _lNameController;
  late final TextEditingController _emailController;
  late final TextEditingController _usernameController;
  late final GlobalKey<FormState> _formKey;
  @override
  void initState() {
    _userRepo = ref.read(userRepoProvider);
    _formKey = GlobalKey<FormState>();
    _fNameController = TextEditingController(text: widget.user.fname ?? "");
    _lNameController = TextEditingController(text: widget.user.lname ?? "");
    _emailController = TextEditingController(text: widget.user.email ?? "");
    _usernameController =
        TextEditingController(text: widget.user.username ?? "");
    super.initState();
  }

  @override
  void dispose() {
    _fNameController.dispose();
    _lNameController.dispose();
    _emailController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Edit Profile",
          style: RootNodeFontStyle.header,
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
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: const Color(0xFF111111),
        padding: const EdgeInsets.all(5),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Stack(
                  children: [
                    CircleAvatar(
                      maxRadius: 48,
                      foregroundImage: !hasSelectedAnImage
                          ? CachedNetworkImageProvider(
                              "${ApiConstants.baseUrl}/${widget.user.avatar!}",
                              maxHeight: 256,
                              maxWidth: 256,
                              cacheKey: widget.user.avatar,
                            )
                          : FileImage(File(avatar!.path)) as ImageProvider,
                    ),
                    Positioned(
                      right: 0,
                      bottom: 5,
                      child: GestureDetector(
                        onTap: _handleImage,
                        child: Container(
                          height: 32,
                          width: 32,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey,
                          ),
                          child: const Icon(
                            Boxicons.bx_pencil,
                            color: Colors.white70,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  margin: const EdgeInsets.only(left: 20),
                  alignment: Alignment.centerLeft,
                  child: Text("First Name", style: RootNodeFontStyle.body),
                ),
                RootNodeTextField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: _fNameController,
                  validator: (p0) async {
                    if (p0 == null) return "This field is required";
                    if (p0.length < 3) {
                      return "Must be at least three char long";
                    }
                    return null;
                  },
                  hintText: 'First Name',
                  type: TextFieldTypes.email,
                ),
                Container(
                  margin: const EdgeInsets.only(left: 20),
                  alignment: Alignment.centerLeft,
                  child: Text("Last Name", style: RootNodeFontStyle.body),
                ),
                RootNodeTextField(
                  controller: _lNameController,
                  hintText: 'Last Name',
                  type: TextFieldTypes.email,
                ),
                Container(
                  margin: const EdgeInsets.only(left: 20),
                  alignment: Alignment.centerLeft,
                  child: Text("Email", style: RootNodeFontStyle.body),
                ),
                RootNodeTextField(
                  controller: _emailController,
                  type: TextFieldTypes.email,
                  hintText: 'Email',
                ),
                Container(
                  margin: const EdgeInsets.only(left: 20),
                  alignment: Alignment.centerLeft,
                  child: Text("Username", style: RootNodeFontStyle.body),
                ),
                RootNodeTextField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: _userNameValidator,
                  controller: _usernameController,
                  hintText: 'Username',
                  type: TextFieldTypes.email,
                ),
                const SizedBox(height: 10),
                Consumer(builder: (context, ref, child) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    width: double.infinity,
                    height: 60,
                    child: ElevatedButton(
                      onPressed: () => _saveUser(ref),
                      child: Text("Save", style: RootNodeFontStyle.body),
                    ),
                  );
                })
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<String?> _userNameValidator(String? value) async {
    if (value == null) return "Username cannot be empty";
    if (value.length < 5) {
      return "Username must be 5 char long";
    }
    if (value == widget.user.username) return null;
    return await _fetchUserNamePredicate(value)
        ? null
        : "Username already taken";
  }

  Future<bool> _fetchUserNamePredicate(String un) async {
    return await _userRepo.checkIfUsernameAvailable(username: un);
  }

  _handleImage() async {
    showDialog(
      barrierColor: Colors.black87,
      context: context,
      builder: (dialogContex) => AlertDialog(
        backgroundColor: Colors.white70,
        title: Text('Choose an option',
            textAlign: TextAlign.center,
            style: RootNodeFontStyle.body.copyWith(color: Colors.black)),
        actions: [
          TextButton(
            style: ButtonStyle(
              backgroundColor:
                  MaterialStateColor.resolveWith((states) => Colors.black12),
              minimumSize: MaterialStateProperty.resolveWith(
                  (states) => const Size(double.infinity, 50)),
            ),
            onPressed: () => _pickFile(ImageSource.camera),
            child: const Text('Camera', style: TextStyle(color: Colors.black)),
          ),
          TextButton(
            style: ButtonStyle(
              backgroundColor:
                  MaterialStateColor.resolveWith((states) => Colors.black12),
              minimumSize: MaterialStateProperty.resolveWith(
                  (states) => const Size(double.infinity, 50)),
            ),
            onPressed: () => _pickFile(ImageSource.gallery),
            child: const Text('Gallery', style: TextStyle(color: Colors.black)),
          )
        ],
        icon: const Icon(Boxicons.bx_image_add, color: Colors.black),
        actionsAlignment: MainAxisAlignment.spaceEvenly,
        alignment: Alignment.center,
        actionsOverflowButtonSpacing: 10,
      ),
    );
  }

  _pickFile(ImageSource source) async {
    Navigator.of(context, rootNavigator: true).pop('dialog');
    MediaHelper helper = MediaHelper.instance;
    CroppedFile? crop = await helper
        .pickImage(source: source)
        .then(
          (value) async => value != null
              ? await helper.crop(file: value, cropStyle: CropStyle.circle)
              : null,
        )
        .then((value) => value);
    if (crop != null) {
      avatar = XFile(crop.path);
      hasSelectedAnImage = true;
    } else {
      hasSelectedAnImage = false;
    }
    setState(() {});
  }

  void _saveUser(WidgetRef ref) async {
    if (!_formKey.currentState!.validate()) return;
    final User updatedUser = User(
      fname: _fNameController.text,
      lname: _lNameController.text,
      username: _usernameController.text,
      email: _emailController.text,
    );
    User? user = await _userRepo.updateUser(user: updatedUser, avatar: avatar);
    if (user != null) {
      ref.read(sessionProvider.notifier).updateUser(user: user);
    }
    if (mounted) Navigator.of(context).pop();
  }
}
