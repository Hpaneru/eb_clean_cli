/*
 * Copyright (c) 2022.
 * Author: Kishor Mainali
 * Company: EB Pearls
 */
import 'package:args/command_runner.dart';
import 'package:eb_clean_cli/src/cli/cli.dart';
import 'package:mason/mason.dart';
import 'package:universal_io/io.dart';

class BuildRunnerCommand extends Command<int> {
  BuildRunnerCommand(this.logger) {
    argParser.addFlag(
      'recursive',
      abbr: 'r',
      help: 'runs command recursively',
      negatable: false,
    );
  }
  final Logger logger;

  @override
  String get description => 'Runs flutter pub run build_runner build --delete-conflicting-outputs in current directory';

  @override
  String get name => 'build_runner';

  @override
  String get invocation => 'eb_clean packages build_runner';

  @override
  String get summary => '$invocation\n$description';

  @override
  Future<int> run() async {
    if (FlutterCli.isFlutterProject()) {
      final recursive = argResults!['recursive'] == true;
      final pubDone = logger.progress('Running ${lightGreen.wrap('flutter pub run build_runner build --delete-conflicting-outputs')}');
      await FlutterCli.runBuildRunner(cwd: Directory.current.path, recursive: recursive);
      pubDone.complete();
      return ExitCode.success.code;
    } else {
      throw UsageException('packages build_runner only available inside flutter project only', usage);
    }
  }
}
