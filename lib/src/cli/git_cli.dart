part of 'cli.dart';

class GitCli {
  static Future<bool> checkGitInstalled() async {
    try {
      await _Cmd.run('git', ['--version']);
      return true;
    } catch (_) {
      return false;
    }
  }

  static Future<void> runBasicGitInit(Logger logger) async {
    if (await checkGitInstalled()) {
      final gitProgress = logger.progress('Initializing git repository...');
      await _Cmd.run('git', ['init', '--initial-branch', 'main']);
      await _Cmd.run('git', ['add', '.']);
      await _Cmd.run('git', ['commit', '-m "Setup: initial project setup"']);
      gitProgress.complete('Initialized git repository....');
    } else {
      return;
    }
  }
}
