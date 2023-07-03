import 'package:args/args.dart';
import 'package:localization_tools/key_generator/generate_keys.dart';
import 'package:localization_tools/translator/translate.dart';

Future<void> chooseAction(ArgResults args) async {
  final command = args.command;


  if (command == null) {
    print("Please specify a command.");
    return;
  }

  final dir = args["dir"] as String;


  if (command.name == "translate") {
    await generateTranslations(command, dir);
    return;
  }
  if (command.name == "keys") {
    await generateKeys(command, dir);
    return;
  }

  print("Invalid command.");
}