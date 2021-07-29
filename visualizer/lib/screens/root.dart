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
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset('assets/supabase_logo.png'),
        ),
        title: Text('Supabase visualizer'),
        actions: [
          if (hasClient) ...[
            // TODO: get Refresh button working
            IconButton(
              icon: Icon(Icons.refresh),
              onPressed: () {},
              tooltip: 'Refresh',
              splashRadius: 20.0,
            ),
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
        ],
      ),
      body:
          !hasClient ? LogIn(onUpdate: () => setState(() {})) : LoggedClient(),
    );
  }
}
