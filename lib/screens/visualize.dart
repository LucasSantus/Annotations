import 'package:annotations/helper/anotacao_helper.dart';
import 'package:annotations/helper/model/anotacao.dart';
import 'package:annotations/screens/home_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../constants.dart';

class Visualize extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  TextEditingController _tituloController = TextEditingController();
  TextEditingController _descricaoController = TextEditingController();

  HomeScreen homescreen;
  Anotacao anotacao;
  Size size;

  var _db = AnotacaoHelper();

  Visualize(this.anotacao, this.size);

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
                onPressed: () async {
                  //salvar
                  await _db.removerAnotacao( anotacao.id );
                  homescreen.createState().recuperarAnotacoes();
                  Navigator.pop(context);
                },
              ),
            ],
          );
        }
    );
  }

  @override
  Widget build(BuildContext context) {

    _tituloController.text = anotacao.titulo.toUpperCase();
    _descricaoController.text = anotacao.descricao;

    return Scaffold(
      appBar: AppBar(
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
                    //_cadastro(anotacao: anotacao);
                  },
                ),
              ),

              PopupMenuDivider(),

              PopupMenuItem(
                child: ListTile(
                  leading: Icon(Icons.delete),
                  title: Text('Deletar'),
                  onTap: () async {
                    _deleteAlertDialog(anotacao, context);
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
}
