import 'package:flutter/material.dart';

class ProfileSkeleton extends StatefulWidget {
  const ProfileSkeleton({super.key});

  @override
  State<ProfileSkeleton> createState() => _ProfileSkeletonState();
}

class _ProfileSkeletonState extends State<ProfileSkeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    final baseColor =
        colors.surfaceContainerHighest.withValues(alpha: 0.35);
    final highlightColor =
        colors.surfaceContainerHighest.withValues(alpha: 0.15);

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: Column(
            children: [
              const SizedBox(height: 16),

              /// Avatar
              _ShimmerBox.circle(
                size: 92,
                controller: _controller,
                baseColor: baseColor,
                highlightColor: highlightColor,
              ),

              const SizedBox(height: 14),

              /// Name
              _ShimmerBox.rect(
                width: 160,
                height: 24,
                radius: 8,
                controller: _controller,
                baseColor: baseColor,
                highlightColor: highlightColor,
              ),

              const SizedBox(height: 8),

              /// Username
              _ShimmerBox.rect(
                width: 90,
                height: 16,
                radius: 6,
                controller: _controller,
                baseColor: baseColor,
                highlightColor: highlightColor,
              ),

              const SizedBox(height: 12),

              /// Bio lines
              _ShimmerBox.rect(
                width: 240,
                height: 14,
                radius: 6,
                controller: _controller,
                baseColor: baseColor,
                highlightColor: highlightColor,
              ),
              const SizedBox(height: 6),
              _ShimmerBox.rect(
                width: 180,
                height: 14,
                radius: 6,
                controller: _controller,
                baseColor: baseColor,
                highlightColor: highlightColor,
              ),

              const SizedBox(height: 24),

              /// Stats row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(3, (_) {
                  return Column(
                    children: [
                      _ShimmerBox.rect(
                        width: 45,
                        height: 20,
                        radius: 6,
                        controller: _controller,
                        baseColor: baseColor,
                        highlightColor: highlightColor,
                      ),
                      const SizedBox(height: 6),
                      _ShimmerBox.rect(
                        width: 65,
                        height: 14,
                        radius: 6,
                        controller: _controller,
                        baseColor: baseColor,
                        highlightColor: highlightColor,
                      ),
                    ],
                  );
                }),
              ),

              const SizedBox(height: 24),

              /// Button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _ShimmerBox.rect(
                  width: double.infinity,
                  height: 52,
                  radius: 14,
                  controller: _controller,
                  baseColor: baseColor,
                  highlightColor: highlightColor,
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }
}

/// ===============================
/// GLOBAL SHIMMER BLOCK (REUSABLE)
/// ===============================
class _ShimmerBox extends StatelessWidget {
  final double width;
  final double height;
  final double radius;
  final bool isCircle;
  final Animation<double> controller;
  final Color baseColor;
  final Color highlightColor;

  const _ShimmerBox.rect({
    required this.width,
    required this.height,
    required this.radius,
    required this.controller,
    required this.baseColor,
    required this.highlightColor,
  }) : isCircle = false;

  const _ShimmerBox.circle({
    required double size,
    required this.controller,
    required this.baseColor,
    required this.highlightColor,
  })  : width = size,
        height = size,
        radius = size / 2,
        isCircle = true;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        return Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            shape: isCircle ? BoxShape.circle : BoxShape.rectangle,
            borderRadius:
                isCircle ? null : BorderRadius.circular(radius),
            gradient: LinearGradient(
              begin: Alignment(-1.2 + controller.value * 2.4, 0),
              end: Alignment(1.2 + controller.value * 2.4, 0),
              colors: [
                baseColor,
                highlightColor,
                baseColor,
              ],
              stops: const [0.2, 0.5, 0.8],
            ),
          ),
        );
      },
    );
  }
}
