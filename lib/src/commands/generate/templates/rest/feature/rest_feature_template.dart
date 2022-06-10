/*
 * Copyright (c) 2022.
 * Author: Kishor Mainali
 * Company: EB Pearls
 *
 */

import 'dart:io';

import 'package:eb_clean_cli/src/template.dart';
import 'package:mason_logger/mason_logger.dart';

import 'rest_feature_bundle.dart';

class RestFeatureTemplate extends Template {
  RestFeatureTemplate()
      : super(
          name: 'rest_feature',
          bundle: restFeatureBundle,
          help: 'Generates full feature',
          path: 'lib/src/features/',
        );

  @override
  Future<void> onGenerateComplete(Logger logger, Directory outputDirectory, [bool recursive = false]) async {}
}
