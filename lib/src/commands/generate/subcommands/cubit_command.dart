/*
 * Copyright (c) 2022.
 * Author: Kishor Mainali
 * Company: EB Pearls
 */
import 'package:args/command_runner.dart';
import 'package:mason/mason.dart';
import 'package:path/path.dart' as p;
import 'package:recase/recase.dart';
import 'package:universal_io/io.dart';

import '../templates/shared/cubit/cubit.dart';

class CubitCommand extends Command<int> {
  CubitCommand(this.logger) {
    argParser.addOption(
      'feature',
      abbr: 'f',
      help: 'feature name to create cubit',
      mandatory: true,
    );
  }

  final Logger logger;

  @override
  String get description => 'creates cubit class in specific feature';

  @override
  String get name => 'cubit';

  @override
  String get invocation => 'eb_clean generate cubit --feature <feature-name> <name>';

  @override
  String get summary => '$invocation\n$description';

  @override
  Future<int> run() async {
    if (argResults!['feature'] == null) {
      throw UsageException('feature is required', usage);
    }
    final args = argResults?.rest;
    if (args != null && args.isNotEmpty) {
      final featureName = argResults!['feature'] as String;

      final blocName = args.first;
      final blocTemplate = CubitTemplate();
      String path = '${blocTemplate.path}/$featureName/presentation/blocs/';
      final blocDone = logger.progress('Generating ${blocName.pascalCase}Cubit class');
      final blocGenerator = await MasonGenerator.fromBundle(blocTemplate.bundle);
      var vars = <String, dynamic>{
        'name': blocName,
      };
      final cwd = Directory(p.join(Directory.current.path, path));
      await blocGenerator.generate(DirectoryGeneratorTarget(cwd), fileConflictResolution: FileConflictResolution.overwrite, vars: vars);
      blocDone.complete('Generated ${blocName.pascalCase}Cubit class in ${cwd.path}');
      blocTemplate.onGenerateComplete(logger, Directory.current);
    } else {
      throw UsageException('please provide bloc name', usage);
    }
    return ExitCode.success.code;
  }
}
