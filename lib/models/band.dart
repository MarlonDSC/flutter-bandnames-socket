class Band {
  String id;
  String name;
  int votes;

  Band({
    required this.id,
    required this.name,
    required this.votes,
  });

  factory Band.fromMap(Map<String, dynamic> obj) {
    return Band(
      id: obj['id'] ?? '0',
      name: obj['name'] ?? 'no name',
      votes: obj['votes']?? 0,
    );
  }
}
