class xApiObj {
  final int? id;
  final String name;

  xApiObj({this.id, required this.name});

  @override
  String toString() {
    return name;
  }

  Map<String, dynamic> toxApiMap() {
    Map<String, dynamic> map = {
      'id': id,
      'name': name,
    };
    return map;
  }


}