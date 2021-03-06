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

  final _formKey = GlobalKey<FormState>();

  var _db = AnotacaoHelper();
  var _ultimaAnotacaoRemovida;

  List<Anotacao> anotacoes = List<Anotacao>();
  List<Anotacao> anotacoesRemovidas = List<Anotacao>();

  String _stateTitulo = "";
  String _stateButton = "";

  _deleteAlertDialog(Anotacao anotacao, BuildContext context){
    showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            title: Text(
              "Deseja Realmente deletar essa Anotação?",
              style: TextStyle(
                color: KPrimaryColor.withOpacity(0.8),
                fontSize: 18,
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
                child: Text(
                  "Confirmar",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                color: KPrimaryColor.withOpacity(0.8),
                onPressed: (){
                  setState(() async {
                    //salvar
                    await _db.removerAnotacao( anotacao.id );
                    recuperarAnotacoes();
                    Navigator.pop(context);
                    Navigator.pop(context);
                    Navigator.pop(context);

                  });
                },
              ),
            ],
          );
        }
    );
  }

  _cadastro( Size size, {Anotacao anotacao}){

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
          child: Scaffold(
                appBar: AppBar(
                  automaticallyImplyLeading: false,
                  title: Text(
                    "$_stateTitulo",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: size.height*0.028, //18
                    ),
                  ),
                  actions: <Widget>[
                    Builder(
                        builder: (context) => IconButton(
                          icon: Icon(Icons.check),
                          onPressed: (){
                            //salvar
                            if(_formKey.currentState.validate()){
                              salvarAtualizarAnotacao(anotacaoSelecionada: anotacao);
                              Navigator.pop(context);
                            }
                          },
                        ),
                    ),

                    IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                //backgroundColor: KPrimaryColor.withOpacity(0.9),

                body: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(top: size.height*0.016, bottom: size.height*0.017, left: size.width*0.023, right: size.width*0.023),
                          child: TextFormField(
                            //maxLength: 18,
                            controller: _tituloController,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(top: size.height*0.019,
                                  bottom: size.height*0.013,
                                  left: size.width*0.034,
                                  right: size.width*0.023),
                              labelText: "Título:",
                              labelStyle: TextStyle(
                                color: KPrimaryColor.withOpacity(0.9),
                              ),
                              hintText: "Insira o Título...",
                              hintStyle: TextStyle(
                                color: KPrimaryColor.withOpacity(0.3),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                            ),

                            // ignore: missing_return
                            validator: (valor){
                              if(valor.isEmpty) return "Campo Obrigatório!";
                              //if(valor.length > 18) return "Max: 18 Letras!";
                              return null;
                            },
                          ),
                        ),


                        Padding(
                          padding: EdgeInsets.only(bottom: size.height*0.013, left: size.width*0.023, right: size.width*0.023),
                          child: TextFormField(
                            enabled: true,
                            maxLines: 23,
                            controller: _descricaoController,
                            decoration: InputDecoration(
                              //contentPadding: EdgeInsets.only(top: size.height*0.019, bottom: size.height*0.58, left: size.width*0.034, right: size.width*0.01),
                              labelText: "Descrição:",
                              labelStyle: TextStyle(
                                color: KPrimaryColor.withOpacity(0.9),
                              ),
                              hintText: "Insira a Descrição...",
                              hintStyle: TextStyle(
                                color: KPrimaryColor.withOpacity(0.3),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                            ),
                            validator: (valor){
                              if(valor.isEmpty) return "Campo Obrigatório!";
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
    );
  }

  _visualizar(Anotacao anotacao, Size size){

    _descricaoController.text = anotacao.descricao;

    showDialog(
        context: context,
        builder: (context){
          return Scaffold(
            appBar: AppBar(
              title: Text("${anotacao.titulo}"),

              actions: <Widget>[
                PopupMenuButton(
                  elevation: size.height*0.02,
                  icon: Icon(Icons.more_vert),
                  itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                    PopupMenuItem(
                      child: ListTile(
                        leading: Icon(Icons.edit),
                        title: Text('Editar'),
                        onTap: (){
                          _cadastro(size, anotacao: anotacao);
                        },
                      ),
                    ),

                    PopupMenuDivider(),

                    PopupMenuItem(
                      child: ListTile(
                        leading: Icon(Icons.delete),
                        title: Text('Deletar'),
                        onTap: () async {
                          setState(() {
                            _deleteAlertDialog(anotacao, context);
                          });
                        },
                      ),
                    ),
                  ],
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

                    /*
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
                    */

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

  void recuperarAnotacoes() async {
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
        child: _loading ? Container(
          constraints: BoxConstraints.expand(width: 40, height: 40),
          child: CircularProgressIndicator(
            backgroundColor: KPrimaryColor.withOpacity(0.7),
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            //strokeWidth: 10,
          ),
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

                            final snackBar = SnackBar(
                              //behavior: SnackBarBehavior.floating,
                              content: Text('Text label'),
                              action: SnackBarAction(
                                label: 'Action',
                                onPressed: () {},
                              ),
                            );

                            // Find the Scaffold in the widget tree and use
                            // it to show a SnackBar.
                            Scaffold.of(context).showSnackBar(snackBar);
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

    super.initState();
    _helper.getAll().then((list) {
      setState(() {
        anotacoes = list;
        _loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "$KNameAplication",
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
          onPressed: () {
            _cadastro(size);
          },
        ),
    );
  }
}
