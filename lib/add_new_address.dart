import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'main.dart';

class AddNewAddressPage extends StatefulWidget {
  final Contact contact;
  AddNewAddressPage({required this.contact});

  @override
  State<AddNewAddressPage> createState() => _AddNewAddressPageState();
}

class _AddNewAddressPageState extends State<AddNewAddressPage> {
  final TextEditingController _streetController = TextEditingController();
  final TextEditingController _neighborhoodController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _cepController = TextEditingController();

  final FocusNode _cepFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _cepFocusNode.addListener(() {
      if (!_cepFocusNode.hasFocus) {
        _fetchAddressFromAPI();
      }
    });
  }

  @override
  void dispose() {
    _cepFocusNode.dispose();
    super.dispose();
  }

  Future<void> _fetchAddressFromAPI() async {
    final cep = _cepController.text;
    final url = Uri.parse('https://viacep.com.br/ws/$cep/json/');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      final String street = data['logradouro'];
      final String neighborhood = data['bairro'];
      final String city = data['localidade'];
      final String state = data['uf'];

      _streetController.text = street;
      _neighborhoodController.text = neighborhood;
      _cityController.text = city;
      _stateController.text = state;
    } else {
      print('Erro ao obter o endereço.');
    }
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    return Scaffold(
      appBar: AppBar(title: Text("Adicionar endereço")),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: <Widget>[
          Form(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                controller: _cepController,
                decoration: InputDecoration(labelText: 'Cep'),
                focusNode: _cepFocusNode,
              ),
              TextFormField(
                controller: _streetController,
                decoration: InputDecoration(labelText: 'Rua'),
              ),
              TextFormField(
                controller: _neighborhoodController,
                decoration: InputDecoration(labelText: 'Bairro'),
              ),
              TextFormField(
                controller: _cityController,
                decoration: InputDecoration(labelText: 'Cidade'),
              ),
              TextFormField(
                controller: _stateController,
                decoration: InputDecoration(labelText: 'Estado'),
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  Address address = Address(
                      street: _streetController.text,
                      neighborhood: _neighborhoodController.text,
                      city: _cityController.text,
                      state: _stateController.text,
                      cep: _cepController.text);
                  appState.addNewAddress(widget.contact, address);
                  Navigator.pop(context);
                },
                child: Text('Adicionar'),
              ),
            ],
          ))
        ],
      ),
    );
  }
}
