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
import '../templates/shared/bloc/bloc.dart';
import '../templates/shared/cubit/cubit.dart';

/// {@macro feature_command}
/// This command is used to generate a Feature.
/// {@endtemplate}
class FeatureCommand extends Command<int> {
  /// {@macro feature_command}
  FeatureCommand(this.logger) {
    argParser
      ..addFlag(
        'state',
        abbr: 's',
        help: 'Creates stateful page instead of stateless page.',
      )
      ..addFlag(
        'bloc',
        abbr: 'b',
        help: 'Creates bloc classes instead of cubit',
      );
  }

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
      final isStateful = argResults!['state'] == true;
      final isBloc = argResults!['bloc'] == true;
      final featureName = args.first;
      final blocTemplate = isBloc ? BlocTemplate() : CubitTemplate();
      final featureTemplate = projectType == 'rest' ? RestFeatureTemplate() : GraphqlFeatureTemplate();
      final featureDone = logger.progress('Generating ${featureName.pascalCase} feature');
      final featureGenerator = await MasonGenerator.fromBundle(featureTemplate.bundle);
      var vars = <String, dynamic>{
        'name': featureName,
        'package_name': packageName,
        'state': isStateful,
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
      final blocGenerator = await MasonGenerator.fromBundle(blocTemplate.bundle);
      String blocPath = '${blocTemplate.path}/$featureName/presentation/blocs/';
      await blocGenerator.generate(
        DirectoryGeneratorTarget(Directory(p.join(Directory.current.path, blocPath))),
        fileConflictResolution: FileConflictResolution.overwrite,
        vars: <String, dynamic>{
          'name': featureName,
        },
      );
      featureDone.complete('Generated ${featureName.pascalCase} feature');
      await featureTemplate.onGenerateComplete(logger, Directory.current);
    } else {
      throw UsageException('please provide feature name', usage);
    }
    return ExitCode.success.code;
  }
}
