import 'package:annotations/helper/model/anotacao.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:annotations/helper/anotacao_helper.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

import '../constants.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  TextEditingController _tituloController = TextEditingController();
  TextEditingController _descricaoController = TextEditingController();

  AnotacaoHelper _helper = AnotacaoHelper();

  bool _loading = true;
  bool _stateFloatingButton;

  final _formKey = GlobalKey<FormState>();

  var _db = AnotacaoHelper();
  var _ultimaAnotacaoRemovida;

  List<Anotacao> anotacoes = List<Anotacao>();
  List<Anotacao> anotacoesRemovidas = List<Anotacao>();

  String _stateTitulo = "";
  String _stateButton = "";

  _cadastro( {Anotacao anotacao} ){

    if( anotacao == null ){
      //salvando
      _tituloController.text = "";
      _descricaoController.text = "";
      _stateTitulo = "Adicionar Anotação";
      _stateButton = "Adicionar";
    }
    else{
      //editando
      _tituloController.text = anotacao.titulo;
      _descricaoController.text = anotacao.descricao;
      _stateTitulo = "${anotacao.titulo}";
      _stateButton = "Alterar";
    }

    showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            title: Text(
              "$_stateTitulo",
              style: TextStyle(
                color: KPrimaryColor.withOpacity(0.8),
                fontSize: 18,
              ),
            ),
            content: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 16, bottom: 16),
                      child: TextFormField(
                        maxLength: 18,
                        controller: _tituloController,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(top: 12, bottom: 8, left: 12, right: 8),
                          labelText: "Título:",
                          labelStyle: TextStyle(
                            color: KPrimaryColor.withOpacity(0.9),
                          ),
                          hintText: "Insira o Título...",
                          hintStyle: TextStyle(
                            color: KPrimaryColor.withOpacity(0.3),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(1),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),

                        // ignore: missing_return
                        validator: (valor){
                          if(valor.isEmpty) return "Campo Obrigatório!";
                          if(valor.length > 18) return "Max: 18 Letras!";
                          return null;
                        },
                      ),
                    ),

                    TextFormField(
                      maxLines: 5,
                      controller: _descricaoController,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(top: 12, bottom: 2, left: 12, right: 2),
                        labelText: "Descrição:",
                        labelStyle: TextStyle(
                          color: KPrimaryColor.withOpacity(0.9),
                        ),
                        hintText: "Insira a Descrição...",
                        hintStyle: TextStyle(
                          color: KPrimaryColor.withOpacity(0.3),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(1),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      validator: (valor){
                        if(valor.isEmpty) return "Campo Obrigatório!";
                        return null;
                      },
                    )
                  ],
                ),
              ),
            ),
            actions: <Widget>[
              FlatButton(
                  onPressed: () => Navigator.pop(context),
                  color: Colors.white,
                  child: Text(
                    "Cancelar",
                    style: TextStyle(
                      color: KPrimaryColor.withOpacity(0.8),
                    ),
                  )
              ),
              FlatButton(
                onPressed: (){
                  //salvar
                  if(_formKey.currentState.validate()){
                    setState(() {
                      _stateFloatingButton = true;
                    });
                    salvarAtualizarAnotacao(anotacaoSelecionada: anotacao);
                    Navigator.pop(context);
                  }
                },
                color: KPrimaryColor.withOpacity(0.8),
                child: Text(
                  _stateButton,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          );
        }
    );
  }

  _visualizar(Anotacao anotacao, Size size){

    _tituloController.text = anotacao.titulo.toUpperCase();
    _descricaoController.text = anotacao.descricao;

    showDialog(
        context: context,
        builder: (context){
          return Scaffold(
            appBar: AppBar(
              actions: <Widget>[
                IconButton(
                  icon: Icon(
                    Icons.clear,
                    color: Colors.white70,
                    size: size.height * 0.05,
                  ),
                  onPressed: () {
                    if(_formKey.currentState.validate()){
                      salvarAtualizarAnotacao(anotacaoSelecionada: anotacao);
                      Navigator.pop(context);
                    }
                  },
                ),

                IconButton(
                  icon: Icon(
                    Icons.edit,
                    //color: Colors.white70,
                    size: 30,
                  ),
                  onPressed: (){

                  },
                ),

                PopupMenuItem(
                  child: ListTile(
                    leading: Icon(Icons.edit),
                    title: Text('Editar'),
                    onTap: (){
                      _cadastro(anotacao: anotacao);
                    },
                  ),
                ),

                PopupMenuDivider(),

                PopupMenuItem(
                  child: ListTile(
                    leading: Icon(Icons.article),
                    title: Text('Item 3'),
                  ),
                ),

              ],
              backgroundColor: KPrimaryColor.withOpacity(0.9),
            ),

            body: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[

                    Padding(
                      padding: EdgeInsets.only(top: 12, left: 12, bottom: 0, right: 12),
                      child: TextFormField(
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                        ),
                        enabled: true,
                        controller: _tituloController,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(top: 8, bottom: 6, left: 8, right: 6),
                          labelText: "Título:",
                          labelStyle: TextStyle(
                            fontSize: 18,
                            color: KPrimaryColor,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(1),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.only(top: 16, left: 12, bottom: 12, right: 12),
                      child: TextFormField(
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                        ),
                        enabled: true,
                        maxLines: 23,
                        controller: _descricaoController,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(top: 8, bottom: 6, left: 8, right: 6),
                          labelText: "Descrição:",
                          labelStyle: TextStyle(
                            color: KPrimaryColor.withOpacity(0.9),
                          ),
                          hintText: "Insira a Descrição...",
                          hintStyle: TextStyle(
                            color: KPrimaryColor.withOpacity(0.3),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(1),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        validator: (valor){
                          if(valor.isEmpty) return "Campo Obrigatório!";
                          return null;
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        }
    );
  }

  recuperarAnotacoes() async {

    List anotacoesRecuperadas = await _db.recuperarAnotacoes();

    List<Anotacao> listaTemporaria = List<Anotacao>();
    for( var item in anotacoesRecuperadas ){
      Anotacao anotacao = Anotacao.fromMap( item );
      listaTemporaria.add( anotacao );
    }

    setState(() {
      anotacoes = listaTemporaria;
    });
    listaTemporaria = null;
  }

  salvarAtualizarAnotacao( {Anotacao anotacaoSelecionada} ) async {

    String titulo = _tituloController.text.toUpperCase();
    String descricao = _descricaoController.text;

    if( anotacaoSelecionada == null ){//salvar
      Anotacao anotacao = Anotacao(titulo, descricao, DateTime.now().toString() );
      await _db.salvarAnotacao( anotacao );
    }else{//atualizar
      anotacaoSelecionada.titulo = titulo;
      anotacaoSelecionada.descricao = descricao;
      anotacaoSelecionada.data = DateTime.now().toString();
      await _db.atualizarAnotacao( anotacaoSelecionada );
    }

    _tituloController.clear();
    _descricaoController.clear();

    recuperarAnotacoes();
  }

  _formatarData(String data){

    initializeDateFormatting("pt_BR");
    var formatador = DateFormat.yMd("pt_BR");

    DateTime dataConvertida = DateTime.parse( data );
    String dataFormatada = formatador.format( dataConvertida );

    return dataFormatada;
  }

  Widget _buildTaskList(Size size) {
    if (anotacoes.isEmpty) {
      return Center(
        child: _loading ? CircularProgressIndicator(
          backgroundColor: KPrimaryColor.withOpacity(0.7),
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ) : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Sem Anotações!",
              style: TextStyle(
                color: KPrimaryColor.withOpacity(0.7),
                fontSize: size.height * 0.023,
              ),
            ),
          ],
        ),
      );
    } else {
        return Scrollbar(
          child: Column(
            children: <Widget>[
              Expanded(
                  child: ListView.builder(
                      itemCount: anotacoes.length,
                      itemBuilder: (context, index){

                        final anotacao = anotacoes[index];

                        return Card(
                          child: Dismissible(
                            key: Key( DateTime.now().millisecondsSinceEpoch.toString() ),
                            direction: DismissDirection.endToStart,
                            onDismissed: (direction) async {

                              //recuperar último item excluído

                              _ultimaAnotacaoRemovida = anotacao;
                              anotacoesRemovidas.add(_ultimaAnotacaoRemovida);

                              await _db.removerAnotacao( anotacao.id );

                              recuperarAnotacoes();

                              final snackbar = SnackBar(
                                //backgroundColor: Colors.green,
                                duration: Duration(seconds: 3),
                                content: Text(
                                  "Removendo ${anotacao.titulo}...",
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.8),
                                  ),
                                ),
                                action: SnackBarAction(
                                    textColor: Colors.white.withOpacity(0.8),
                                    label: "Desfazer",
                                    onPressed: () async {
                                      setState(() async {
                                        //Insere novamente item removido na lista
                                        for( int loop = 0; loop < anotacoesRemovidas.length; loop++){
                                          if(anotacoesRemovidas[loop] == anotacao){
                                            await _db.salvarAnotacao( anotacoesRemovidas[loop] );
                                            anotacoesRemovidas.removeAt(loop);
                                            recuperarAnotacoes();
                                            break;
                                          }
                                        }
                                      });
                                      recuperarAnotacoes();
                                    }
                                ),
                              );
                              Scaffold.of(context).showSnackBar(snackbar);

                            },
                            background: Container(
                              color: Colors.red.withOpacity(0.9),
                              padding: EdgeInsets.all(16),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  Icon(
                                    Icons.delete,
                                    color: Colors.white,
                                  )
                                ],
                              ),
                            ),
                            child: ListTile(
                              onTap: (){
                                _visualizar(anotacao, size);
                              },
                              title: Text(
                                anotacao.titulo,
                                style: TextStyle(
                                  fontSize: 17,
                                  color: KPrimaryColor.withOpacity(0.8),
                                  fontStyle: FontStyle.italic,
                                  fontWeight: FontWeight.bold,
                                  decorationStyle: TextDecorationStyle.dashed,
                                ),
                              ),
                              trailing: Column(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: <Widget>[
                                  Text(
                                    "${_formatarData(anotacao.data)}",
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: KPrimaryColor.withOpacity(0.8),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }
                  )
              )
            ],
          ),
        );
    }
  }

  @override
  void initState() {
    _loading = true;
    _stateFloatingButton = true;
    super.initState();
    _helper.getAll().then((list) {
      setState(() {
        anotacoes = list;
        _loading = false;
        _stateFloatingButton = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Annotations",
          style: TextStyle(
            fontSize: size.height * 0.031,
            color: Colors.white,
          ),
        ),
        backgroundColor: KPrimaryColor.withOpacity(0.9),
      ),

      body: _buildTaskList(size),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,

      floatingActionButton: FloatingActionButton(
            mini: false,
            backgroundColor: KPrimaryColor.withOpacity(0.8),
            foregroundColor: Colors.white,
            child: Icon(Icons.add),
            onPressed: (){
              _cadastro();
            }
        ),
    );
  }
}