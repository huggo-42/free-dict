class Account {
  final int? id;
  final String username;
  final String password;

  Account({
    this.id,
    required this.username,
    required this.password,
  });

  factory Account.fromMap(Map<String, dynamic> map) => Account(
        id: map['id'],
        username: map['username'],
        password: map['password'],
      );
}
