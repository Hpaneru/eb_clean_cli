/*
 * Copyright (c) 2022.
 * Author: Kishor Mainali
 * Company: EB Pearls
 */
import 'package:args/command_runner.dart';
import 'package:eb_clean_cli/src/cli/cli.dart';
import 'package:mason/mason.dart';
import 'package:path/path.dart' as p;
import 'package:recase/recase.dart';
import 'package:universal_io/io.dart';

import '../templates/graphql/source/source.dart';
import '../templates/rest/source/source.dart';

/// {@macro source_command}
/// This command is used to generate a Source.
/// {@endtemplate}
class SourceCommand extends Command<int> {
  /// {@macro source_command}
  SourceCommand(this.logger) {
    argParser.addOption(
      'feature',
      abbr: 'f',
      help: 'feature name to create page',
    );
  }

  final Logger logger;

  @override
  String get description => 'generates source class in specific feature';

  @override
  String get name => 'source';

  @override
  String get invocation => 'eb_clean generate source  <name>';

  @override
  String get summary => '$invocation\n$description';

  @override
  Future<int> run() async {
    if (argResults!['feature'] == null) {
      logger.info('${red.wrap('Feature name is required. please provide feature name with --feature option.')}');
      return ExitCode.noInput.code;
    }

    final packageName = FlutterCli.packageName();
    final projectType = FlutterCli.projectType();

    final args = argResults?.rest;
    if (args != null && args.isNotEmpty) {
      final featureName = argResults!['feature'] as String;
      final sourceName = args.first;
      final sourceTemplate = projectType == 'rest' ? RestSourceTemplate() : GraphqlSourceTemplate();
      final sourceDone = logger.progress('Generating ${sourceName.pascalCase}RemoteSource');
      final sourceGenerator = await MasonGenerator.fromBundle(sourceTemplate.bundle);
      var vars = <String, dynamic>{
        'name': sourceName,
        'package_name': packageName,
      };
      final cwd = Directory(p.join(Directory.current.path, sourceTemplate.path, '$featureName/data/source'));
      await sourceGenerator.generate(DirectoryGeneratorTarget(cwd), fileConflictResolution: FileConflictResolution.overwrite, vars: vars);
      sourceDone.complete('Generated ${sourceName.pascalCase}RemoteSource source in $featureName feature');
      await sourceTemplate.onGenerateComplete(logger, Directory.current);
    } else {
      throw UsageException('please provide source name', usage);
    }
    return ExitCode.success.code;
  }
}
