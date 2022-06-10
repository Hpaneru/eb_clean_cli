/*
 * Copyright (c) 2022.
 * Author: Kishor Mainali
 * Company: EB Pearls
 *
 */

import 'dart:io';

import 'package:eb_clean_cli/src/template.dart';
import 'package:mason_logger/mason_logger.dart';

import 'repository_bundle.dart';

class RepositoryTemplate extends Template {
  RepositoryTemplate()
      : super(
          name: 'source',
          bundle: repositoryBundle,
          help: 'generates repository\'s abstract and implementation class',
          path: 'lib/src/features/',
        );

  @override
  Future<void> onGenerateComplete(Logger logger, Directory outputDirectory, [bool recursive = false]) async {}
}
