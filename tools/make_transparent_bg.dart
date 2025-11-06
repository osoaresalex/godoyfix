import 'dart:io';
import 'package:image/image.dart' as img;

// Creates a fully transparent square PNG (default 1024x1024)
// Usage: dart run tools/make_transparent_bg.dart <out_path> [size]
void main(List<String> args) {
  if (args.isEmpty || args.length > 2) {
    stderr.writeln('Usage: dart run tools/make_transparent_bg.dart <out_path> [size 1024]');
    exit(64);
  }
  final outPath = args[0];
  final size = args.length == 2 ? int.tryParse(args[1]) ?? 1024 : 1024;
  if (size <= 0) {
    stderr.writeln('size must be > 0');
    exit(64);
  }
  final canvas = img.Image(width: size, height: size);
  img.fill(canvas, color: img.ColorRgba8(0, 0, 0, 0));
  final bytes = img.encodePng(canvas, level: 6);
  File(outPath)
    ..createSync(recursive: true)
    ..writeAsBytesSync(bytes);
  stdout.writeln('Transparent background generated at $outPath (${size}x$size)');
}
