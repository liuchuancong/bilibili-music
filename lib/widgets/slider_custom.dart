import 'dart:async';
import 'package:flutter/material.dart';

// 保留您原有的隐藏滑块样式类
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

// 保留您原有的滑块组件（样式和动画不变）
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

class VolumeControl extends StatefulWidget {
  final double volume; // 当前音量（0-1范围）
  final ValueChanged<double> onVolumeChanged; // 音量变化回调
  final Color? activeColor;
  final Color? inactiveColor;
  final VoidCallback? onPressed; // 点击事件回调
  const VolumeControl({
    super.key,
    required this.volume,
    required this.onVolumeChanged,
    required this.activeColor,
    required this.inactiveColor,
    @required this.onPressed,
  });

  @override
  State<VolumeControl> createState() => _VolumeControlState();
}

class _VolumeControlState extends State<VolumeControl> {
  late OverlayEntry? _overlayEntry;
  bool isShowVolume = false;
  static const double _barHeight = 150.0;
  Timer? _hideTimer;
  final GlobalKey volumeButton = GlobalKey();
  bool _isIconHovered = false;
  void _showVolumeBar() {
    if (isShowVolume) return;
    final renderBox = volumeButton.currentContext!.findRenderObject() as RenderBox;
    final position = renderBox.localToGlobal(Offset.zero);

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        left: position.dx + (renderBox.size.width - 40) / 2,
        top: position.dy - _barHeight - 8,
        width: 40,
        height: _barHeight,
        child: _buildVolumeBar(),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
    if (mounted) {
      setState(() {
        isShowVolume = true;
        _hideTimer?.cancel();
        _hideTimer = Timer(const Duration(seconds: 2), _hideVolumeBar);
      });
    }
  }

  void _hideVolumeBar() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    if (mounted) {
      setState(() => isShowVolume = false);
    }
    _hideTimer?.cancel();
    _hideTimer = null;
  }

  void _handleVolumeDrag(DragUpdateDetails details) {
    const maxDeltaPerUpdate = _barHeight * 0.1;
    final clampedDelta = details.delta.dy.clamp(-maxDeltaPerUpdate, maxDeltaPerUpdate);
    if (mounted) {
      setState(() {
        isShowVolume = true;
        _hideTimer?.cancel();
        _hideTimer = Timer(const Duration(seconds: 2), _hideVolumeBar);
      });
    }
    final deltaRatio = -clampedDelta / _barHeight;
    final newVolume = (widget.volume + deltaRatio).clamp(0.0, 1.0);

    if (newVolume != widget.volume) {
      _overlayEntry?.markNeedsBuild();
      _hideTimer?.cancel();
      _hideTimer = Timer(const Duration(seconds: 2), _hideVolumeBar);
    }
    widget.onVolumeChanged(newVolume);
  }

  Widget _buildVolumeBar() {
    final sliderPosition = (widget.volume * _barHeight).clamp(10, _barHeight - 25).toDouble();
    return GestureDetector(
      onVerticalDragUpdate: _handleVolumeDrag,
      onTap: _hideVolumeBar,
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: Center(child: VerticalDivider(color: widget.activeColor, thickness: 4)),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: sliderPosition,
              child: CircleAvatar(radius: 6, backgroundColor: widget.activeColor),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // 根据音量值切换图标
    IconData getVolumeIcon() {
      if (widget.volume <= 0) return Icons.volume_off_rounded;
      if (widget.volume < 0.5) return Icons.volume_down_rounded;
      return Icons.volume_up_rounded;
    }

    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final iconColor = _isIconHovered
        ? (isDarkMode ? Colors.white : Colors.black87) // hover时的颜色（与滑块activeColor一致）
        : (isDarkMode ? Colors.white54 : Colors.black54); // 非hover时的颜色

    return MouseRegion(
      onEnter: (_) {
        setState(() => _isIconHovered = true);
        _showVolumeBar();
      },
      onExit: (_) {
        setState(() => _isIconHovered = false);
        _hideTimer?.cancel();
        _hideTimer = Timer(const Duration(seconds: 2), _hideVolumeBar);
      },
      child: IconButton(
          icon: Icon(
            getVolumeIcon(),
            key: volumeButton,
            color: iconColor,
            size: 20,
          ),
          onPressed: widget.onPressed),
    );
  }
}
