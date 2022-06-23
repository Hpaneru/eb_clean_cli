/*
 * Copyright (c) 2022.
 * Author: Kishor Mainali
 * Company: EB Pearls
 *
 */

import 'dart:async';
import 'dart:convert';

import 'package:mason_logger/mason_logger.dart';
import 'package:path/path.dart' as p;
import 'package:pubspec_parse/pubspec_parse.dart';
import 'package:universal_io/io.dart';

part 'dart_cli.dart';
part 'flutter_cli.dart';
part 'git_cli.dart';

/// Abstraction for running commands.dart via command-line.
class _Cmd {
  static final Logger logger = Logger();

  /// starts the command with the given [cmd] and [args].
  static Future<int> start(
    String cmd,
    List<String> args, {
    bool throwOnError = true,
    String? workingDirectory,
  }) async {
    final result = await Process.start(cmd, args, workingDirectory: workingDirectory, runInShell: true);
    await result.stdout.transform(utf8.decoder).map((event) => event.replaceAll('\n', '')).forEach(logger.info);
    if (throwOnError) {
      _throwIfProcessFailed(ProcessResult(result.pid, await result.exitCode, result.stdout, result.stderr), cmd, args);
    }
    return await result.exitCode;
  }

  /// Runs the specified [cmd] with the provided [args].
  static Future<ProcessResult> run(
    String cmd,
    List<String> args, {
    bool throwOnError = true,
    String? workingDirectory,
  }) async {
    final result = await Process.run(
      cmd,
      args,
      workingDirectory: workingDirectory,
      runInShell: true,
    );

    if (throwOnError) {
      _throwIfProcessFailed(result, cmd, args);
    }
    return result;
  }

  /// Runs the specified [cmd] with the provided [args] and returns the stdout in specified condition.
  static Iterable<Future<T>> runWhere<T>({
    required Future<T> Function(FileSystemEntity) run,
    required bool Function(FileSystemEntity) where,
    String cwd = '.',
  }) {
    return Directory(cwd).listSync(recursive: true).where(where).map(run);
  }

  /// Throws an error if the [pr] indicates a failure.
  static void _throwIfProcessFailed(
    ProcessResult pr,
    String process,
    List<String> args,
  ) {
    if (pr.exitCode != 0) {
      final values = {'Standard out': pr.stdout.toString().trim(), 'Standard error': pr.stderr.toString().trim()}
        ..removeWhere((k, v) => v.isEmpty);

      var message = 'Unknown error';
      if (values.isNotEmpty) {
        message = values.entries.map((e) => '${e.key}\n${e.value}').join('\n');
      }

      throw ProcessException(process, args, message, pr.exitCode);
    }
  }
}

const _ignoredDirectories = {
  'ios',
  'android',
  'windows',
  'linux',
  'macos',
  '.symlinks',
  '.plugin_symlinks',
  '.dart_tool',
  'build',
  '.fvm',
};

/// Checks is directory contains pubspec.yaml file.
bool _isPubspec(FileSystemEntity entity) {
  final segments = p.split(entity.path).toSet();
  if (segments.intersection(_ignoredDirectories).isNotEmpty) return false;
  if (entity is! File) return false;
  return p.basename(entity.path) == 'pubspec.yaml';
}
