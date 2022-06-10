/*
 * Copyright (c) 2022.
 * Author: Kishor Mainali
 * Company: EB Pearls
 *
 */

import 'dart:io';

import 'package:eb_clean_cli/src/template.dart';
import 'package:mason_logger/mason_logger.dart';

import 'graphql_source_bundle.dart';

class GraphqlSourceTemplate extends Template {
  GraphqlSourceTemplate()
      : super(
          name: 'graphql_source',
          bundle: graphqlSourceBundle,
          help: 'generates source class',
          path: 'lib/src/features/',
        );

  @override
  Future<void> onGenerateComplete(Logger logger, Directory outputDirectory, [bool recursive = false]) async {}
}
