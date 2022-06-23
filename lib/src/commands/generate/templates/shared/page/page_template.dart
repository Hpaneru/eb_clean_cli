/*
 * Copyright (c) 2022.
 * Author: Kishor Mainali
 * Company: EB Pearls
 */

import 'dart:io';

import 'package:eb_clean_cli/src/cli/cli.dart';
import 'package:eb_clean_cli/src/template.dart';
import 'package:mason_logger/mason_logger.dart';

import 'page_bundle.dart';

/// {@template page_template}
/// A template for creating a page class.
/// {@endtemplate}
class PageTemplate extends Template {
  /// {@macro page_template}
  PageTemplate()
      : super(
          name: 'page',
          bundle: pageBundle,
          help: 'generates page in specific feature',
          path: 'lib/src/features/',
        );

  @override
  Future<void> onGenerateComplete(Logger logger, Directory outputDirectory,
      [bool recursive = false]) async {
    final formatDone =
        logger.progress('Running ${lightGreen.wrap('dart format .')}');
    await DartCli.formatCode(cwd: outputDirectory.path, recursive: true);
    formatDone.complete();
  }
}
