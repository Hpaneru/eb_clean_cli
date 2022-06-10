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

import '../templates/shared/repository/repository.dart';

class RepositoryCommand extends Command<int> {
  RepositoryCommand(this.logger) {
    argParser.addOption('feature', abbr: 'f', help: 'feature name to create repository');
  }

  final Logger logger;

  @override
  String get description => 'creates repository class in repository packages';

  @override
  String get name => 'repository';

  @override
  String get invocation => 'eb_clean generate repository <name>';

  @override
  String get summary => '$invocation\n$description';

  @override
  Future<int> run() async {
    final packageName = FlutterCli.packageName();
    if (argResults!['feature'] == null) throw UsageException('please provide feature to create repository in', usage);
    final args = argResults?.rest;
    if (args != null && args.isNotEmpty) {
      final repositoryName = args.first;
      final featureName = argResults!['feature'] as String;
      final repositoryTemplate = RepositoryTemplate();
      final repositoryDone = logger.progress('Generating ${repositoryName.pascalCase}Repository\'s abstract and implementation class');
      final repositoryGenerator = await MasonGenerator.fromBundle(repositoryTemplate.bundle);
      var vars = <String, dynamic>{
        'name': repositoryName,
        'package_name': packageName,
      };
      final cwd = Directory(p.join(Directory.current.path, repositoryTemplate.path, '$featureName/'));
      await repositoryGenerator.generate(
        DirectoryGeneratorTarget(cwd),
        fileConflictResolution: FileConflictResolution.overwrite,
        vars: vars,
      );
      repositoryDone('Generated ${repositoryName.pascalCase}Repository class in $featureName feature');
      await repositoryTemplate.onGenerateComplete(logger, Directory.current);
    } else {
      throw UsageException('please provide repository name', usage);
    }
    return ExitCode.success.code;
  }
}
