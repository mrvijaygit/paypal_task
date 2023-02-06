class User {
  String? _username;
  String? _password;
  int? _id;

  User(this._username, this._password);

  User.map(dynamic obj) {
    _username = obj['username'];
    _password = obj['password'];
    _id  = obj['id'];
  }

  String? get username => _username;
  String? get password => _password;
  int? get id => _id;

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    map["username"] = _username;
    map["password"] = _password;
    return map;
  }
}
