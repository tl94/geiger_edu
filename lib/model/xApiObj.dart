class XApiObj {
  //** AGENT **
  final String mbox;
  final String name;

  //** Verb **
  final String verbId;
  final Map<String, String> display;

  //** Activity **
  final String activityId;
  final String definitionType;
  final Map<String, String> definitionName;
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