import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'add_new_address.dart';
import 'main.dart';

class ContactsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var contacts = appState.contacts;

    return Scaffold(
      appBar: AppBar(
        title: Text('Contatos'),
      ),
      body: ListView(children: [
        for (var contact in contacts)
          ListTile(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DetailsPage(contact: contact)));
            },
            title: Text(contact.name),
          ),
      ]),
    );
  }
}

class DetailsPage extends StatefulWidget {
  final Contact contact;
  DetailsPage({required this.contact});

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    Contact contact = widget.contact;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.contact.name),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: ListView(
          children: [
            ListTile(
              title: Text('Telefone'),
              subtitle: Text(widget.contact.phoneNumber),
            ),
            ListTile(
              title: Text('E-mail'),
              subtitle: Text(widget.contact.email),
            ),
            ListTile(
              title: Text('Endereços'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: widget.contact.addresses.map((address) {
                  return Text(address.toString());
                }).toList(),
              ),
            ),
            ListTile(
              title: Text('Data de inclusão'),
              subtitle: Text(widget.contact.inclusionDate.toString()),
            ),
            Row(
              children: [
                ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  AddNewAddressPage(contact: contact)));
                    },
                    child: Text("Adicionar endereço")),
                SizedBox(width: 15.0),
                ElevatedButton(
                    onPressed: () {
                      appState.deleteContact(widget.contact);
                      Navigator.pop(context);
                    },
                    child: Text("Deletar contato"))
              ],
            )
          ],
        ),
      ),
    );
  }
}
