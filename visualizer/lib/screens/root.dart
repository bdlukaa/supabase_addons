import 'package:flutter/material.dart';
import 'package:visualizer/models/session.dart';

import 'auth/log_in.dart';
import 'client/root.dart';

class Root extends StatefulWidget {
  const Root({Key? key}) : super(key: key);

  @override
  _RootState createState() => _RootState();
}

class _RootState extends State<Root> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Image.network(
            'https://github.com/supabase/supabase/blob/3c347ee5462ae589bde64e5f5d9780f69fdd1fe6/www/public/favicon/favicon-32x32.png?raw=true'),
        title: Text('Supabase visualizer'),
        actions: [
          if (hasClient)
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.symmetric(horizontal: 10.0),
              child: ElevatedButton(
                child: Text('Sign out'),
                onPressed: () {
                  setState(() => client = null);
                },
              ),
            ),
        ],
      ),
      body:
          !hasClient ? LogIn(onUpdate: () => setState(() {})) : LoggedClient(),
    );
  }
}
