class CatatanModel {
  int _id ;
  String _judul;
  String _deskripsi;
  String _waktu;
  String _interval;
  String _lampiran;



  CatatanModel(this._id, this._judul, this._deskripsi, this._waktu, this._interval, this._lampiran);

  CatatanModel.map(dynamic obj) {
    this._id = obj['id'];
    this._judul = obj['judul'];
    this._deskripsi = obj['deskripsi'];
    this._waktu = obj['waktuPengingat'];
    this._interval = obj['intervalPengingat'];
    this._lampiran = obj['lampiran'];
  }

  int get id => _id;
  String get judul => _judul;
  String get deskripsi => _deskripsi;
  String get waktu => _waktu;
  String get interval => _interval;
  String get lampiran => _lampiran;

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = _id;
    map["judul"] = _judul;
    map["deskripsi"] = _deskripsi;
    map["waktuPengingat"] = _waktu;
    map["intervalPengingat"] = _interval;
    map["lampiran"] = _lampiran;
    return map;
  }
}