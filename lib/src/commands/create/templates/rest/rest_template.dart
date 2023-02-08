/*
 * Copyright (c) 2022.
 * Author: Kishor Mainali
 * Company: EB Pearls
 *
 */
import 'dart:io';

import 'package:eb_clean_cli/src/cli/cli.dart';
import 'package:eb_clean_cli/src/template.dart';
import 'package:mason_logger/mason_logger.dart';

import 'rest.dart';

/// {@template rest_template}
/// A template for creating a project with REST API client.
/// {@endtemplate}
class RestTemplate extends Template {
  /// {@macro rest_template}
  RestTemplate()
      : super(
          name: 'rest',
          bundle: restProjectBundle,
          help: 'Creates a clean project which uses dio as http client',
          path: '.',
        );

  @override
  Future<void> onGenerateComplete(Logger logger, Directory outputDirectory,
      [bool recursive = false]) async {
    final pubDone =
        logger.progress('Running flutter pub get in ${outputDirectory.path}');
    await FlutterCli.pubGet(cwd: outputDirectory.path);
    pubDone.complete();
    logger.info(
        'Running ${lightGreen.wrap('flutter pub run build_runner build --delete-conflicting-outputs')}');
    await FlutterCli.runBuildRunner(cwd: outputDirectory.path);
    final fixDone =
        logger.progress('Running ${lightGreen.wrap('dart fix --apply')}');
    await DartCli.applyFixes(cwd: outputDirectory.path, recursive: true);
    fixDone.complete();
    final formatDone =
        logger.progress('Running ${lightGreen.wrap('dart format .')}');
    await DartCli.formatCode(cwd: outputDirectory.path, recursive: true);
    formatDone.complete();
    await FlutterCli.runIntlUtils(logger: logger, cwd: outputDirectory.path);
    await GitCli.runBasicGitInit(logger, cwd: outputDirectory.path);
  }
}
