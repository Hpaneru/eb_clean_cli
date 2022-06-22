/*
 * Copyright (c) 2022.
 * Author: Kishor Mainali
 * Company: EB Pearls
 *
 */

import 'package:args/args.dart';
import 'package:args/command_runner.dart';
import 'package:eb_clean_cli/src/commands/create/create.dart';
import 'package:eb_clean_cli/src/commands/generate/generate.dart';
import 'package:eb_clean_cli/src/commands/packages_command/packages_command.dart';
import 'package:eb_clean_cli/src/commands/run/run_command.dart';
import 'package:eb_clean_cli/src/version.dart';
import 'package:mason/mason.dart' hide packageVersion;
import 'package:pub_updater/pub_updater.dart';

///package name
const packageName = 'eb_clean_cli';

/// {@template eb_clean_command_runner}
/// A [CommandRunner] for the EB Clean CLI.
/// {@endtemplate}
class EbCleanCommandRunner extends CommandRunner<int> {
  /// {@macro eb_clean_command_runner}
  EbCleanCommandRunner({
    Logger? logger,
    PubUpdater? updater,
  })  : _logger = logger ?? Logger(),
        _updater = updater ?? PubUpdater(),
        super('eb_clean', 'EB Clean Command Line Interface') {
    argParser.addFlag('version',
        negatable: false, help: 'Print the current version.');
    addCommand(CreateCommand(logger: _logger));
    addCommand(GenerateCommand(logger: _logger));
    addCommand(PackagesCommand(_logger));
    addCommand(RunCommand(_logger));
  }

  static const timeout = Duration(milliseconds: 500);

  /// logger
  final Logger _logger;

  /// pub version updater
  final PubUpdater _updater;

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
    await _checkForUpdates();
    return exitCode;
  }

  /// checks latest version
  Future<void> _checkForUpdates() async {
    try {
      final isUpToDate = await _updater.isUpToDate(
          packageName: packageName, currentVersion: packageVersion);
      if (!isUpToDate) {
        _logger
          ..info('')
          ..info('''
          ${lightYellow.wrap('Update available!')} ${lightCyan.wrap(packageVersion)} \u2192 ${lightCyan.wrap(await _updater.getLatestVersion(packageName))}
          ${lightYellow.wrap('Changelog:')} ${lightCyan.wrap('https://github.com/kishor98100/eb_clean_cli/releases/tag/v${await _updater.getLatestVersion(packageName)}')}
          Run ${lightCyan.wrap('pub global activate eb_clean_cli')} to update.
        ''');
      }
    } catch (_) {}
  }
}
