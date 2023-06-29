import 'package:flutter/material.dart';
import 'package:projeto_agenda/contacts_page.dart';
import 'package:provider/provider.dart';
import 'register_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Agenda',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var contacts = <Contact>[];

  void addContact(Contact contact) {
    contacts.add(contact);
    notifyListeners();
  }

  void deleteContact(Contact contact) {
    contacts.remove(contact);
    notifyListeners();
  }

  void addNewAddress(Contact contact, Address address) {
    contact.addresses.add(address);
    notifyListeners();
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    Widget page;
    //define qual página do menu será exibida
    switch (selectedIndex) {
      case 0:
        page = ContactsPage();
        break;
      case 1:
        page = RegisterPage();
        break;
      default:
        throw UnimplementedError('não há página para $selectedIndex');
    }

    //menu
    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
        body: Row(
          children: [
            SafeArea(
              child: NavigationRail(
                extended: constraints.maxWidth >= 600,
                destinations: [
                  NavigationRailDestination(
                    icon: Icon(Icons.group),
                    label: Text('Contatos'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.add_box),
                    label: Text('Cadastro'),
                  ),
                ],
                selectedIndex: selectedIndex,
                onDestinationSelected: (value) {
                  setState(() {
                    selectedIndex = value;
                  });
                },
              ),
            ),
            Expanded(
              child: Container(
                color: Theme.of(context).colorScheme.primaryContainer,
                child: page,
              ),
            ),
          ],
        ),
      );
    });
  }
}

class Address {
  String street;
  String neighborhood;
  String city;
  String state;
  String cep;

  Address({
    required this.street,
    required this.neighborhood,
    required this.city,
    required this.state,
    required this.cep,
  });

  @override
  String toString() {
    return '• $street, $neighborhood, $city, $state, $cep';
  }
}

class Contact {
  String name;
  String phoneNumber;
  String inclusionDate;
  Address initialAddress;
  String email;

  List<Address> addresses;

  Contact({
    required this.name,
    required this.phoneNumber,
    required this.inclusionDate,
    required this.initialAddress,
    required this.email,
  }) : addresses = [initialAddress];
}
