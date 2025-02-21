class Cep {
  String? objectId;
  String cep;
  String logradouro;
  String complemento;
  String bairro;
  String localidade;
  String uf;
  String? ibge;
  String? gia;
  String? ddd;
  String? siafi;

  Cep({
    this.objectId,
    required this.cep,
    required this.logradouro,
    required this.complemento,
    required this.bairro,
    required this.localidade,
    required this.uf,
    this.ibge,
    this.gia,
    this.ddd,
    this.siafi,
  });

  factory Cep.fromJsonViaCep(Map<String, dynamic> json) {
    return Cep(
      cep: json['cep'] ?? '',
      logradouro: json['logradouro'] ?? '',
      complemento: json['complemento'] ?? '',
      bairro: json['bairro'] ?? '',
      localidade: json['localidade'] ?? '',
      uf: json['uf'] ?? '',
      ibge: json['ibge'],
      gia: json['gia'],
      ddd: json['ddd'],
      siafi: json['siafi'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cep': cep.replaceAll('-', ''),
      'logradouro': logradouro,
      'complemento': complemento,
      'bairro': bairro,
      'localidade': localidade,
      'uf': uf,
      'ibge': ibge,
      'gia': gia,
      'ddd': ddd,
      'siafi': siafi,
    };
  }

  factory Cep.fromJsonBack4App(Map<String, dynamic> json) {
    return Cep(
      objectId: json['objectId'],
      cep: json['cep'] ?? '',
      logradouro: json['logradouro'] ?? '',
      complemento: json['complemento'] ?? '',
      bairro: json['bairro'] ?? '',
      localidade: json['localidade'] ?? '',
      uf: json['uf'] ?? '',
      ibge: json['ibge'],
      gia: json['gia'],
      ddd: json['ddd'],
      siafi: json['siafi'],
    );
  }

  @override
  String toString() {
    return 'Cep{cep: $cep, logradouro: $logradouro, localidade: $localidade}';
  }
}
