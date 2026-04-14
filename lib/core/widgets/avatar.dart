import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AvatarPicker extends StatefulWidget {
  final List<String> avatarList;
  final double avatarRadius;
  final String? initialAvatar;
  final Function(String) onAvatarChanged;

  const AvatarPicker({
    super.key,
    required this.avatarList,
    required this.onAvatarChanged,
    this.avatarRadius = 50,
    this.initialAvatar,
  });

  @override
  State<AvatarPicker> createState() => _AvatarPickerState();
}

class _AvatarPickerState extends State<AvatarPicker> {
  late PageController _pageController;
  late int initialPage;
  late String selectedAvatar;

  @override
  void initState() {
    super.initState();

    selectedAvatar = widget.initialAvatar ?? widget.avatarList[0];

    initialPage = 1000 * widget.avatarList.length;

    _pageController = PageController(
      initialPage: initialPage,
      viewportFraction: 0.40,
    );

    _pageController.addListener(() {
      setState(() {});
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onAvatarChanged(selectedAvatar);
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.avatarRadius * 2.5,
      child: PageView.builder(
        controller: _pageController,
        onPageChanged: (index) {
          final actualIndex = index % widget.avatarList.length;
          final avatar = widget.avatarList[actualIndex];

          setState(() {
            selectedAvatar = avatar;
          });

          widget.onAvatarChanged(avatar);
        },
        itemBuilder: (context, index) {
          final actualIndex = index % widget.avatarList.length;
          final avatarPath = widget.avatarList[actualIndex];

          final page =
          _pageController.hasClients ? _pageController.page ?? 0 : 0;
          final distance = (index - page).abs();

          double scale = 1.0 - (distance * 0.2);
          if (scale < 1.0) scale = 0.6;

          if (selectedAvatar == avatarPath) {
            scale = 1.1;
          }

          return Padding(
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 2).r,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  selectedAvatar = avatarPath;
                });

                widget.onAvatarChanged(avatarPath);

                _pageController.animateToPage(
                  index,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              },
              child: Transform.scale(
                scale: scale,
                child: CircleAvatar(
                  radius: widget.avatarRadius,
                  backgroundImage: AssetImage(avatarPath),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
