/*
 * Copyright (c) 2022.
 * Author: Kishor Mainali
 * Company: EB Pearls
 *
 */
import 'package:mason/mason.dart';
import 'package:universal_io/io.dart';

/// {@template template}
/// Dart class that represents a EBCleanCli supported template.
/// Each template consists of a [MasonBundle], name,
/// and help text describing the template.
/// {@endtemplate}
abstract class Template {
  Template({
    required this.name,
    required this.bundle,
    required this.help,
    required this.path,
  });

  /// The name associated with this template.
  final String name;

  /// The brick associated with this template.
  final MasonBundle bundle;

  /// The help text shown in the usage information for CLI.
  final String help;

  /// The path where templates is generated.
  final String path;

  /// Callback invoked after template generation has completed.
  Future<void> onGenerateComplete(Logger logger, Directory outputDirectory,
      [bool recursive = false]);
}
