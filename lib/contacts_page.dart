import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:permission_handler/permission_handler.dart';

class ContactsPage extends StatefulWidget {
  const ContactsPage({super.key});

  @override
  _ContactsPageState createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  List<Contact> contacts = [];
  List<Contact> filteredContacts = [];

  @override
  void initState() {
    super.initState();
    requestPermissionAndFetchContacts();
  }

  Future<void> requestPermissionAndFetchContacts() async {
    if (await Permission.contacts.request().isGranted) {
      fetchContacts();
    }
  }

  Future<void> fetchContacts() async {
    final Iterable<Contact> contactsList = await ContactsService.getContacts();
    setState(() {
      contacts = contactsList.toList();
      filteredContacts = contacts;
    });
  }

  void filterContacts(String query) {
    final List<Contact> filtered = contacts
        .where((contact) =>
            contact.displayName!.toLowerCase().contains(query.toLowerCase()))
        .toList();
    setState(() {
      filteredContacts = filtered;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contacts'),
      ),
      body: Container(
        color: Colors.green[50],
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                onChanged: (query) => filterContacts(query),
                decoration: InputDecoration(
                  labelText: 'Search',
                  labelStyle: const TextStyle(color: Colors.green),
                  prefixIcon: const Icon(Icons.search, color: Colors.green),
                  filled: true,
                  fillColor: Colors.green[100],
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: const BorderSide(color: Colors.green),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide:
                        const BorderSide(color: Colors.greenAccent, width: 2.0),
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: filteredContacts.length,
                itemBuilder: (context, index) {
                  final contact = filteredContacts[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.green,
                      child: Text(
                        contact.displayName![0],
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    title: Text(contact.displayName ?? ''),
                    subtitle: Text(
                      contact.phones!.isNotEmpty
                          ? contact.phones!.first.value!
                          : 'No phone number',
                      style: const TextStyle(color: Colors.grey),
                    ),
                    trailing: const Icon(Icons.phone, color: Colors.green),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
