import 'package:args/command_runner.dart';
import 'package:eb_clean_cli/src/cli/cli.dart';
import 'package:mason/mason.dart';
import 'package:path/path.dart' as p;
import 'package:universal_io/io.dart';

/// {@template env_command}
/// Generates .envs for different environment
/// {@end_template}
class EnvCommand extends Command<int> {
  /// {@macro env_command}
  EnvCommand(this.logger);

  /// logger to log messages
  final Logger logger;

  @override
  String get description => 'creates .envs for all flavors';

  @override
  String get name => 'env';

  @override
  String get invocation => 'eb_clean generate env';

  @override
  String get summary => '$invocation\n$description';

  @override
  Future<int> run() async {
    if (isProjectRoot()) {
      await FlutterCli.copyEnvs(logger, Directory.current.path);
      logger
        ..info('\n')
        ..info('${lightGreen.wrap('Generated .envs for all flavors')}');
    } else {
      throw UsageException('Envs are created in project root only', usage);
    }
    return ExitCode.success.code;
  }

  /// checks if current directory is project root
  bool isProjectRoot() {
    final projectRoot = Directory.current.path;
    final pubspec = File(p.join(projectRoot, 'pubspec.yaml'));
    return pubspec.existsSync();
  }
}
