import 'package:hive/hive.dart';

part 'xApiObj.g.dart';

@HiveType(typeId: 1)
class XApiObj {
  //** AGENT **
  @HiveField(0)
  final String mbox;
  @HiveField(1)
  final String name;

  //** Verb **
  @HiveField(2)
  final String verbId;
  @HiveField(3)
  final Map<String, String> display;

  //** Activity **
  @HiveField(4)
  final String activityId;
  @HiveField(5)
  final String definitionType;
  @HiveField(6)
  final Map<String, String> definitionName;
  @HiveField(7)
  final Map<String, String> definitionDescription;

  XApiObj({
    //Agent
    required this.mbox,
    required this.name,
    //Verb
    required this.verbId,
    required this.display,
    //Activity
    required this.activityId,
    required this.definitionType,
    required this.definitionName,
    required this.definitionDescription
  });

  @override
  String toString() {
    return  'Statement( \n'
            'actor: Agent(\n'
            '  mbox: \'$mbox\',\n'
            '  name: \'$name\',\n'
            '),\n'
            'verb: Verb(\n'
            '  id: \'$verbId\',\n'
            '  display: \''+display.keys.first+':'+display.values.first+'\',\n'
            '),\n'
            'object: Activity(\n'
            '  id: \'$activityId\',\n'
            '  definition: ActivityDefinition(\n'
            '    type: \'$definitionType\',\n'
            '    name: \''+definitionName.keys.first+':'+definitionName.values.first+'\',\n'
            '    description: \''+definitionDescription.keys.first+':'+definitionDescription.values.first+',\n'
            '  ),\n'
            '),\n';
  }

}