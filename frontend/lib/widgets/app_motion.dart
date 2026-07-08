import 'dart:async';
import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class AppScrollBehavior extends MaterialScrollBehavior {
  const AppScrollBehavior();

  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
    PointerDeviceKind.trackpad,
    PointerDeviceKind.stylus,
  };

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    return const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics());
  }

  @override
  Widget buildOverscrollIndicator(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) {
    return StretchingOverscrollIndicator(
      axisDirection: details.direction,
      child: GlowingOverscrollIndicator(
        axisDirection: details.direction,
        color: const Color(0xFFFFB570),
        child: child,
      ),
    );
  }
}

class AppInteractionFeedback extends StatefulWidget {
  final Widget child;

  const AppInteractionFeedback({super.key, required this.child});

  @override
  State<AppInteractionFeedback> createState() => _AppInteractionFeedbackState();
}

class _AppInteractionFeedbackState extends State<AppInteractionFeedback>
    with TickerProviderStateMixin {
  final List<_TapPulse> _pulses = [];
  Timer? _scrollTimer;
  bool _showScrollPulse = false;

  @override
  void dispose() {
    for (final pulse in _pulses) {
      pulse.controller.dispose();
    }
    _scrollTimer?.cancel();
    super.dispose();
  }

  void _showTapPulse(PointerDownEvent event) {
    final controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 420),
    );
    late final _TapPulse pulse;
    pulse = _TapPulse(position: event.position, controller: controller);

    controller.addStatusListener((status) {
      if (status != AnimationStatus.completed) return;
      if (!mounted) return;
      setState(() => _pulses.remove(pulse));
      controller.dispose();
    });

    setState(() => _pulses.add(pulse));
    controller.forward();
  }

  bool _handleScroll(ScrollNotification notification) {
    if (notification is! ScrollUpdateNotification &&
        notification is! UserScrollNotification) {
      return false;
    }

    if (!_showScrollPulse) {
      setState(() => _showScrollPulse = true);
    }

    _scrollTimer?.cancel();
    _scrollTimer = Timer(const Duration(milliseconds: 320), () {
      if (mounted) setState(() => _showScrollPulse = false);
    });

    return false;
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: _handleScroll,
      child: Listener(
        behavior: HitTestBehavior.translucent,
        onPointerDown: _showTapPulse,
        child: Stack(
          fit: StackFit.expand,
          children: [
            widget.child,
            Positioned.fill(
              child: IgnorePointer(
                child: Stack(
                  children: [
                    ..._pulses.map((pulse) {
                      final curved = CurvedAnimation(
                        parent: pulse.controller,
                        curve: Curves.easeOutCubic,
                      );
                      return AnimatedBuilder(
                        animation: curved,
                        builder: (context, child) {
                          final size = 18 + (curved.value * 42);
                          return Positioned(
                            left: pulse.position.dx - (size / 2),
                            top: pulse.position.dy - (size / 2),
                            width: size,
                            height: size,
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: const Color(
                                  0xFFFFB570,
                                ).withValues(alpha: 0.22 * (1 - curved.value)),
                                border: Border.all(
                                  color: const Color(0xFFFF9A4D).withValues(
                                    alpha: 0.28 * (1 - curved.value),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    }),
                    AnimatedPositioned(
                      duration: const Duration(milliseconds: 180),
                      curve: Curves.easeOutCubic,
                      right: _showScrollPulse ? 10 : 4,
                      top: 96,
                      bottom: 96,
                      child: AnimatedOpacity(
                        opacity: _showScrollPulse ? 1 : 0,
                        duration: const Duration(milliseconds: 180),
                        child: Container(
                          width: 5,
                          decoration: BoxDecoration(
                            color: const Color(
                              0xFFFFB570,
                            ).withValues(alpha: 0.55),
                            borderRadius: BorderRadius.circular(999),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(
                                  0xFFFF9A4D,
                                ).withValues(alpha: 0.22),
                                blurRadius: 12,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TapPulse {
  final Offset position;
  final AnimationController controller;

  const _TapPulse({required this.position, required this.controller});
}

class AppBounceTap extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final double pressedScale;

  const AppBounceTap({
    super.key,
    required this.child,
    required this.onTap,
    this.pressedScale = 0.95,
  });

  @override
  State<AppBounceTap> createState() => _AppBounceTapState();
}

class _AppBounceTapState extends State<AppBounceTap>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 110),
      reverseDuration: const Duration(milliseconds: 170),
    );
    _scale = Tween<double>(
      begin: 1,
      end: widget.pressedScale,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _release() async {
    if (!mounted) return;
    await _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: widget.onTap == null ? null : (_) => _controller.forward(),
      onTapCancel: widget.onTap == null ? null : _release,
      onTapUp: widget.onTap == null
          ? null
          : (_) async {
              await _release();
              widget.onTap?.call();
            },
      child: ScaleTransition(scale: _scale, child: widget.child),
    );
  }
}

class AppPageTransition extends StatelessWidget {
  final int transitionKey;
  final Widget child;

  const AppPageTransition({
    super.key,
    required this.transitionKey,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 320),
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeInCubic,
      transitionBuilder: (child, animation) {
        final slide = Tween<Offset>(
          begin: const Offset(0.025, 0.02),
          end: Offset.zero,
        ).animate(animation);
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(position: slide, child: child),
        );
      },
      child: KeyedSubtree(key: ValueKey<int>(transitionKey), child: child),
    );
  }
}
