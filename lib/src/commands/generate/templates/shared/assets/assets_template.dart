/*
 * Copyright (c) 2022.
 * Author: Kishor Mainali
 * Company: EB Pearls
 *
 */

import 'package:eb_clean_cli/src/cli/cli.dart';
import 'package:eb_clean_cli/src/template.dart';
import 'package:mason/mason.dart';
import 'package:universal_io/io.dart';

import 'assets_bundle.dart';

class AssetsTemplate extends Template {
  AssetsTemplate()
      : super(
          name: 'assets',
          bundle: assetsBundle,
          help: 'generates helper class for assets',
          path: 'lib/src/core/helpers',
        );

  @override
  Future<void> onGenerateComplete(Logger logger, Directory outputDirectory, [bool recursive = false]) async {
    final formatDone = logger.progress('Running ${lightGreen.wrap('dart format .')}');
    await DartCli.formatCode(cwd: outputDirectory.path, recursive: true);
    formatDone.complete();
  }
}
