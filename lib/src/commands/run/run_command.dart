/*
 * Copyright (c) 2022.
 * Author: Kishor Mainali
 * Company: EB Pearls
 */

import 'package:args/command_runner.dart';
import 'package:eb_clean_cli/src/cli/cli.dart';
import 'package:mason/mason.dart';
import 'package:universal_io/io.dart';

/// {@macro run_command}
/// The run command is used to run the project.
/// {@endtemplate}
class RunCommand extends Command<int> {
  /// {@macro run_command}
  RunCommand(this.logger);

  final Logger logger;

  @override
  String get description => 'runs project with  flavor';

  @override
  String get name => 'run';

  @override
  List<String> get aliases => ['r'];

  @override
  String get invocation => 'eb_clean run <flavor> ';

  @override
  String get summary => '$invocation\n$description';

  @override
  Future<int> run() async {
    if (FlutterCli.isFlutterProject()) {
      if (argResults!.rest.isNotEmpty) {
        final flavor = argResults!.rest.first;
        logger.info(
            'Running flutter run -t lib/main-$flavor.dart --flavor $flavor ');
        await FlutterCli.runProject(
            cwd: Directory.current.path, flavor: flavor);
        return ExitCode.success.code;
      } else {
        logger.info(
            'Running flutter run -t lib/main-development.dart --flavor development ');
        await FlutterCli.runProject(
            cwd: Directory.current.path, flavor: 'development');
        return ExitCode.success.code;
      }
    } else {
      throw UsageException(
          'run command only available inside flutter project only', usage);
    }
  }
}
