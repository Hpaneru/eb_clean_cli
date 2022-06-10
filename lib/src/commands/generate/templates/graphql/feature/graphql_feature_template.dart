/*
 * Copyright (c) 2022.
 * Author: Kishor Mainali
 * Company: EB Pearls
 *
 */

import 'dart:io';

import 'package:eb_clean_cli/src/template.dart';
import 'package:mason_logger/mason_logger.dart';

import 'graphql_feature_bundle.dart';

class GraphqlFeatureTemplate extends Template {
  GraphqlFeatureTemplate()
      : super(
          name: 'graphql_feature',
          bundle: graphqlFeatureBundle,
          help: 'generates feature class',
          path: 'lib/src/features/',
        );

  @override
  Future<void> onGenerateComplete(Logger logger, Directory outputDirectory, [bool recursive = false]) async {}
}
