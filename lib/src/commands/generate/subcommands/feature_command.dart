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

import '../templates/graphql/feature/feature.dart';
import '../templates/rest/feature/feature.dart';

class FeatureCommand extends Command<int> {
  FeatureCommand(this.logger);

  final Logger logger;

  @override
  String get description => 'generates full feature';

  @override
  String get name => 'feature';

  @override
  String get invocation => 'eb_clean generate feature  <name>';

  @override
  String get summary => '$invocation\n$description';

  @override
  Future<int> run() async {
    final packageName = FlutterCli.packageName();
    final projectType = FlutterCli.projectType();
    final args = argResults?.rest;
    if (args != null && args.isNotEmpty) {
      final featureName = args.first;
      final featureTemplate = projectType == 'rest' ? RestFeatureTemplate() : GraphqlFeatureTemplate();
      final featureDone = logger.progress('Generating ${featureName.pascalCase} feature');
      final featureGenerator = await MasonGenerator.fromBundle(featureTemplate.bundle);
      var vars = <String, dynamic>{
        'name': featureName,
        'package_name': packageName,
      };
      final cwd = Directory(p.join(Directory.current.path, featureTemplate.path));
      await featureGenerator.generate(
        DirectoryGeneratorTarget(cwd),
        fileConflictResolution: FileConflictResolution.overwrite,
        vars: vars,
      );
      await featureGenerator.hooks.postGen(
        vars: vars,
        onVarsChanged: (v) => vars = v,
        workingDirectory: p.join(cwd.path, featureName),
      );
      featureDone('Generated ${featureName.pascalCase} feature');
      await featureTemplate.onGenerateComplete(logger, Directory.current);
    } else {
      throw UsageException('please provide feature name', usage);
    }
    return ExitCode.success.code;
  }
}
