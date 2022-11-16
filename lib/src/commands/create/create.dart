/*
 * Copyright (c) 2022.
 * Author: Kishor Mainali
 * Company: EB Pearls
 *
 */
import 'package:args/args.dart';
import 'package:args/command_runner.dart';
import 'package:eb_clean_cli/src/template.dart';
import 'package:mason/mason.dart';
import 'package:meta/meta.dart';
import 'package:universal_io/io.dart';

import 'templates/graphql/graphql.dart';
import 'templates/rest/rest.dart';

final _defaultDescription = 'A Clean Project created by EB Clean CLI.';

/// A method which returns a [Future<MasonGenerator>] given a [MasonBundle].
typedef GeneratorBuilder = Future<MasonGenerator> Function(MasonBundle);

// A valid Dart identifier that can be used for a package, i.e. no
// capital letters.
// https://dart.dev/guides/language/language-tour#important-concepts
final RegExp _identifierRegExp = RegExp(r'[a-z_][a-z\d_]*');
final RegExp _orgNameRegExp = RegExp(r'^[a-zA-Z][\w-]*(\.[a-zA-Z][\w-]*)+$');

final _templates = [GraphqlTemplate(), RestTemplate()];

final _defaultTemplate = _templates.first;

/// {@template create_command}
/// `eb_clean create` command creates code from various built-in templates.
/// {@endtemplate}
class CreateCommand extends Command<int> {
  /// {@macro create_command}
  CreateCommand({
    required this.logger,
    GeneratorBuilder? generator,
  }) : _generator = generator ?? MasonGenerator.fromBundle {
    argParser
      ..addOption(
        'desc',
        abbr: 'd',
        defaultsTo: _defaultDescription,
        help: 'The description for this new project',
      )
      ..addOption(
        'org',
        defaultsTo: 'com.ebpearls',
        help: 'The package name for this new project. Default is com.ebpearls',
      )
      ..addOption(
        'template',
        abbr: 't',
        help: 'The template used to generate this new project.',
        defaultsTo: _defaultTemplate.name,
        allowed: _templates.map((element) => element.name).toList(),
        allowedHelp: _templates.fold<Map<String, String>>(
          {},
          (previousValue, element) => {
            ...previousValue,
            element.name: element.help,
          },
        ),
      );
  }

  final Logger logger;

  final GeneratorBuilder _generator;

  @override
  String get description => 'Creates a new flutter project.';

  @override
  String get name => 'create';

  @override
  String get invocation => 'eb_clean create <project name>';

  @override
  String get summary => '$invocation\n$description';

  /// [ArgResults] which can be overridden for testing.
  @visibleForTesting
  ArgResults? argResultOverrides;

  ArgResults get _argResults => argResultOverrides ?? argResults!;

  @override
  Future<int> run() async {
    final outputDirectory = _outputDirectory;
    final template = _template;
    final generateDone = logger.progress('Bootstrapping');
    final generator = await _generator(template.bundle);
    var vars = <String, dynamic>{
      'package_name': _projectName,
      'app_description': _description,
      'org_name': _orgName,
    };
    await generator.hooks.preGen(vars: vars, onVarsChanged: (v) => vars = v);
    final files = await generator.generate(
      DirectoryGeneratorTarget(outputDirectory),
      vars: vars,
      fileConflictResolution: FileConflictResolution.overwrite,
      logger: logger,
    );
    generateDone.complete('Generated ${files.length} file(s)');
    await template.onGenerateComplete(logger, outputDirectory);
    return ExitCode.success.code;
  }

  /// Gets the project name.
  ///
  /// Uses the current directory path name
  /// if the `--project-name` option is not explicitly specified.
  String get _projectName {
    final rest = _argResults.rest;
    final projectName = rest.first;
    _validateProjectName(projectName);
    return projectName;
  }

  /// Gets the description for the project.
  String get _description => _argResults['desc'] as String? ?? _defaultDescription;

  /// Gets the organization name.
  String get _orgName {
    final orgName = _argResults['org'] as String? ?? 'com.ebpearls';
    _validateOrgName(orgName);
    return orgName;
  }

  /// templates for creating project
  Template get _template {
    final templateName = _argResults['template'] as String?;
    return _templates.firstWhere(
      (element) => element.name == templateName,
      orElse: () => _defaultTemplate,
    );
  }

  /// validates org name
  void _validateOrgName(String name) {
    final isValidOrgName = _isValidOrgName(name);
    if (!isValidOrgName) {
      throw UsageException(
        '"$name" is not a valid org name.\n\n'
        'A valid org name has at least 2 parts separated by "."\n'
        'Each part must start with a letter and only include '
        'alphanumeric characters (A-Z, a-z, 0-9), underscores (_), '
        'and hyphens (-)\n'
        '(ex. very.good.org)',
        usage,
      );
    }
  }

  void _validateProjectName(String name) {
    final isValidProjectName = _isValidPackageName(name);
    if (!isValidProjectName) {
      throw UsageException(
        '"$name" is not a valid package name.\n\n'
        'See https://dart.dev/tools/pub/pubspec#name for more information.',
        usage,
      );
    }
  }

  bool _isValidOrgName(String name) {
    return _orgNameRegExp.hasMatch(name);
  }

  bool _isValidPackageName(String name) {
    final match = _identifierRegExp.matchAsPrefix(name);
    return match != null && match.end == name.length;
  }

  Directory get _outputDirectory {
    final rest = _argResults.rest;
    _validateOutputDirectoryArg(rest);
    return Directory(rest.first);
  }

  void _validateOutputDirectoryArg(List<String> args) {
    if (args.isEmpty) {
      throw UsageException(
        'No option specified for the output directory.',
        usage,
      );
    }

    if (args.length > 1) {
      throw UsageException('Multiple output directories specified.', usage);
    }
  }
}
