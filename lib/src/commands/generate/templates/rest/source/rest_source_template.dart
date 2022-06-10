/*
 * Copyright (c) 2022.
 * Author: Kishor Mainali
 * Company: EB Pearls
 *
 */

import 'dart:io';

import 'package:eb_clean_cli/src/template.dart';
import 'package:mason_logger/mason_logger.dart';

import 'rest_source_bundle.dart';

class RestSourceTemplate extends Template {
  RestSourceTemplate()
      : super(
          name: 'rest_source',
          bundle: restSourceBundle,
          help: 'generates source class',
          path: 'lib/src/features/',
        );

  @override
  Future<void> onGenerateComplete(Logger logger, Directory outputDirectory, [bool recursive = false]) async {}
}
