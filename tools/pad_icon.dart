import 'dart:io';
import 'package:image/image.dart' as img;

// Usage:
// dart run tools/pad_icon.dart <input_png> <output_png> [scale] [shape] [corner]
// - input_png: path to original square icon (e.g., assets/images/app_icon.png)
// - output_png: path to padded icon (e.g., assets/images/app_icon_padded.png)
// - scale: optional, 0.0..1.0, fraction of canvas the icon should occupy (default 0.76)
//   Example: 0.76 leaves ~12% margin on each side on a square canvas.
// - shape: optional, one of: 'none' (default), 'circle', 'rounded'
// - corner: optional, corner radius as fraction of canvas (0..0.5) when shape='rounded' (default 0.24)

void main(List<String> args) {
  if (args.length < 2 || args.length > 5) {
    stderr.writeln(
        'Usage: dart run tools/pad_icon.dart <input_png> <output_png> [scale 0.76] [shape none|circle|rounded] [corner 0.24]');
    exit(64);
  }

  final inputPath = args[0];
  final outputPath = args[1];
  final scale = args.length >= 3 ? double.tryParse(args[2]) ?? 0.76 : 0.76;
  final shape = args.length >= 4 ? args[3].toLowerCase() : 'none';
  final corner = args.length >= 5 ? double.tryParse(args[4]) ?? 0.24 : 0.24;
  if (scale <= 0 || scale > 1) {
    stderr.writeln('Scale must be within (0, 1].');
    exit(64);
  }
  if (!['none', 'circle', 'rounded'].contains(shape)) {
    stderr.writeln("shape must be one of: none, circle, rounded");
    exit(64);
  }
  if (corner < 0 || corner > 0.5) {
    stderr.writeln('corner must be within [0, 0.5].');
    exit(64);
  }

  final inputFile = File(inputPath);
  if (!inputFile.existsSync()) {
    stderr.writeln('Input file not found: $inputPath');
    exit(66);
  }

  final bytes = inputFile.readAsBytesSync();
  final decoded = img.decodeImage(bytes);
  if (decoded == null) {
    stderr.writeln('Failed to decode image: $inputPath');
    exit(65);
  }

  // Target canvas 1024x1024 for best quality before generator downscales
  const targetCanvas = 1024;
  // Resize original to fit within scale*canvas preserving aspect ratio
  final targetInner = (targetCanvas * scale).round();

  final resized = img.copyResize(
    decoded,
    width: decoded.width >= decoded.height ? targetInner : null,
    height: decoded.height > decoded.width ? targetInner : null,
    interpolation: img.Interpolation.cubic,
  );

  // Create transparent canvas
  final canvas = img.Image(width: targetCanvas, height: targetCanvas);
  img.fill(canvas, color: img.ColorRgba8(0, 0, 0, 0));

  // Center the resized image
  final x = ((targetCanvas - resized.width) / 2).round();
  final y = ((targetCanvas - resized.height) / 2).round();
  img.compositeImage(canvas, resized, dstX: x, dstY: y);

  // Optionally apply a shape mask to avoid straight sides when launchers round only the outer bounds
  final shaped = switch (shape) {
    'circle' => _applyCircleMask(canvas),
    'rounded' => _applyRoundedMask(canvas, (corner * targetCanvas).round()),
    _ => canvas,
  };

  final png = img.encodePng(shaped, level: 6);
  File(outputPath)
    ..createSync(recursive: true)
    ..writeAsBytesSync(png);

  stdout.writeln('Padded icon generated at $outputPath (scale='
      '${scale.toStringAsFixed(2)}, shape=$shape)');
}

img.Image _applyCircleMask(img.Image src) {
  final w = src.width;
  final h = src.height;
  final cx = w / 2;
  final cy = h / 2;
  final r = (w < h ? w : h) / 2;
  final r2 = r * r;
  final out = img.Image.from(src);
  for (var y = 0; y < h; y++) {
    final dy = (y + 0.5) - cy;
    for (var x = 0; x < w; x++) {
      final dx = (x + 0.5) - cx;
      final d2 = dx * dx + dy * dy;
      if (d2 > r2) {
        // set fully transparent
        out.setPixelRgba(x, y, 0, 0, 0, 0);
      }
    }
  }
  return out;
}

img.Image _applyRoundedMask(img.Image src, int radius) {
  final w = src.width;
  final h = src.height;
  final r = radius.clamp(0, (w < h ? w : h) ~/ 2);
  if (r == 0) return src;
  final out = img.Image.from(src);

  // Helper to set alpha 0 outside a rounded-rect area
  bool insideRounded(int x, int y) {
    // Central rectangle
    if (x >= r && x < w - r) return y >= 0 && y < h;
    if (y >= r && y < h - r) return x >= 0 && x < w;
    // Corners
    int cx, cy;
    if (x < r && y < r) {
      cx = r; cy = r; // top-left
    } else if (x >= w - r && y < r) {
      cx = w - r - 1; cy = r; // top-right
    } else if (x < r && y >= h - r) {
      cx = r; cy = h - r - 1; // bottom-left
    } else {
      cx = w - r - 1; cy = h - r - 1; // bottom-right
    }
    final dx = x - cx;
    final dy = y - cy;
    return dx * dx + dy * dy <= r * r;
  }

  for (var y = 0; y < h; y++) {
    for (var x = 0; x < w; x++) {
      if (!insideRounded(x, y)) {
        out.setPixelRgba(x, y, 0, 0, 0, 0);
      }
    }
  }
  return out;
}
