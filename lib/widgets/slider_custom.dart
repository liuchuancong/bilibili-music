import 'package:flutter/material.dart';

class HiddenThumbComponentShape extends SliderComponentShape {
  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) => const Size(0, 0);

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    // 不绘制任何内容，隐藏 Thumb
  }
}

class NoPaddingOverlayShape extends RoundSliderOverlayShape {
  const NoPaddingOverlayShape({super.overlayRadius = 10.0});

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) => Size.zero;
}

class AnimatedTrackHeightSlider extends StatefulWidget {
  final double value;
  final double max;
  final double min;
  final double trackHeight;
  final Color? activeColor;
  final Color? inactiveColor;
  final ValueChanged<double>? onChanged;
  final ValueChanged<double>? onChangeEnd;

  const AnimatedTrackHeightSlider({
    super.key,
    required this.value,
    required this.max,
    required this.min,
    this.trackHeight = 6,
    this.activeColor,
    this.inactiveColor,
    this.onChanged,
    this.onChangeEnd,
  });

  @override
  State<AnimatedTrackHeightSlider> createState() => _AnimatedTrackHeightSliderState();
}

class _AnimatedTrackHeightSliderState extends State<AnimatedTrackHeightSlider> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    final activeColor = widget.activeColor ?? (isDarkMode ? Colors.white : Colors.black87);
    final inactiveColor = widget.inactiveColor ?? (isDarkMode ? Colors.white30 : Colors.black26);

    return Focus(
      canRequestFocus: false, // 禁止抢焦点
      child: MouseRegion(
        onEnter: (_) => setState(() => isHovered = true),
        onExit: (_) => setState(() => isHovered = false),
        child: TweenAnimationBuilder<double>(
          tween: Tween<double>(
            begin: widget.trackHeight,
            end: isHovered ? widget.trackHeight + 6 : widget.trackHeight,
          ),
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          builder: (context, trackHeight, child) {
            return SliderTheme(
              data: SliderTheme.of(context).copyWith(
                trackHeight: trackHeight,
                thumbShape: HiddenThumbComponentShape(),
                overlayShape: const NoPaddingOverlayShape(overlayRadius: 10.0),
                activeTrackColor: activeColor,
                inactiveTrackColor: inactiveColor,
              ),
              child: child!,
            );
          },
          child: Slider(
            value: widget.value.clamp(widget.min, widget.max),
            max: widget.max,
            min: widget.min,
            activeColor: activeColor,
            inactiveColor: inactiveColor,
            onChanged: widget.onChanged,
            onChangeEnd: widget.onChangeEnd,
          ),
        ),
      ),
    );
  }
}
