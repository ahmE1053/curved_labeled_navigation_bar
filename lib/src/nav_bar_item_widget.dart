import 'package:flutter/material.dart';
import 'package:universal_io/io.dart';

class NavBarItemWidget extends StatefulWidget {
  final double position;
  final int length;
  final int index;
  final int currentIndex;
  final ValueChanged<int> onTap;
  final Widget child;
  final String? label;
  final TextStyle? labelStyle;

  NavBarItemWidget({
    required this.onTap,
    required this.position,
    required this.length,
    required this.index,
    required this.currentIndex,
    required this.child,
    this.label,
    this.labelStyle,
  });

  @override
  State<NavBarItemWidget> createState() => _NavBarItemWidgetState();
}

class _NavBarItemWidgetState extends State<NavBarItemWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController animationController;

  bool get showLabel => widget.currentIndex == widget.index;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      value: showLabel ? 1 : 0,
      duration: Duration(milliseconds: 400),
    );
  }

  @override
  void didUpdateWidget(covariant NavBarItemWidget oldWidget) {
    if (showLabel) {
      animationController.forward();
    } else {
      animationController.reverse();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => widget.onTap(widget.index),
        child: _buildItem(),
      ),
    );
  }

  Widget _buildItem() {
    if (widget.label == null) {
      return Column(
        children: [
          Expanded(child: _buildIcon()),
          SizedBox(height: Platform.isIOS ? 20.0 : 0),
        ],
      );
    }
    return Column(
      children: [
        Flexible(
          flex: 1,
          child: _buildIcon(),
        ),
        Center(
          child: AnimatedBuilder(
            animation: animationController,
            builder: (context, child) {
              return SizeTransition(
                sizeFactor: animationController,
                child: FadeTransition(
                  opacity: animationController,
                  child: child,
                ),
              );
            },
            child: Center(
              child: Column(
                children: [
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      widget.label ?? '',
                      textAlign: TextAlign.center,
                      style: widget.labelStyle,
                    ),
                  ),
                  SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildIcon() {
    final desiredPosition = 1.0 / widget.length * widget.index;
    final difference = (widget.position - desiredPosition).abs();
    final verticalAlignment = 1 - widget.length * difference;
    final opacity = widget.length * difference;
    return Transform.translate(
      offset: Offset(
        0,
        difference < 1.0 / widget.length ? verticalAlignment * 40 : 0,
      ),
      child: Opacity(
        opacity: difference < 1.0 / widget.length * 0.99 ? opacity : 1.0,
        child: widget.child,
      ),
    );
  }
}
