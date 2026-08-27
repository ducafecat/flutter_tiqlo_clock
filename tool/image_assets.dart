import 'dart:io';
import 'dart:typed_data';

import 'package:image/image.dart' as img;
import 'package:path/path.dart' as path;

const _sourceDirectory = 'assets/images/3.0x';
const _twoXDirectory = 'assets/images/2.0x';
const _oneXDirectory = 'assets/images';
const _supportedExtensions = {'.png', '.jpg', '.jpeg', '.webp'};

Future<void> main() async {
  final source = Directory(_sourceDirectory);
  if (!await source.exists()) {
    stderr.writeln('找不到源目录：${source.path}');
    exitCode = 1;
    return;
  }

  var total = 0;
  var successful = 0;
  var skipped = 0;
  final generatedPaths = <String>[];

  await for (final entity in source.list(recursive: true, followLinks: false)) {
    if (entity is! File) continue;

    final extension = path.extension(entity.path).toLowerCase();
    if (!_supportedExtensions.contains(extension)) continue;
    total++;

    final relativePath = path.relative(entity.path, from: source.path);
    try {
      final decoded = img.decodeImage(await entity.readAsBytes());
      if (decoded == null) {
        skipped++;
        stderr.writeln('跳过无法读取的图片：${entity.path}');
        continue;
      }

      final oneX = _resize(decoded, 1 / 3);
      final twoX = _resize(decoded, 2 / 3);
      final oneXFile = File(path.join(_oneXDirectory, relativePath));
      final twoXFile = File(path.join(_twoXDirectory, relativePath));
      await oneXFile.parent.create(recursive: true);
      await twoXFile.parent.create(recursive: true);
      await oneXFile.writeAsBytes(_encode(oneX, extension), flush: true);
      await twoXFile.writeAsBytes(_encode(twoX, extension), flush: true);

      generatedPaths.add(path.join(_oneXDirectory, relativePath));
      successful++;
      stdout.writeln('已生成：$relativePath');
    } catch (error) {
      skipped++;
      stderr.writeln('跳过 ${entity.path}：$error');
    }
  }

  await _writeAppImages(generatedPaths);
  stdout.writeln('处理完成：源图 $total 张，成功 $successful 张，跳过 $skipped 张。');
}

img.Image _resize(img.Image image, double scale) => img.copyResize(
  image,
  width: (image.width * scale).round().clamp(1, image.width).toInt(),
  height: (image.height * scale).round().clamp(1, image.height).toInt(),
  interpolation: img.Interpolation.average,
);

Uint8List _encode(img.Image image, String extension) => switch (extension) {
  '.png' => img.encodePng(image, level: 6),
  '.jpg' || '.jpeg' => img.encodeJpg(image, quality: 85),
  '.webp' => img.encodeWebP(image),
  _ => throw UnsupportedError('不支持的格式：$extension'),
};

Future<void> _writeAppImages(List<String> imagePaths) async {
  imagePaths.sort();
  final usedNames = <String>{};
  final buffer = StringBuffer()
    ..writeln('// 此文件由 tool/image_assets.dart 自动生成，请勿手动修改。')
    ..writeln()
    ..writeln('abstract final class AppImages {')
    ..writeln('  AppImages._();')
    ..writeln();

  for (final imagePath in imagePaths) {
    final name = _constantName(imagePath, usedNames);
    buffer.writeln("  static const $name = '$imagePath';");
  }
  buffer.writeln('}');

  final output = File('lib/core/assets/app_images.dart');
  await output.parent.create(recursive: true);
  await output.writeAsString(buffer.toString());
}

String _constantName(String imagePath, Set<String> usedNames) {
  final relative = path.relative(imagePath, from: _oneXDirectory);
  final parts = path.withoutExtension(relative).split(path.separator);
  final extension = path.extension(relative).substring(1).toLowerCase();
  final words = <String>[...parts.expand(_words), extension];
  var name = words.first.toLowerCase();
  for (final word in words.skip(1)) {
    name += word.isEmpty
        ? ''
        : '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}';
  }
  if (RegExp(r'^\d').hasMatch(name)) name = 'asset$name';

  final baseName = name;
  var suffix = 2;
  while (!usedNames.add(name)) {
    name = '$baseName$suffix';
    suffix++;
  }
  return name;
}

Iterable<String> _words(String value) =>
    value.split(RegExp(r'[^A-Za-z0-9]+')).where((word) => word.isNotEmpty);
