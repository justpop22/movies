import 'package:flutter/material.dart';

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
  _AvatarPickerState createState() => _AvatarPickerState();
}

class _AvatarPickerState extends State<AvatarPicker> {
  late PageController _pageController;
  late int initialPage;
  late String selectedAvatar;

  @override
  void initState() {
    super.initState();

    selectedAvatar = widget.initialAvatar ?? widget.avatarList[0];

    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onAvatarChanged(selectedAvatar);
    });

    initialPage = 1000 * widget.avatarList.length;
    _pageController = PageController(
      initialPage: initialPage,
      viewportFraction: 0.40,
    );
    _pageController.addListener(() {
      setState(() {});
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
          int actualIndex = index % widget.avatarList.length;
          final newAvatar = widget.avatarList[actualIndex];

          setState(() {
            selectedAvatar = newAvatar;
          });
          widget.onAvatarChanged(newAvatar);
        },
        itemBuilder: (context, index) {
          int actualIndex = index % widget.avatarList.length;
          String currentAvatarPath = widget.avatarList[actualIndex];

          double page = _pageController.hasClients
              ? _pageController.page ?? 0
              : 0;
          double distance = (index - page).abs();

          double scale = 1.0 - (distance * 0.2);
          if (scale < 1.0) scale = 0.6;

          if (selectedAvatar == currentAvatarPath) {
            scale = 1.1;
          }

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 2),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  selectedAvatar = currentAvatarPath;
                });
                widget.onAvatarChanged(currentAvatarPath);

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
                  backgroundImage: AssetImage(currentAvatarPath),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
