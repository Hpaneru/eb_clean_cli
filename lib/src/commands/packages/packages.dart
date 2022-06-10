/*
 * Copyright (c) 2022.
 * Author: Kishor Mainali
 * Company: EB Pearls
 *
 */
import 'package:args/command_runner.dart';
import 'subcommands/get_command.dart';
import 'package:mason/mason.dart';

import 'subcommands/build_runner_command.dart';

class PackagesCommand extends Command<int> {
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
