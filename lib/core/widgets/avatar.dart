import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../modules/auth/manager/auth_provider.dart';

class AvatarPicker extends StatefulWidget {
  final List<String> avatarList;
  final double avatarRadius;

  AvatarPicker({
    required this.avatarList,
    this.avatarRadius = 50,
  });

  @override
  _AvatarPickerState createState() => _AvatarPickerState();
}

class _AvatarPickerState extends State<AvatarPicker> {
  late PageController _pageController;
  late int initialPage = 1000 * widget.avatarList.length;

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<AuthProvider>(context, listen: false);
    provider.setAvatar(widget.avatarList[0]);
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
    final provider = Provider.of<AuthProvider>(context);

    return SizedBox(
      height: widget.avatarRadius * 2.5,
      child: PageView.builder(
        controller: _pageController,
        onPageChanged: (index) {
          int actualIndex = index % widget.avatarList.length;
          provider.setAvatar(widget.avatarList[actualIndex]);
        },
        itemBuilder: (context, index) {
          int actualIndex = index % widget.avatarList.length;

          double page = _pageController.hasClients ? _pageController.page ?? 0 : 0;
          double distance = (index - page).abs();

          double scale = 1.0 - (distance * 0.2);
          if (scale < 1.0) scale = 0.6;

          if (provider.localSelectedAvatar == widget.avatarList[actualIndex]) {
            scale = 1.1;
          }

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0,
            horizontal: 2),
            child: GestureDetector(
              onTap: () {
                provider.setAvatar(widget.avatarList[actualIndex]);
                _pageController.animateToPage(
                  index,
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              },
              child: Transform.scale(
                scale: scale,
                child: CircleAvatar(
                  radius: widget.avatarRadius,
                  backgroundImage: AssetImage(widget.avatarList[actualIndex]),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
