// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class ContratacaoFranqueadoStruct extends BaseStruct {
  ContratacaoFranqueadoStruct({
    String? nomeResponsavel,
    String? emailResponsavel,
    String? senha,
    String? cep,
    String? endereco,
    String? bairro,
    String? cidade,
    String? cpfResponsavel,
    String? numero,
    String? complemento,
    String? uf,
    double? plano,
    String? indication,
    String? cnpjConta,
    String? razaoSocial,
    String? nomeFantasia,
    String? tipoCadastro,
    double? valor,
    int? parcelas,
    double? valorParcela,
    String? formaPagamento,
    String? imagemQr,
    String? copiaecola,
    String? status,
    String? idFranquiaCriada,
    String? telefone,
    String? idpagamentoAsaas,
  })  : _nomeResponsavel = nomeResponsavel,
        _emailResponsavel = emailResponsavel,
        _senha = senha,
        _cep = cep,
        _endereco = endereco,
        _bairro = bairro,
        _cidade = cidade,
        _cpfResponsavel = cpfResponsavel,
        _numero = numero,
        _complemento = complemento,
        _uf = uf,
        _plano = plano,
        _indication = indication,
        _cnpjConta = cnpjConta,
        _razaoSocial = razaoSocial,
        _nomeFantasia = nomeFantasia,
        _tipoCadastro = tipoCadastro,
        _valor = valor,
        _parcelas = parcelas,
        _valorParcela = valorParcela,
        _formaPagamento = formaPagamento,
        _imagemQr = imagemQr,
        _copiaecola = copiaecola,
        _status = status,
        _idFranquiaCriada = idFranquiaCriada,
        _telefone = telefone,
        _idpagamentoAsaas = idpagamentoAsaas;

  // "nomeResponsavel" field.
  String? _nomeResponsavel;
  String get nomeResponsavel => _nomeResponsavel ?? '';
  set nomeResponsavel(String? val) => _nomeResponsavel = val;

  bool hasNomeResponsavel() => _nomeResponsavel != null;

  // "emailResponsavel" field.
  String? _emailResponsavel;
  String get emailResponsavel => _emailResponsavel ?? '';
  set emailResponsavel(String? val) => _emailResponsavel = val;

  bool hasEmailResponsavel() => _emailResponsavel != null;

  // "senha" field.
  String? _senha;
  String get senha => _senha ?? '';
  set senha(String? val) => _senha = val;

  bool hasSenha() => _senha != null;

  // "cep" field.
  String? _cep;
  String get cep => _cep ?? '';
  set cep(String? val) => _cep = val;

  bool hasCep() => _cep != null;

  // "endereco" field.
  String? _endereco;
  String get endereco => _endereco ?? '';
  set endereco(String? val) => _endereco = val;

  bool hasEndereco() => _endereco != null;

  // "bairro" field.
  String? _bairro;
  String get bairro => _bairro ?? '';
  set bairro(String? val) => _bairro = val;

  bool hasBairro() => _bairro != null;

  // "cidade" field.
  String? _cidade;
  String get cidade => _cidade ?? '';
  set cidade(String? val) => _cidade = val;

  bool hasCidade() => _cidade != null;

  // "cpfResponsavel" field.
  String? _cpfResponsavel;
  String get cpfResponsavel => _cpfResponsavel ?? '';
  set cpfResponsavel(String? val) => _cpfResponsavel = val;

  bool hasCpfResponsavel() => _cpfResponsavel != null;

  // "numero" field.
  String? _numero;
  String get numero => _numero ?? '';
  set numero(String? val) => _numero = val;

  bool hasNumero() => _numero != null;

  // "complemento" field.
  String? _complemento;
  String get complemento => _complemento ?? '';
  set complemento(String? val) => _complemento = val;

  bool hasComplemento() => _complemento != null;

  // "uf" field.
  String? _uf;
  String get uf => _uf ?? '';
  set uf(String? val) => _uf = val;

  bool hasUf() => _uf != null;

  // "plano" field.
  double? _plano;
  double get plano => _plano ?? 0.0;
  set plano(double? val) => _plano = val;

  void incrementPlano(double amount) => plano = plano + amount;

  bool hasPlano() => _plano != null;

  // "indication" field.
  String? _indication;
  String get indication => _indication ?? '';
  set indication(String? val) => _indication = val;

  bool hasIndication() => _indication != null;

  // "cnpjConta" field.
  String? _cnpjConta;
  String get cnpjConta => _cnpjConta ?? '';
  set cnpjConta(String? val) => _cnpjConta = val;

  bool hasCnpjConta() => _cnpjConta != null;

  // "razaoSocial" field.
  String? _razaoSocial;
  String get razaoSocial => _razaoSocial ?? '';
  set razaoSocial(String? val) => _razaoSocial = val;

  bool hasRazaoSocial() => _razaoSocial != null;

  // "nomeFantasia" field.
  String? _nomeFantasia;
  String get nomeFantasia => _nomeFantasia ?? '';
  set nomeFantasia(String? val) => _nomeFantasia = val;

  bool hasNomeFantasia() => _nomeFantasia != null;

  // "tipoCadastro" field.
  String? _tipoCadastro;
  String get tipoCadastro => _tipoCadastro ?? '';
  set tipoCadastro(String? val) => _tipoCadastro = val;

  bool hasTipoCadastro() => _tipoCadastro != null;

  // "valor" field.
  double? _valor;
  double get valor => _valor ?? 0.0;
  set valor(double? val) => _valor = val;

  void incrementValor(double amount) => valor = valor + amount;

  bool hasValor() => _valor != null;

  // "parcelas" field.
  int? _parcelas;
  int get parcelas => _parcelas ?? 0;
  set parcelas(int? val) => _parcelas = val;

  void incrementParcelas(int amount) => parcelas = parcelas + amount;

  bool hasParcelas() => _parcelas != null;

  // "valorParcela" field.
  double? _valorParcela;
  double get valorParcela => _valorParcela ?? 0.0;
  set valorParcela(double? val) => _valorParcela = val;

  void incrementValorParcela(double amount) =>
      valorParcela = valorParcela + amount;

  bool hasValorParcela() => _valorParcela != null;

  // "formaPagamento" field.
  String? _formaPagamento;
  String get formaPagamento => _formaPagamento ?? '';
  set formaPagamento(String? val) => _formaPagamento = val;

  bool hasFormaPagamento() => _formaPagamento != null;

  // "imagemQr" field.
  String? _imagemQr;
  String get imagemQr => _imagemQr ?? '';
  set imagemQr(String? val) => _imagemQr = val;

  bool hasImagemQr() => _imagemQr != null;

  // "copiaecola" field.
  String? _copiaecola;
  String get copiaecola => _copiaecola ?? '';
  set copiaecola(String? val) => _copiaecola = val;

  bool hasCopiaecola() => _copiaecola != null;

  // "status" field.
  String? _status;
  String get status => _status ?? '';
  set status(String? val) => _status = val;

  bool hasStatus() => _status != null;

  // "idFranquiaCriada" field.
  String? _idFranquiaCriada;
  String get idFranquiaCriada => _idFranquiaCriada ?? '';
  set idFranquiaCriada(String? val) => _idFranquiaCriada = val;

  bool hasIdFranquiaCriada() => _idFranquiaCriada != null;

  // "telefone" field.
  String? _telefone;
  String get telefone => _telefone ?? '';
  set telefone(String? val) => _telefone = val;

  bool hasTelefone() => _telefone != null;

  // "idpagamentoAsaas" field.
  String? _idpagamentoAsaas;
  String get idpagamentoAsaas => _idpagamentoAsaas ?? '';
  set idpagamentoAsaas(String? val) => _idpagamentoAsaas = val;

  bool hasIdpagamentoAsaas() => _idpagamentoAsaas != null;

  static ContratacaoFranqueadoStruct fromMap(Map<String, dynamic> data) =>
      ContratacaoFranqueadoStruct(
        nomeResponsavel: data['nomeResponsavel'] as String?,
        emailResponsavel: data['emailResponsavel'] as String?,
        senha: data['senha'] as String?,
        cep: data['cep'] as String?,
        endereco: data['endereco'] as String?,
        bairro: data['bairro'] as String?,
        cidade: data['cidade'] as String?,
        cpfResponsavel: data['cpfResponsavel'] as String?,
        numero: data['numero'] as String?,
        complemento: data['complemento'] as String?,
        uf: data['uf'] as String?,
        plano: castToType<double>(data['plano']),
        indication: data['indication'] as String?,
        cnpjConta: data['cnpjConta'] as String?,
        razaoSocial: data['razaoSocial'] as String?,
        nomeFantasia: data['nomeFantasia'] as String?,
        tipoCadastro: data['tipoCadastro'] as String?,
        valor: castToType<double>(data['valor']),
        parcelas: castToType<int>(data['parcelas']),
        valorParcela: castToType<double>(data['valorParcela']),
        formaPagamento: data['formaPagamento'] as String?,
        imagemQr: data['imagemQr'] as String?,
        copiaecola: data['copiaecola'] as String?,
        status: data['status'] as String?,
        idFranquiaCriada: data['idFranquiaCriada'] as String?,
        telefone: data['telefone'] as String?,
        idpagamentoAsaas: data['idpagamentoAsaas'] as String?,
      );

  static ContratacaoFranqueadoStruct? maybeFromMap(dynamic data) => data is Map
      ? ContratacaoFranqueadoStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'nomeResponsavel': _nomeResponsavel,
        'emailResponsavel': _emailResponsavel,
        'senha': _senha,
        'cep': _cep,
        'endereco': _endereco,
        'bairro': _bairro,
        'cidade': _cidade,
        'cpfResponsavel': _cpfResponsavel,
        'numero': _numero,
        'complemento': _complemento,
        'uf': _uf,
        'plano': _plano,
        'indication': _indication,
        'cnpjConta': _cnpjConta,
        'razaoSocial': _razaoSocial,
        'nomeFantasia': _nomeFantasia,
        'tipoCadastro': _tipoCadastro,
        'valor': _valor,
        'parcelas': _parcelas,
        'valorParcela': _valorParcela,
        'formaPagamento': _formaPagamento,
        'imagemQr': _imagemQr,
        'copiaecola': _copiaecola,
        'status': _status,
        'idFranquiaCriada': _idFranquiaCriada,
        'telefone': _telefone,
        'idpagamentoAsaas': _idpagamentoAsaas,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'nomeResponsavel': serializeParam(
          _nomeResponsavel,
          ParamType.String,
        ),
        'emailResponsavel': serializeParam(
          _emailResponsavel,
          ParamType.String,
        ),
        'senha': serializeParam(
          _senha,
          ParamType.String,
        ),
        'cep': serializeParam(
          _cep,
          ParamType.String,
        ),
        'endereco': serializeParam(
          _endereco,
          ParamType.String,
        ),
        'bairro': serializeParam(
          _bairro,
          ParamType.String,
        ),
        'cidade': serializeParam(
          _cidade,
          ParamType.String,
        ),
        'cpfResponsavel': serializeParam(
          _cpfResponsavel,
          ParamType.String,
        ),
        'numero': serializeParam(
          _numero,
          ParamType.String,
        ),
        'complemento': serializeParam(
          _complemento,
          ParamType.String,
        ),
        'uf': serializeParam(
          _uf,
          ParamType.String,
        ),
        'plano': serializeParam(
          _plano,
          ParamType.double,
        ),
        'indication': serializeParam(
          _indication,
          ParamType.String,
        ),
        'cnpjConta': serializeParam(
          _cnpjConta,
          ParamType.String,
        ),
        'razaoSocial': serializeParam(
          _razaoSocial,
          ParamType.String,
        ),
        'nomeFantasia': serializeParam(
          _nomeFantasia,
          ParamType.String,
        ),
        'tipoCadastro': serializeParam(
          _tipoCadastro,
          ParamType.String,
        ),
        'valor': serializeParam(
          _valor,
          ParamType.double,
        ),
        'parcelas': serializeParam(
          _parcelas,
          ParamType.int,
        ),
        'valorParcela': serializeParam(
          _valorParcela,
          ParamType.double,
        ),
        'formaPagamento': serializeParam(
          _formaPagamento,
          ParamType.String,
        ),
        'imagemQr': serializeParam(
          _imagemQr,
          ParamType.String,
        ),
        'copiaecola': serializeParam(
          _copiaecola,
          ParamType.String,
        ),
        'status': serializeParam(
          _status,
          ParamType.String,
        ),
        'idFranquiaCriada': serializeParam(
          _idFranquiaCriada,
          ParamType.String,
        ),
        'telefone': serializeParam(
          _telefone,
          ParamType.String,
        ),
        'idpagamentoAsaas': serializeParam(
          _idpagamentoAsaas,
          ParamType.String,
        ),
      }.withoutNulls;

  static ContratacaoFranqueadoStruct fromSerializableMap(
          Map<String, dynamic> data) =>
      ContratacaoFranqueadoStruct(
        nomeResponsavel: deserializeParam(
          data['nomeResponsavel'],
          ParamType.String,
          false,
        ),
        emailResponsavel: deserializeParam(
          data['emailResponsavel'],
          ParamType.String,
          false,
        ),
        senha: deserializeParam(
          data['senha'],
          ParamType.String,
          false,
        ),
        cep: deserializeParam(
          data['cep'],
          ParamType.String,
          false,
        ),
        endereco: deserializeParam(
          data['endereco'],
          ParamType.String,
          false,
        ),
        bairro: deserializeParam(
          data['bairro'],
          ParamType.String,
          false,
        ),
        cidade: deserializeParam(
          data['cidade'],
          ParamType.String,
          false,
        ),
        cpfResponsavel: deserializeParam(
          data['cpfResponsavel'],
          ParamType.String,
          false,
        ),
        numero: deserializeParam(
          data['numero'],
          ParamType.String,
          false,
        ),
        complemento: deserializeParam(
          data['complemento'],
          ParamType.String,
          false,
        ),
        uf: deserializeParam(
          data['uf'],
          ParamType.String,
          false,
        ),
        plano: deserializeParam(
          data['plano'],
          ParamType.double,
          false,
        ),
        indication: deserializeParam(
          data['indication'],
          ParamType.String,
          false,
        ),
        cnpjConta: deserializeParam(
          data['cnpjConta'],
          ParamType.String,
          false,
        ),
        razaoSocial: deserializeParam(
          data['razaoSocial'],
          ParamType.String,
          false,
        ),
        nomeFantasia: deserializeParam(
          data['nomeFantasia'],
          ParamType.String,
          false,
        ),
        tipoCadastro: deserializeParam(
          data['tipoCadastro'],
          ParamType.String,
          false,
        ),
        valor: deserializeParam(
          data['valor'],
          ParamType.double,
          false,
        ),
        parcelas: deserializeParam(
          data['parcelas'],
          ParamType.int,
          false,
        ),
        valorParcela: deserializeParam(
          data['valorParcela'],
          ParamType.double,
          false,
        ),
        formaPagamento: deserializeParam(
          data['formaPagamento'],
          ParamType.String,
          false,
        ),
        imagemQr: deserializeParam(
          data['imagemQr'],
          ParamType.String,
          false,
        ),
        copiaecola: deserializeParam(
          data['copiaecola'],
          ParamType.String,
          false,
        ),
        status: deserializeParam(
          data['status'],
          ParamType.String,
          false,
        ),
        idFranquiaCriada: deserializeParam(
          data['idFranquiaCriada'],
          ParamType.String,
          false,
        ),
        telefone: deserializeParam(
          data['telefone'],
          ParamType.String,
          false,
        ),
        idpagamentoAsaas: deserializeParam(
          data['idpagamentoAsaas'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'ContratacaoFranqueadoStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is ContratacaoFranqueadoStruct &&
        nomeResponsavel == other.nomeResponsavel &&
        emailResponsavel == other.emailResponsavel &&
        senha == other.senha &&
        cep == other.cep &&
        endereco == other.endereco &&
        bairro == other.bairro &&
        cidade == other.cidade &&
        cpfResponsavel == other.cpfResponsavel &&
        numero == other.numero &&
        complemento == other.complemento &&
        uf == other.uf &&
        plano == other.plano &&
        indication == other.indication &&
        cnpjConta == other.cnpjConta &&
        razaoSocial == other.razaoSocial &&
        nomeFantasia == other.nomeFantasia &&
        tipoCadastro == other.tipoCadastro &&
        valor == other.valor &&
        parcelas == other.parcelas &&
        valorParcela == other.valorParcela &&
        formaPagamento == other.formaPagamento &&
        imagemQr == other.imagemQr &&
        copiaecola == other.copiaecola &&
        status == other.status &&
        idFranquiaCriada == other.idFranquiaCriada &&
        telefone == other.telefone &&
        idpagamentoAsaas == other.idpagamentoAsaas;
  }

  @override
  int get hashCode => const ListEquality().hash([
        nomeResponsavel,
        emailResponsavel,
        senha,
        cep,
        endereco,
        bairro,
        cidade,
        cpfResponsavel,
        numero,
        complemento,
        uf,
        plano,
        indication,
        cnpjConta,
        razaoSocial,
        nomeFantasia,
        tipoCadastro,
        valor,
        parcelas,
        valorParcela,
        formaPagamento,
        imagemQr,
        copiaecola,
        status,
        idFranquiaCriada,
        telefone,
        idpagamentoAsaas
      ]);
}

ContratacaoFranqueadoStruct createContratacaoFranqueadoStruct({
  String? nomeResponsavel,
  String? emailResponsavel,
  String? senha,
  String? cep,
  String? endereco,
  String? bairro,
  String? cidade,
  String? cpfResponsavel,
  String? numero,
  String? complemento,
  String? uf,
  double? plano,
  String? indication,
  String? cnpjConta,
  String? razaoSocial,
  String? nomeFantasia,
  String? tipoCadastro,
  double? valor,
  int? parcelas,
  double? valorParcela,
  String? formaPagamento,
  String? imagemQr,
  String? copiaecola,
  String? status,
  String? idFranquiaCriada,
  String? telefone,
  String? idpagamentoAsaas,
}) =>
    ContratacaoFranqueadoStruct(
      nomeResponsavel: nomeResponsavel,
      emailResponsavel: emailResponsavel,
      senha: senha,
      cep: cep,
      endereco: endereco,
      bairro: bairro,
      cidade: cidade,
      cpfResponsavel: cpfResponsavel,
      numero: numero,
      complemento: complemento,
      uf: uf,
      plano: plano,
      indication: indication,
      cnpjConta: cnpjConta,
      razaoSocial: razaoSocial,
      nomeFantasia: nomeFantasia,
      tipoCadastro: tipoCadastro,
      valor: valor,
      parcelas: parcelas,
      valorParcela: valorParcela,
      formaPagamento: formaPagamento,
      imagemQr: imagemQr,
      copiaecola: copiaecola,
      status: status,
      idFranquiaCriada: idFranquiaCriada,
      telefone: telefone,
      idpagamentoAsaas: idpagamentoAsaas,
    );
