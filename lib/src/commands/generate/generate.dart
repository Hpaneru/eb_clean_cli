/*
 * Copyright (c) 2022.
 * Author: Kishor Mainali
 * Company: EB Pearls
 *
 */
import 'package:args/command_runner.dart';
import 'package:eb_clean_cli/src/commands/generate/subcommands/subcommands.dart';
import 'package:mason/mason.dart';

class GenerateCommand extends Command<int> {
  GenerateCommand({required this.logger}) {
    addSubcommand(FeatureCommand(logger));
    addSubcommand(BlocCommand(logger));
    addSubcommand(CubitCommand(logger));
    addSubcommand(PageCommand(logger));
    addSubcommand(SourceCommand(logger));
    addSubcommand(RepositoryCommand(logger));
  }

  final Logger logger;

  @override
  String get description => 'Generates features and specific classes';

  @override
  String get name => 'generate';

  @override
  List<String> get aliases => ['g'];

  @override
  String get invocation => 'eb_clean generate <subcommand> ';

  @override
  String get summary => '$invocation\n$description';
}
