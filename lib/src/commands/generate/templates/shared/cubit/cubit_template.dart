/*
 * Copyright (c) 2022.
 * Author: Kishor Mainali
 * Company: EB Pearls
 */
import 'dart:io';

import 'package:eb_clean_cli/src/cli/cli.dart';
import 'package:eb_clean_cli/src/template.dart';
import 'package:mason_logger/mason_logger.dart';

import 'cubit.dart';

/// {@template cubit_template}
/// A template for creating a cubit class.
/// {@endtemplate}
class CubitTemplate extends Template {
  /// {@macro cubit_template}
  CubitTemplate()
      : super(
          name: 'cubit',
          bundle: cubitBundle,
          help: 'generates cubit template',
          path: 'lib/src/features/',
        );

  @override
  Future<void> onGenerateComplete(Logger logger, Directory outputDirectory,
      [bool recursive = false]) async {
    final buildDone = logger.progress(
        'Running ${lightGreen.wrap('flutter pub run build_runner build --delete-conflicting-outputs')}');
    await FlutterCli.runBuildRunner(cwd: outputDirectory.path);
    buildDone.complete();
    final formatDone =
        logger.progress('Running ${lightGreen.wrap('dart format .')}');
    await DartCli.formatCode(cwd: outputDirectory.path, recursive: true);
    formatDone.complete();
  }
}
