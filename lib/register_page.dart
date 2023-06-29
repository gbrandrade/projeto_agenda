import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'main.dart';

class RegisterPage extends StatefulWidget {
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _streetController = TextEditingController();
  final TextEditingController _neighborhoodController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _cepController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  String _inclusionDate = '';

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

  void clearControllers() {
    _nameController.clear();
    _phoneNumberController.clear();
    _emailController.clear();
    _cepController.clear();
    _streetController.clear();
    _neighborhoodController.clear();
    _cityController.clear();
    _stateController.clear();
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastro'),
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: <Widget>[
          Form(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: 'Nome'),
                ),
                TextFormField(
                  controller: _phoneNumberController,
                  decoration: InputDecoration(labelText: 'Número de Telefone'),
                ),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(labelText: 'E-mail'),
                ),
                TextFormField(
                  controller: _cepController,
                  decoration: InputDecoration(labelText: 'CEP'),
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

                    setState(() {
                      DateTime now = DateTime.now();
                      DateFormat formatter = DateFormat('dd/MM/yyyy HH:mm');
                      _inclusionDate = formatter.format(now);
                    });

                    Contact contact = Contact(
                        name: _nameController.text,
                        phoneNumber: _phoneNumberController.text,
                        inclusionDate: _inclusionDate,
                        initialAddress: address,
                        email: _emailController.text);

                    appState.addContact(contact);
                    clearControllers();
                  },
                  child: Text('Cadastrar'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
