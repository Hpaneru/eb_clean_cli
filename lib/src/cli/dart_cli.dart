/*
 * Copyright (c) 2022.
 * Author: Kishor Mainali
 * Company: EB Pearls
 *
 */

part of 'cli.dart';

/// Dart CLI
class DartCli {
  /// Determine whether dart is installed.
  static Future<bool> installed() async {
    try {
      await _Cmd.run('dart', ['--version']);
      return true;
    } catch (_) {
      return false;
    }
  }

  /// Apply all fixes (`dart fix --apply`).
  static Future<void> applyFixes({
    String cwd = '.',
    bool recursive = false,
  }) async {
    if (!recursive) {
      final pubspec = File(p.join(cwd, 'pubspec.yaml'));
      if (!pubspec.existsSync()) throw PubspecNotFound();

      await _Cmd.run('dart', ['fix', '--apply'], workingDirectory: cwd);
      return;
    }

    final processes = _Cmd.runWhere(
      run: (entity) => _Cmd.run(
        'dart',
        ['fix', '--apply'],
        workingDirectory: entity.parent.path,
      ),
      where: _isPubspec,
      cwd: cwd,
    );

    if (processes.isEmpty) throw PubspecNotFound();

    await Future.wait<void>(processes);
  }

  /// Format all files (`dart format .`).
  static Future<void> formatCode({
    String cwd = '.',
    bool recursive = false,
  }) async {
    if (!recursive) {
      final pubspec = File(p.join(cwd, 'pubspec.yaml'));
      if (!pubspec.existsSync()) throw PubspecNotFound();
      await _Cmd.run('dart', ['format', '.'], workingDirectory: cwd);
      return;
    }

    final processes = _Cmd.runWhere(
      run: (entity) => _Cmd.run(
        'dart',
        ['format', '.'],
        workingDirectory: entity.parent.path,
      ),
      where: _isPubspec,
      cwd: cwd,
    );

    if (processes.isEmpty) throw PubspecNotFound();
    await Future.wait<void>(processes);
  }
}
