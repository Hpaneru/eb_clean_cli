/*
 * Copyright (c) 2022.
 * Author: Kishor Mainali
 * Company: EB Pearls
 *
 */
import 'package:args/command_runner.dart';
import 'package:mason/mason.dart';
import 'package:path/path.dart' as p;
import 'package:recase/recase.dart';
import 'package:universal_io/io.dart';

import '../templates/shared/model/model.dart';

/// {@template model_command}
/// This command is used to generate a Model.
/// {@endtemplate}
class ModelCommand extends Command<int> {
  /// {@macro model_command}
  ModelCommand(this.logger) {
    argParser
      ..addOption(
        'properties',
        abbr: 'p',
        help: 'Properties for model class: properties should be in format of dataType:propertyName separated by comma.',
      )
      ..addOption('feature', abbr: 'f', help: 'Feature name to create model class');
  }

  final Logger logger;

  @override
  String get description => 'generates model class';

  @override
  String get name => 'model';

  @override
  String get invocation => 'eb_clean generate model  <name>';

  @override
  String get summary => '$invocation\n$description';

  @override
  Future<int> run() async {
    if (argResults!['feature'] == null) {
      logger.info('${red.wrap('Feature name is required. please provide feature name with --feature option')}');
      return ExitCode.noInput.code;
    }

    final properties = <Map<String, dynamic>>[];

    final featureName = argResults!['feature'] as String;
    final propertiesString = argResults!['properties'] as String?;
    final args = argResults!.rest;
    if (args.isEmpty) {
      logger.info('${red.wrap('Model name is required')}');
      return ExitCode.noInput.code;
    }
    final modelName = args.first;
    if (propertiesString != null && propertiesString.isNotEmpty) {
      final propertiesList = propertiesString.split(',');
      for (final property in propertiesList) {
        final propertyList = property.split(':');
        if (propertyList.length != 2) {
          logger.info('${red.wrap('Invalid property format. Please provide property in format of dataType:propertyName')}');
          return ExitCode.noInput.code;
        }
        final dataType = propertyList[0];
        final propertyName = propertyList[1];
        properties.add({
          'type': dataType,
          'name': propertyName,
        });
      }
    }
    final modelTemplate = ModelTemplate();
    final modelGenerator = await MasonGenerator.fromBundle(modelTemplate.bundle);
    String path = '${modelTemplate.path}/$featureName/data/models/';
    var vars = <String, dynamic>{
      'name': modelName,
      'properties': properties,
      'hasProperties': properties.isNotEmpty,
    };
    final cwd = Directory(p.join(Directory.current.path, path));
    final modelDone = logger.progress('Generating ${modelName.pascalCase}Model class');
    await modelGenerator.generate(
      DirectoryGeneratorTarget(cwd),
      vars: vars,
      fileConflictResolution: FileConflictResolution.overwrite,
    );
    modelDone.complete();
    await modelTemplate.onGenerateComplete(logger, Directory.current);

    return ExitCode.success.code;
  }
}
