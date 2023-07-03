

import 'package:localization_tools/utils/language_entry.dart';

Map<String, LanguageEntry> flattenMap(
    Map<String, dynamic> map,
    List<String> prevNodes,
    Map<String, LanguageEntry> flattened,
) {
  for (final entry in map.entries) {
    final nodes = List<String>.from(prevNodes)..add(entry.key);
    if (entry.value is List || entry.value is String) {
      flattened[nodes.join(".")] = LanguageEntry.fromDynamic(entry.value);
    } else if(entry.value is Map<String, dynamic>) {
      flattenMap(entry.value as Map<String, dynamic>, nodes, flattened);
    }
  }
  return flattened;
}

void mapFromNodes(
  Map<String, dynamic> prevMap,
  List<String> nodes,
  int index,
  String value, {
    bool sanitize = false,
}) {
  String node = nodes[index];
  if (sanitize) {
    node = node.replaceAll("-", "_");
  }

  if (index == nodes.length - 1) {
    prevMap[node] = value;
    return;
  }

  if (prevMap[node] == null) {
    prevMap[node] = <String, dynamic>{};
  }

  mapFromNodes(
      prevMap[node] as Map<String, dynamic>,
      nodes,
      index + 1,
      value,
      sanitize: sanitize
  );

}

Map<String, dynamic> inflateMap(Map<String, LanguageEntry> flattened) {
  final inflated = <String, dynamic>{};
  for (final entry in flattened.entries) {
    final nodes = entry.key.split('.');
    mapFromNodes(inflated, nodes, 0, entry.value.value);
  }
  return inflated;
}
