import 'package:args/args.dart';
import 'package:localization_tools/localization_tools.dart';

void main(List<String> arguments) {
  final translationArgParser= ArgParser()
    ..addOption("base", abbr: "b", help: "Base file with configurations and keys", defaultsTo: "base.json")
    ..addOption("compare", abbr: "c", help: "File the base file is compared against", defaultsTo: "de-DE.json")
    ..addFlag("single", abbr: "s", help: "Only update the compared file");
  final keysArgParser = ArgParser()
    ..addOption("base", abbr: "b", help: "Base file with configurations and keys", defaultsTo: "base.json")
    ..addOption("name", abbr: "n", help: "Name for the generated keys file", defaultsTo: "translation_keys.g.dart")
    ..addOption("output", abbr: "o", help: "Output dir for the generated keys file", defaultsTo: "lib/generated");

  final parser = ArgParser()
    ..addOption("dir", abbr: "d", help: "directory for language files", defaultsTo: "assets/lang")
    ..addCommand("translate", translationArgParser)
    ..addCommand("keys", keysArgParser);



  final args = parser.parse(arguments);

  chooseAction(args);
}
