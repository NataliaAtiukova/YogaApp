import 'dart:math';

import 'package:flutter/material.dart';

import '../models/exercise.dart';

class PoseAnimator extends StatefulWidget {
  const PoseAnimator({super.key, required this.pose, required this.isRunning});

  final PoseType pose;
  final bool isRunning;

  @override
  State<PoseAnimator> createState() => _PoseAnimatorState();
}

class _PoseAnimatorState extends State<PoseAnimator>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );
    if (widget.isRunning) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(covariant PoseAnimator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.pose != widget.pose) {
      _controller.value = 0;
    }
    if (widget.isRunning && !_controller.isAnimating) {
      _controller.repeat();
    } else if (!widget.isRunning && _controller.isAnimating) {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return CustomPaint(
          painter: PosePainter(pose: widget.pose, t: _controller.value),
        );
      },
    );
  }
}

class PosePainter extends CustomPainter {
  PosePainter({required this.pose, required this.t});

  final PoseType pose;
  final double t;

  @override
  void paint(Canvas canvas, Size size) {
    final accent = const Color(0xFF2F6F6D);
    final muted = const Color(0xFFE5ECE8);

    final Paint baseLine = Paint()
      ..color = accent.withAlpha(44)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 9
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final Paint line = Paint()
      ..color = accent
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final Paint joint = Paint()
      ..color = accent.withAlpha(160)
      ..style = PaintingStyle.fill;

    final Paint torsoFill = Paint()
      ..color = accent.withAlpha(30)
      ..style = PaintingStyle.fill;

    final Paint headFill = Paint()
      ..color = accent.withAlpha(70)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
      Offset(size.width * 0.2, size.height * 0.2),
      size.shortestSide * 0.18,
      Paint()..color = muted,
    );

    final double breath = 0.5 + 0.5 * sin(2 * pi * t);

    final _Skeleton skeleton = switch (pose) {
      PoseType.breath => _poseBreath(size, breath),
      PoseType.catCow => _poseCatCow(size, breath),
      PoseType.child => _poseChild(size, breath),
      PoseType.downDog => _poseDownDog(size, breath),
      PoseType.forwardFold => _poseForwardFold(size, breath),
      PoseType.kneesToChest => _poseKneesToChest(size, breath),
      PoseType.twist => _poseTwist(size, breath),
      PoseType.plank => _posePlank(size, breath),
      PoseType.seatedStretch => _poseSeatedStretch(size, breath),
      PoseType.openChest => _poseOpenChest(size, breath),
      PoseType.relax => _poseRelax(size, breath),
    };

    _drawSkeleton(
      canvas,
      size,
      skeleton,
      baseLine,
      line,
      joint,
      torsoFill,
      headFill,
    );
  }

  @override
  bool shouldRepaint(covariant PosePainter oldDelegate) {
    return oldDelegate.t != t || oldDelegate.pose != pose;
  }

  _Skeleton _poseBreath(Size size, double breath) {
    final w = size.width;
    final h = size.height;
    final centerX = w * 0.52;
    final baseY = h * 0.82;
    final lift = _lerp(0.0, 1.0, breath);

    final hip = Offset(centerX, baseY - 6);
    final shoulderY = baseY - h * 0.24 - 8 * lift;
    final neck = Offset(centerX, shoulderY - 10);
    final head = Offset(centerX, shoulderY - 30);

    final shoulderL = Offset(centerX - 22, shoulderY);
    final shoulderR = Offset(centerX + 22, shoulderY);

    final elbowL = _mix(
      Offset(centerX - 30, shoulderY + 28),
      Offset(centerX - 10, shoulderY - 36),
      lift,
    );
    final wristL = _mix(
      Offset(centerX - 32, shoulderY + 60),
      Offset(centerX - 6, shoulderY - 64),
      lift,
    );
    final elbowR = _mix(
      Offset(centerX + 30, shoulderY + 28),
      Offset(centerX + 10, shoulderY - 36),
      lift,
    );
    final wristR = _mix(
      Offset(centerX + 32, shoulderY + 60),
      Offset(centerX + 6, shoulderY - 64),
      lift,
    );

    return _Skeleton(
      head: head,
      neck: neck,
      shoulderL: shoulderL,
      shoulderR: shoulderR,
      elbowL: elbowL,
      elbowR: elbowR,
      wristL: wristL,
      wristR: wristR,
      hipL: hip.translate(-14, 0),
      hipR: hip.translate(14, 0),
      kneeL: Offset(centerX - 18, baseY + 24),
      kneeR: Offset(centerX + 18, baseY + 24),
      ankleL: Offset(centerX - 18, baseY + 58),
      ankleR: Offset(centerX + 18, baseY + 58),
    );
  }

  _Skeleton _poseCatCow(Size size, double breath) {
    final w = size.width;
    final h = size.height;
    final curve = _lerp(-0.035, 0.045, breath);

    final shoulderL = Offset(w * 0.46, h * (0.64 + curve));
    final shoulderR = Offset(w * 0.58, h * (0.64 + curve));
    final neck = Offset(w * 0.40, h * (0.62 + curve));
    final head = Offset(w * 0.34, h * (0.60 + curve));

    return _Skeleton(
      head: head,
      neck: neck,
      shoulderL: shoulderL,
      shoulderR: shoulderR,
      elbowL: Offset(w * 0.40, h * 0.72),
      elbowR: Offset(w * 0.60, h * 0.72),
      wristL: Offset(w * 0.32, h * 0.76),
      wristR: Offset(w * 0.68, h * 0.76),
      hipL: Offset(w * 0.48, h * (0.76 + curve)),
      hipR: Offset(w * 0.56, h * (0.76 + curve)),
      kneeL: Offset(w * 0.42, h * 0.86),
      kneeR: Offset(w * 0.60, h * 0.86),
      ankleL: Offset(w * 0.38, h * 0.92),
      ankleR: Offset(w * 0.64, h * 0.92),
    );
  }

  _Skeleton _poseChild(Size size, double breath) {
    final w = size.width;
    final h = size.height;
    final sink = _lerp(0.0, 1.0, breath);

    final head = Offset(w * 0.30, h * (0.74 + 0.01 * sink));
    final neck = Offset(w * 0.36, h * 0.72);

    return _Skeleton(
      head: head,
      neck: neck,
      shoulderL: Offset(w * 0.42, h * 0.72),
      shoulderR: Offset(w * 0.50, h * 0.72),
      elbowL: Offset(w * 0.36, h * 0.70),
      elbowR: Offset(w * 0.44, h * 0.70),
      wristL: Offset(w * 0.28, h * 0.70),
      wristR: Offset(w * 0.36, h * 0.70),
      hipL: Offset(w * 0.58, h * (0.76 + 0.01 * sink)),
      hipR: Offset(w * 0.62, h * (0.76 + 0.01 * sink)),
      kneeL: Offset(w * 0.60, h * 0.84),
      kneeR: Offset(w * 0.66, h * 0.84),
      ankleL: Offset(w * 0.66, h * 0.90),
      ankleR: Offset(w * 0.72, h * 0.90),
    );
  }

  _Skeleton _poseDownDog(Size size, double breath) {
    final w = size.width;
    final h = size.height;
    final lift = _lerp(0.0, 1.0, breath);

    final head = Offset(w * 0.44, h * (0.72 + 0.01 * lift));
    final neck = Offset(w * 0.46, h * (0.68 + 0.01 * lift));

    return _Skeleton(
      head: head,
      neck: neck,
      shoulderL: Offset(w * 0.38, h * 0.66),
      shoulderR: Offset(w * 0.46, h * 0.68),
      elbowL: Offset(w * 0.34, h * 0.72),
      elbowR: Offset(w * 0.40, h * 0.74),
      wristL: Offset(w * 0.28, h * 0.78),
      wristR: Offset(w * 0.36, h * 0.80),
      hipL: Offset(w * 0.54, h * (0.52 - 0.02 * lift)),
      hipR: Offset(w * 0.60, h * (0.52 - 0.02 * lift)),
      kneeL: Offset(w * 0.66, h * 0.70),
      kneeR: Offset(w * 0.72, h * 0.72),
      ankleL: Offset(w * 0.70, h * 0.88),
      ankleR: Offset(w * 0.80, h * 0.88),
    );
  }

  _Skeleton _poseForwardFold(Size size, double breath) {
    final w = size.width;
    final h = size.height;
    final hipCenter = Offset(w * 0.52, h * 0.60);
    final foldAngle = _lerp(-1.35, -1.15, breath);
    final head = _polar(hipCenter, h * 0.22, foldAngle);
    final neck = _mix(hipCenter, head, 0.65);
    final shoulderCenter = _mix(hipCenter, head, 0.6);

    return _Skeleton(
      head: head,
      neck: neck,
      shoulderL: shoulderCenter.translate(-12, -6),
      shoulderR: shoulderCenter.translate(12, -6),
      elbowL: head.translate(-12, 18),
      elbowR: head.translate(12, 18),
      wristL: head.translate(-8, 36),
      wristR: head.translate(8, 36),
      hipL: hipCenter.translate(-14, 0),
      hipR: hipCenter.translate(14, 0),
      kneeL: Offset(w * 0.50, h * 0.76),
      kneeR: Offset(w * 0.54, h * 0.76),
      ankleL: Offset(w * 0.50, h * 0.90),
      ankleR: Offset(w * 0.56, h * 0.90),
    );
  }

  _Skeleton _poseKneesToChest(Size size, double breath) {
    final w = size.width;
    final h = size.height;
    final curl = _lerp(0.0, 1.0, breath);

    final head = Offset(w * 0.22, h * 0.70);
    final neck = Offset(w * 0.30, h * 0.70);
    final shoulderL = Offset(w * 0.38, h * 0.70);
    final shoulderR = Offset(w * 0.42, h * 0.70);

    final hipCenter = Offset(w * 0.58, h * 0.72);
    final kneeLift = -h * 0.10 * curl;
    final kneeL = Offset(w * 0.56, h * 0.62 + kneeLift);
    final kneeR = Offset(w * 0.62, h * 0.64 + kneeLift);
    final ankleL = Offset(w * 0.50, h * 0.68 + kneeLift);
    final ankleR = Offset(w * 0.66, h * 0.70 + kneeLift);

    return _Skeleton(
      head: head,
      neck: neck,
      shoulderL: shoulderL,
      shoulderR: shoulderR,
      elbowL: Offset(w * 0.44, h * 0.64),
      elbowR: Offset(w * 0.50, h * 0.62),
      wristL: Offset(w * 0.52, h * 0.60 + kneeLift * 0.6),
      wristR: Offset(w * 0.56, h * 0.58 + kneeLift * 0.6),
      hipL: hipCenter.translate(-12, 0),
      hipR: hipCenter.translate(12, 0),
      kneeL: kneeL,
      kneeR: kneeR,
      ankleL: ankleL,
      ankleR: ankleR,
    );
  }

  _Skeleton _poseTwist(Size size, double breath) {
    final w = size.width;
    final h = size.height;
    final twist = sin(2 * pi * t) * 0.6;
    final shoulderCenter = Offset(w * 0.52 + 6 * twist, h * 0.58);
    final head = Offset(w * 0.52 + 8 * twist, h * 0.48);

    return _Skeleton(
      head: head,
      neck: Offset(shoulderCenter.dx, h * 0.52),
      shoulderL: shoulderCenter.translate(-16, 0),
      shoulderR: shoulderCenter.translate(16, 0),
      elbowL: Offset(w * 0.48 + 6 * twist, h * 0.66),
      elbowR: Offset(w * 0.64 + 8 * twist, h * 0.60),
      wristL: Offset(w * 0.56 + 8 * twist, h * 0.78),
      wristR: Offset(w * 0.70 + 10 * twist, h * 0.54),
      hipL: Offset(w * 0.48, h * 0.74),
      hipR: Offset(w * 0.56, h * 0.74),
      kneeL: Offset(w * 0.44, h * 0.80),
      kneeR: Offset(w * 0.60, h * 0.80),
      ankleL: Offset(w * 0.46, h * 0.84),
      ankleR: Offset(w * 0.58, h * 0.84),
    );
  }

  _Skeleton _posePlank(Size size, double breath) {
    final w = size.width;
    final h = size.height;
    final lift = _lerp(-4, 4, breath);

    return _Skeleton(
      head: Offset(w * 0.22, h * 0.60 + lift),
      neck: Offset(w * 0.28, h * 0.62 + lift),
      shoulderL: Offset(w * 0.34, h * 0.62 + lift),
      shoulderR: Offset(w * 0.38, h * 0.62 + lift),
      elbowL: Offset(w * 0.36, h * 0.70 + lift),
      elbowR: Offset(w * 0.40, h * 0.70 + lift),
      wristL: Offset(w * 0.38, h * 0.78 + lift),
      wristR: Offset(w * 0.42, h * 0.78 + lift),
      hipL: Offset(w * 0.58, h * 0.64 + lift),
      hipR: Offset(w * 0.62, h * 0.64 + lift),
      kneeL: Offset(w * 0.74, h * 0.70 + lift),
      kneeR: Offset(w * 0.78, h * 0.70 + lift),
      ankleL: Offset(w * 0.84, h * 0.74 + lift),
      ankleR: Offset(w * 0.88, h * 0.74 + lift),
    );
  }

  _Skeleton _poseSeatedStretch(Size size, double breath) {
    final w = size.width;
    final h = size.height;
    final lift = _lerp(0.0, 1.0, breath);
    final shoulderCenter = Offset(w * 0.52, h * 0.58);

    return _Skeleton(
      head: Offset(w * 0.52, h * (0.46 - 0.01 * lift)),
      neck: Offset(w * 0.52, h * 0.52),
      shoulderL: shoulderCenter.translate(-16, 0),
      shoulderR: shoulderCenter.translate(16, 0),
      elbowL: Offset(w * 0.42, h * (0.60 - 0.04 * lift)),
      elbowR: Offset(w * 0.62, h * (0.60 - 0.04 * lift)),
      wristL: Offset(w * 0.46, h * (0.50 - 0.06 * lift)),
      wristR: Offset(w * 0.58, h * (0.50 - 0.06 * lift)),
      hipL: Offset(w * 0.48, h * 0.74),
      hipR: Offset(w * 0.56, h * 0.74),
      kneeL: Offset(w * 0.44, h * 0.80),
      kneeR: Offset(w * 0.60, h * 0.80),
      ankleL: Offset(w * 0.46, h * 0.84),
      ankleR: Offset(w * 0.58, h * 0.84),
    );
  }

  _Skeleton _poseOpenChest(Size size, double breath) {
    final w = size.width;
    final h = size.height;
    final lift = _lerp(0.0, 1.0, breath);
    final shoulderCenter = Offset(w * 0.52, h * 0.58 - 2 * lift);

    return _Skeleton(
      head: Offset(w * 0.52, h * (0.46 - 0.01 * lift)),
      neck: Offset(w * 0.52, h * 0.52),
      shoulderL: shoulderCenter.translate(-16, 0),
      shoulderR: shoulderCenter.translate(16, 0),
      elbowL: Offset(w * 0.38, h * 0.64),
      elbowR: Offset(w * 0.66, h * 0.64),
      wristL: Offset(w * 0.36, h * 0.72),
      wristR: Offset(w * 0.68, h * 0.72),
      hipL: Offset(w * 0.48, h * 0.74),
      hipR: Offset(w * 0.56, h * 0.74),
      kneeL: Offset(w * 0.44, h * 0.80),
      kneeR: Offset(w * 0.60, h * 0.80),
      ankleL: Offset(w * 0.46, h * 0.84),
      ankleR: Offset(w * 0.58, h * 0.84),
    );
  }

  _Skeleton _poseRelax(Size size, double breath) {
    final w = size.width;
    final h = size.height;
    final float = _lerp(-3, 3, breath);

    return _Skeleton(
      head: Offset(w * 0.22, h * 0.74 + float),
      neck: Offset(w * 0.30, h * 0.74 + float),
      shoulderL: Offset(w * 0.38, h * 0.74 + float),
      shoulderR: Offset(w * 0.42, h * 0.74 + float),
      elbowL: Offset(w * 0.36, h * 0.68 + float),
      elbowR: Offset(w * 0.48, h * 0.68 + float),
      wristL: Offset(w * 0.34, h * 0.64 + float),
      wristR: Offset(w * 0.52, h * 0.64 + float),
      hipL: Offset(w * 0.60, h * 0.74 + float),
      hipR: Offset(w * 0.64, h * 0.74 + float),
      kneeL: Offset(w * 0.74, h * 0.76 + float),
      kneeR: Offset(w * 0.78, h * 0.76 + float),
      ankleL: Offset(w * 0.86, h * 0.78 + float),
      ankleR: Offset(w * 0.90, h * 0.78 + float),
    );
  }

  void _drawSkeleton(
    Canvas canvas,
    Size size,
    _Skeleton s,
    Paint base,
    Paint line,
    Paint joint,
    Paint torsoFill,
    Paint headFill,
  ) {
    final torso = Path()
      ..moveTo(s.shoulderL.dx, s.shoulderL.dy)
      ..lineTo(s.shoulderR.dx, s.shoulderR.dy)
      ..lineTo(s.hipR.dx, s.hipR.dy)
      ..lineTo(s.hipL.dx, s.hipL.dy)
      ..close();

    canvas.drawPath(torso, torsoFill);
    canvas.drawPath(torso, base);

    _drawChain(canvas, base, line, [s.shoulderL, s.elbowL, s.wristL]);
    _drawChain(canvas, base, line, [s.shoulderR, s.elbowR, s.wristR]);
    _drawChain(canvas, base, line, [s.hipL, s.kneeL, s.ankleL]);
    _drawChain(canvas, base, line, [s.hipR, s.kneeR, s.ankleR]);
    _drawChain(canvas, base, line, [s.shoulderL, s.hipL]);
    _drawChain(canvas, base, line, [s.shoulderR, s.hipR]);
    _drawChain(canvas, base, line, [s.neck, s.head]);

    final joints = [
      s.shoulderL,
      s.shoulderR,
      s.elbowL,
      s.elbowR,
      s.wristL,
      s.wristR,
      s.hipL,
      s.hipR,
      s.kneeL,
      s.kneeR,
      s.ankleL,
      s.ankleR,
    ];

    for (final point in joints) {
      canvas.drawCircle(point, size.shortestSide * 0.018, joint);
    }

    canvas.drawCircle(s.head, size.shortestSide * 0.06, headFill);
    canvas.drawCircle(s.head, size.shortestSide * 0.06, line);
  }

  void _drawChain(Canvas canvas, Paint base, Paint line, List<Offset> points) {
    if (points.length < 2) {
      return;
    }
    final path = Path()..moveTo(points.first.dx, points.first.dy);
    for (int i = 1; i < points.length; i++) {
      path.lineTo(points[i].dx, points[i].dy);
    }
    canvas.drawPath(path, base);
    canvas.drawPath(path, line);
  }

  Offset _mix(Offset a, Offset b, double t) {
    return Offset(a.dx + (b.dx - a.dx) * t, a.dy + (b.dy - a.dy) * t);
  }

  Offset _polar(Offset origin, double length, double angle) {
    return Offset(
      origin.dx + length * cos(angle),
      origin.dy + length * sin(angle),
    );
  }

  double _lerp(double a, double b, double t) {
    return a + (b - a) * t;
  }
}

class _Skeleton {
  const _Skeleton({
    required this.head,
    required this.neck,
    required this.shoulderL,
    required this.shoulderR,
    required this.elbowL,
    required this.elbowR,
    required this.wristL,
    required this.wristR,
    required this.hipL,
    required this.hipR,
    required this.kneeL,
    required this.kneeR,
    required this.ankleL,
    required this.ankleR,
  });

  final Offset head;
  final Offset neck;
  final Offset shoulderL;
  final Offset shoulderR;
  final Offset elbowL;
  final Offset elbowR;
  final Offset wristL;
  final Offset wristR;
  final Offset hipL;
  final Offset hipR;
  final Offset kneeL;
  final Offset kneeR;
  final Offset ankleL;
  final Offset ankleR;
}
