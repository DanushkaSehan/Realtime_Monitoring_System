import 'package:flutter/material.dart';

class BackgroundWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (Rect bounds) {
        return LinearGradient(
          colors: [
            const Color.fromARGB(
                255, 122, 188, 221), // Color for the first wave
            Colors.blueAccent, // Color for the second wave
            Color.fromARGB(255, 132, 53, 174), // Color for the third wave
          ],
          stops: [0.0, 0.5, 1.0],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ).createShader(bounds);
      },
      blendMode: BlendMode.srcATop,
      child: Stack(
        children: [
          CustomPaint(
            painter: _WaveBackgroundPainter(150, true, 0.2),
            child: SizedBox.expand(),
          ),
          CustomPaint(
            painter: _WaveBackgroundPainter(150, false, 0.4),
            child: SizedBox.expand(),
          ),
          CustomPaint(
            painter: _WaveBackgroundPainter(150, true, 0.6),
            child: SizedBox.expand(),
          ),
        ],
      ),
    );
  }
}

class _WaveBackgroundPainter extends CustomPainter {
  final double waveHeight;
  final bool isTopRight;
  final double opacity;

  _WaveBackgroundPainter(this.waveHeight, this.isTopRight, this.opacity);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint();
    paint.color = Colors.white.withOpacity(opacity);

    final Path path = Path();
    path.lineTo(size.width, 0);

    if (isTopRight) {
      path.cubicTo(
        size.width * 0.7,
        waveHeight * 0.6,
        size.width * 0.4,
        waveHeight * 0.4,
        size.width,
        waveHeight,
      );
    } else {
      path.cubicTo(
        size.width * 0.7,
        size.height - waveHeight * 0.6,
        size.width * 0.4,
        size.height - waveHeight * 0.4,
        size.width,
        size.height - waveHeight,
      );
    }

    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);

    if (isTopRight) {
      path.cubicTo(
        size.width * 0.3,
        waveHeight * 1.4,
        size.width * 0.2,
        waveHeight * 1.2,
        0,
        waveHeight,
      );
    } else {
      path.cubicTo(
        size.width * 0.3,
        size.height - waveHeight * 1.4,
        size.width * 0.2,
        size.height - waveHeight * 1.2,
        0,
        size.height - waveHeight,
      );
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
