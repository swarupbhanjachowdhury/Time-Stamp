import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../providers/storage.dart';

import '../widgets/recorditem.dart';

class HomeScreen extends StatelessWidget {
  final form = GlobalKey<FormState>();

  void onSubmit() {
    if (!form.currentState.validate()) return;
    form.currentState.save();
  }

  void addItems(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (ctx) => Dialog(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Form(
                key: form,
                child: TextFormField(
                  decoration: const InputDecoration(labelText: 'Title'),
                  autofocus: true,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z0-9]')),
                  ],
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Enter a title';
                    }
                    return null;
                  },
                  onFieldSubmitted: (value) => onSubmit(),
                  onSaved: (value) async {
                    print(value.length);
                    await Provider.of<Storage>(ctx, listen: false)
                        .addRecords(value);
                    Navigator.of(ctx).pop();
                  },
                ),
              ),
              const SizedBox(height: 4),
              TextButton(
                child: const Text('Add'),
                onPressed: () => onSubmit(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 20,
        title: const Text('Times'),
      ),
      body: Stack(children: [
        Container(color: Colors.red.shade50),
        RecordWid(),
      ]),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterFloat,
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => addItems(context),
      ),
    );
  }
}

class RecordWid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<Storage>(builder: (ctx, storage, ch) {
      return FutureBuilder(
        future: storage.getRecords(),
        builder: (ctx, snapshot) {
          final data = snapshot.data as Map<String, dynamic>;
          return (data == null || data.isEmpty)
              ? Center(child: const Text('No records! Try adding them.'))
              : ListView(
                  children: data.keys
                      .map((key) => RecordItem(
                            title: key,
                            dateTime: data[key],
                          ))
                      .toList(),
                );
        },
      );
    });
  }
}
