/*
 * Copyright (c) 2022.
 * Author: Kishor Mainali
 * Company: EB Pearls
 *
 */

import 'package:args/args.dart';
import 'package:args/command_runner.dart';
import 'package:eb_clean_cli/src/commands/create/create.dart';
import 'package:mason/mason.dart' hide packageVersion;

import 'commands/generate/generate.dart';
import 'commands/packages/packages.dart';
import 'commands/run/run_command.dart';

//package version
const packageVersion = '0.0.1-dev.1';

//package name
const packageName = 'eb_clean_cli';

class EbCleanCommandRunner extends CommandRunner<int> {
  EbCleanCommandRunner({
    Logger? logger,
  })  : _logger = logger ?? Logger(),
        super('eb_clean', 'EB Clean Command Line Interface') {
    argParser.addFlag('version', negatable: false, help: 'Print the current version.');
    addCommand(CreateCommand(logger: _logger));
    addCommand(GenerateCommand(logger: _logger));
    addCommand(PackagesCommand(_logger));
    addCommand(RunCommand(_logger));
  }

  final Logger _logger;

  @override
  Future<int> run(Iterable<String> args) async {
    try {
      final argResults = parse(args);
      return await runCommand(argResults) ?? ExitCode.success.code;
    } on FormatException catch (e, stacktrace) {
      _logger
        ..err(e.message)
        ..err('$stacktrace')
        ..info('')
        ..info(usage);
      return ExitCode.usage.code;
    } on UsageException catch (e) {
      _logger
        ..err(e.message)
        ..info('')
        ..info(usage);
      return ExitCode.usage.code;
    }
  }

  @override
  Future<int?> runCommand(ArgResults topLevelResults) async {
    int? exitCode = ExitCode.unavailable.code;
    if (topLevelResults['version'] == true) {
      _logger.info('eb_clean:\t$packageVersion');
      exitCode = ExitCode.success.code;
    } else {
      exitCode = await super.runCommand(topLevelResults);
    }
    return exitCode;
  }
}
