import 'dart:convert';
import 'dart:io';

import 'package:args/args.dart';
import 'package:dart_style/dart_style.dart';
import 'package:localization_tools/utils/flatten.dart';
import 'package:localization_tools/utils/language_entry.dart';


import 'package:path/path.dart' as path;


Future<void> generateKeys(ArgResults args, String baseDir) async {
  if (args["base"] == null || args["output"] == null || args["name"] == null) {
    stderr.writeln("Not enough arguments specified! Type --help or -h for more information.");
    stdout.writeln("Press enter to exit");
    stdin.readLineSync();
    return;
  }

  if (!Directory(baseDir).existsSync()) {
    stdout.writeln("Could not find the directory specified for the language files: '${args["dir"]}'");
    stdout.writeln("Press enter to exit");
    stdin.readLineSync();
    return;
  }

  final fullBasePath = path.join(baseDir, args["base"] as String);
  final fullOutputPath = path.join(args["output"], args["name"] as String);

  if (!File(fullBasePath).existsSync()) {
    stdout.writeln("Could not find the base file: '$fullBasePath'");
    stdout.writeln("Press enter to exit");
    stdin.readLineSync();
    return;
  }

  final fileStr = await File(fullBasePath).readAsString();
  final jsonData = jsonDecode(fileStr) as Map<String, dynamic>;

  final flattened = flattenMap(jsonData, [], {});
  final keyMap = generateKeyMap(flattened);
  await generateKeysFile(keyMap, fullOutputPath);

  stdout.writeln("Successfully generated keys. Exiting now..");
  sleep(Duration(seconds: 5));
}


Map<String, dynamic> generateKeyMap(Map<String, LanguageEntry> flattened) {
  final keyMap = <String, dynamic>{};
  for (final entry in flattened.entries) {
    final nodes = entry.key.split('.');
    mapFromNodes(keyMap, nodes, 0, entry.key, sanitize: true);
  }
  return keyMap;
}

Future<void> generateKeysFile(Map<String, dynamic> keyMap, String outputPath) async {
  String mapStr = keyMap.toString();
  mapStr = mapStr.replaceAll("{", "(");
  mapStr = mapStr.replaceAll("}", ")");
  mapStr = mapStr.replaceAll(RegExp(r': (?!\()'), ": '");
  mapStr = mapStr.replaceAll(RegExp(r'(?<=[A-Z a-z0-9]),'), "',");
  mapStr = mapStr.replaceAll(RegExp(r'(?<=[A-Za-z0-9])\)'), "')");


  final content = "const translationKeys = $mapStr;";

  final formatted = DartFormatter().format(content);

  await File(outputPath).create(recursive: true);
  await File(outputPath).writeAsString(formatted);

}

