import 'package:flutter/material.dart';

import '../../utils.dart';

class Documentation extends StatelessWidget {
  const Documentation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: kBackButton,
        title: Text('Supabase Addons Documentation'),
      ),
    );
  }
}
