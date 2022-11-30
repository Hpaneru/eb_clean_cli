/*
 * Copyright (c) 2022.
 * Author: Kishor Mainali
 * Company: EB Pearls
 *
 */

import 'package:args/command_runner.dart';
import 'package:eb_clean_cli/src/cli/cli.dart';
import 'package:glob/glob.dart';
import 'package:glob/list_local_fs.dart';
import 'package:mason/mason.dart';
import 'package:path/path.dart' as p;
import 'package:recase/recase.dart';
import 'package:universal_io/io.dart';

import '../templates/shared/assets/assets.dart';

/// {@template assets_command}
/// This command is used to generate Assets.
/// {@endtemplate}
class AssetsCommand extends Command<int> {
  /// {@macro assets_command}
  AssetsCommand(this.logger);

  final Logger logger;

  @override
  String get description => 'generates assets helper class';

  @override
  String get name => 'assets';

  @override
  String get invocation => 'eb_clean generate assets';

  @override
  String get summary => '$invocation\n$description';

  @override
  Future<int> run() async {
    final isFlutterRoot = FlutterCli.isFlutterRoot();
    if (!isFlutterRoot) {
      logger.info('${red.wrap('Please run this command from project root directory.')}');
      return ExitCode.noInput.code;
    }

    final assetsTemplate = AssetsTemplate();
    final assetsGenerator = await MasonGenerator.fromBundle(assetsTemplate.bundle);
    final path = Directory(p.join(Directory.current.path, assetsTemplate.path));
    final files = <Map<String, dynamic>>[];
    final assets = Glob('assets/**/{*.png,*.jpg,*.jpeg,*.svg}', recursive: true);

    assets.listSync().forEach((file) {
      var prefixType = file.path.replaceFirst('./', '').split('/')[1];
      prefixType = prefixType.endsWith('s') ? prefixType.substring(0, prefixType.length - 1) : prefixType;

      files.add({
        'path': file.path.replaceFirst('./', ''),
        'name': '${p.basenameWithoutExtension(file.path).camelCase}${prefixType.pascalCase}',
      });
    });
    await assetsGenerator.generate(
      DirectoryGeneratorTarget(path),
      vars: {
        'assets': files,
      },
      fileConflictResolution: FileConflictResolution.overwrite,
    );
    await assetsTemplate.onGenerateComplete(logger, Directory.current);
    return ExitCode.success.code;
  }
}
