import 'package:contact_list/pages/contact_list_page.dart';
import 'package:contact_list/widgets/form_contact.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: const Text('Contact List')),
        floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.deepPurple,
            child: _tabController.index == 0
                ? const FaIcon(FontAwesomeIcons.plus)
                : const FaIcon(
                    FontAwesomeIcons.floppyDisk,
                  ),
            onPressed: () => _tabController.index == 0
                ? showDialog(
                    context: context,
                    builder: (_) => const AlertDialog(content: ContactForm()))
                : print('Pag das configs')),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
          child: TabBarView(
            controller: _tabController,
            children: const [
              ContactListPage(),
              Center(
                child: Text('CONFIGS'),
              )
            ],
          ),
        ),
        bottomNavigationBar: ConvexAppBar(
          style: TabStyle.react,
          backgroundColor: Colors.deepPurple,
          items: const [
            TabItem(icon: Icons.list),
            TabItem(icon: Icons.settings),
          ],
          initialActiveIndex: 0,
          onTap: (int i) {
            setState(() {
              if (i == 0) {
                _tabController.index = i;
              } else {
                showDialog(
                    context: context,
                    builder: (_) => const AlertDialog(
                          content: Text(
                              "Página ainda não implementada! Perdão pelo transtorno."),
                        ));
              }
            });
          },
          controller: _tabController,
        ),
      ),
    );
  }
}
