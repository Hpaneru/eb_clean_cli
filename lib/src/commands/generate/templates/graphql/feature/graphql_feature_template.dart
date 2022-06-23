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

import 'graphql_feature_bundle.dart';

/// {@template graphql_feature_template}
/// A template for creating a feature with GraphQL API client.
/// {@endtemplate}
class GraphqlFeatureTemplate extends Template {
  /// {@macro graphql_feature_template}
  GraphqlFeatureTemplate()
      : super(
          name: 'graphql_feature',
          bundle: graphqlFeatureBundle,
          help: 'generates feature class',
          path: 'lib/src/features/',
        );

  @override
  Future<void> onGenerateComplete(Logger logger, Directory outputDirectory,
      [bool recursive = false]) async {
    logger.info(
        'Running ${lightGreen.wrap('flutter pub run build_runner build --delete-conflicting-outputs')}');
    await FlutterCli.runBuildRunner(cwd: outputDirectory.path);

    final formatDone =
        logger.progress('Running ${lightGreen.wrap('dart format .')}');
    await DartCli.formatCode(cwd: outputDirectory.path, recursive: true);
    formatDone.complete();
  }
}
