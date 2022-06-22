import 'package:eb_clean_cli/src/eb_clean_command_runner.dart';
import 'package:universal_io/io.dart';

/// main entrypoint for the eb_clean_cli application.
Future<void> main(List<String> args) async {
  await _flushThenExit(await EbCleanCommandRunner().run(args));
}

/// Flushes the stdout and stderr streams, then exits the program with the given
/// status code.
///
/// This returns a Future that will never complete, since the program will have
/// exited already. This is useful to prevent Future chains from proceeding
/// after you've decided to exit.
Future _flushThenExit(int status) {
  return Future.wait<void>([stdout.close(), stderr.close()])
      .then<void>((_) => exit(status));
}
