/*
 * Copyright (c) 2022.
 * Author: Kishor Mainali
 * Company: EB Pearls
 *
 */
import 'package:args/command_runner.dart';
import 'package:mason/mason.dart';

import 'subcommands/build_runner_command.dart';
import 'subcommands/get_command.dart';

/// {@template packages_command}
/// The packages command is used to get dependencies and run generators in the project.
/// {@endtemplate}
class PackagesCommand extends Command<int> {
  /// {@macro packages_command}
  PackagesCommand(this.logger) {
    addSubcommand(GetCommand(logger));
    addSubcommand(BuildRunnerCommand(logger));
  }

  final Logger logger;

  @override
  String get description => 'runs packages commands.dart';

  @override
  String get name => 'packages';

  @override
  List<String> get aliases => ['p'];

  @override
  String get invocation => 'eb_clean packages <subcommand> ';

  @override
  String get summary => '$invocation\n$description';
}
