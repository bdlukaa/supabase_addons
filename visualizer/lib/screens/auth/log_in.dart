import 'package:flutter/material.dart';
import 'package:supabase/supabase.dart';
import 'package:visualizer/models/session.dart';

const double fieldSize = 500.0;

class LogIn extends StatefulWidget {
  const LogIn({
    Key? key,
    required this.onUpdate,
  }) : super(key: key);

  final VoidCallback onUpdate;

  @override
  _LogInState createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  final urlController = TextEditingController();
  final keyController = TextEditingController();

  @override
  void dispose() {
    urlController.dispose();
    keyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Form(
        child: Builder(
          builder: (context) => Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Text(
                  'Add your Supabase Client',
                  style: Theme.of(context).textTheme.headline4,
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                constraints: BoxConstraints(maxWidth: fieldSize),
                child: TextFormField(
                  controller: urlController,
                  decoration: InputDecoration(labelText: 'Supabase URL'),
                  textInputAction: TextInputAction.next,
                  validator: (text) {
                    if (text == null || text.isEmpty)
                      return 'Please provide a valid URL';
                    final isValid =
                        Uri.tryParse(text)?.host == '' ? false : true;
                    if (!isValid) return 'Please provide a valid URL';
                    return null;
                  },
                ),
              ),
              Container(
                constraints: BoxConstraints(maxWidth: fieldSize),
                child: TextFormField(
                  controller: keyController,
                  decoration: InputDecoration(labelText: 'Supabase Annon Key'),
                  validator: (text) {
                    if (text == null || text.isEmpty)
                      return 'Please provide a valid Annon Key';

                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: ElevatedButton(
                  child: Text('Sign in'),
                  onPressed: () {
                    if (Form.of(context)!.validate()) {
                      client = SupabaseClient(
                        urlController.text,
                        keyController.text,
                      );
                      widget.onUpdate();
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
