import 'package:flutter/material.dart';
import 'package:ham_lookup/models/fcc_database.dart';

class AppBarGenerator extends StatefulWidget {
  final Widget child;
  const AppBarGenerator({super.key, required this.child});

  @override
  State<AppBarGenerator> createState() => AppBarGeneratorState();
  static AppBarGeneratorState of(BuildContext context) {
    final _AppBarGeneratorInherited? result =
        context.dependOnInheritedWidgetOfExactType<_AppBarGeneratorInherited>();
    assert(result != null, 'No _AppBarGeneratorInherited found in context');
    return result!.data;
  }
}

class AppBarGeneratorState extends State<AppBarGenerator> {
  @override
  Widget build(BuildContext context) {
    return _AppBarGeneratorInherited(data: this, child: widget.child);
  }

  AppBar generateAppBar(
      {required String title,
 }) {

    return AppBar(
      title: Text(title),
    );
  }

  Drawer generateDrawer() {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            child: Text('Drawer Header'),
          ),
          ListTile(
            title: Text('Item 1'),
            onTap: () {},
          ),
          ListTile(
            title: Text('Item 2'),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

class _AppBarGeneratorInherited extends InheritedWidget {
  final AppBarGeneratorState data;
  const _AppBarGeneratorInherited({
    // ignore: unused_element
    super.key,
    required this.data,
    required Widget child,
  }) : super(child: child);

  @override
  bool updateShouldNotify(_AppBarGeneratorInherited old) {
    return true;
  }
}
