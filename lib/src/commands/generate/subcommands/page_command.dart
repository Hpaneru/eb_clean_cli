/*
 * Copyright (c) 2022.
 * Author: Kishor Mainali
 * Company: EB Pearls
 */
import 'package:args/command_runner.dart';
import 'package:mason/mason.dart';
import 'package:path/path.dart' as p;
import 'package:universal_io/io.dart';

import '../templates/shared/page/page_template.dart';

/// {@macro page_command}
/// This command is used to generate a Page.
/// {@endtemplate}
class PageCommand extends Command<int> {
  /// {@macro page_command}
  PageCommand(this.logger) {
    argParser
      ..addOption(
        'feature',
        abbr: 'f',
        help: 'feature name to create page',
      )
      ..addFlag(
        'state',
        abbr: 's',
        help: 'Creates a stateful page instead of stateless page.',
      );
  }

  final Logger logger;

  @override
  String get description => 'creates page  in specific feature';

  @override
  String get name => 'page';

  @override
  String get invocation =>
      'eb_clean generate page --feature <feature-name> <name>';

  @override
  String get summary => '$invocation\n$description';

  @override
  Future<int> run() async {
    if (argResults!['feature'] == null) {
      logger.detail(
          '${red.wrap('Feature name is required. please provide feature name with --feature option')}');
      return ExitCode.noInput.code;
    }

    final isStateful = argResults!['state'] == true;
    final args = argResults?.rest;
    if (args != null && args.isNotEmpty) {
      final featureName = argResults!['feature'] as String;
      final pageName = args.first;
      final pageTemplate = PageTemplate();
      String path = '${pageTemplate.path}/$featureName/presentation/pages/';
      final pageDone =
          logger.progress('Generating ${pageName.pascalCase}Page class');
      final pageGenerator =
          await MasonGenerator.fromBundle(pageTemplate.bundle);
      var vars = <String, dynamic>{
        'name': pageName,
        'state': isStateful,
        'feature': featureName,
      };
      final cwd = Directory(p.join(Directory.current.path, path));
      await pageGenerator.generate(DirectoryGeneratorTarget(cwd),
          fileConflictResolution: FileConflictResolution.overwrite, vars: vars);
      await pageGenerator.hooks.postGen(
        vars: vars,
        onVarsChanged: (v) => vars = v,
        workingDirectory:
            p.join(Directory.current.path, pageTemplate.path, featureName),
      );
      pageDone.complete(
          'Generated ${pageName.pascalCase}Page class in $featureName feature');
      pageTemplate.onGenerateComplete(logger, Directory.current);
    } else {
      throw UsageException('please provide page name', usage);
    }
    return ExitCode.success.code;
  }
}
