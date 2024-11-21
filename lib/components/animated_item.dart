import 'package:animated_list/components/placeholder_widget.dart';
import 'package:flutter/material.dart';

class AnimatedItem extends StatefulWidget {
  const AnimatedItem({
    super.key,
    this.onTap,
  });

  final VoidCallback? onTap;

  @override
  State<AnimatedItem> createState() => _AnimatedItemState();
}

class _AnimatedItemState extends State<AnimatedItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _buttonScaleAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );

    _buttonScaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Transform.scale(
            scale: _buttonScaleAnimation.value,
            child: PlaceholderWidget(
              onTap: () async {
                await _animationController.forward();
                await _animationController.reverse();
                widget.onTap?.call();
              },
              radius: 20,
              color: Colors.white,
              border: Border.all(
                color: Colors.grey.shade800,
              ),
              child: PlaceholderWidget(
                radius: 30,
                color: Colors.grey.shade300,
                label: "Imagem",
              ),
            ),
          );
        });
  }
}
