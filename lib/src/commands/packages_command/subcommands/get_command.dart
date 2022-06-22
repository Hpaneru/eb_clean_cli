/*
 * Copyright (c) 2022.
 * Author: Kishor Mainali
 * Company: EB Pearls
 */
import 'package:args/command_runner.dart';
import 'package:eb_clean_cli/src/cli/cli.dart';
import 'package:mason/mason.dart';
import 'package:universal_io/io.dart';

/// {@macro get_command}
/// The get command is used to get dependencies in the project.
/// {@endtemplate}
class GetCommand extends Command<int> {
  /// {@macro get_command}
  GetCommand(this.logger) {
    argParser.addFlag(
      'recursive',
      abbr: 'r',
      help: 'runs command recursively',
      negatable: false,
    );
  }

  final Logger logger;

  @override
  String get description => 'runs flutter pub get in current directory';

  @override
  String get name => 'get';

  @override
  String get invocation => 'eb_clean packages get';

  @override
  String get summary => '$invocation\n$description';

  @override
  Future<int> run() async {
    if (FlutterCli.isFlutterProject()) {
      final recursive = argResults!['recursive'] == true;
      final pubDone =
          logger.progress('Running ${lightGray.wrap('flutter pub get')}');
      await FlutterCli.pubGet(
          cwd: Directory.current.path, recursive: recursive);
      pubDone.complete();
      return ExitCode.success.code;
    } else {
      throw UsageException(
          'packages get only available inside flutter project only', usage);
    }
  }
}
