class UserModel {
  String _namaDepan;
  String _namaBelakang;
  String _email;
  String _tanggalLahir;
  String _jenisKelamin;
  String _password;
  String _fotoProfil;



  UserModel(this._namaDepan, this._namaBelakang, this._email, this._tanggalLahir, this._jenisKelamin, this._password, this._fotoProfil);

  UserModel.map(dynamic obj) {
    this._namaDepan = obj['namaDepan'];
    this._namaBelakang = obj['namaBelakang'];
    this._email = obj['email'];
    this._tanggalLahir = obj['tanggalLahir'];
    this._jenisKelamin = obj['jenisKelamin'];
    this._password = obj['password'];
    this._fotoProfil = obj['fotoProfil'];
  }

  String get namaDepan => _namaDepan;
  String get namaBelakang => _namaBelakang;
  String get email => _email;
  String get tanggalLahir => _tanggalLahir;
  String get jenisKelamin => _jenisKelamin;
  String get password => _password;
  String get fotoProfil => _fotoProfil;

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["namaDepan"] = _namaDepan;
    map["namaBelakang"] = _namaBelakang;
    map["email"] = _email;
    map["tanggalLahir"] = _tanggalLahir;
    map["jenisKelamin"] = _jenisKelamin;
    map["password"] = _password;
    map["fotoProfil"] = _fotoProfil;
    return map;
  }
}