import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';

import '../providers/storage.dart';

class RecordItem extends StatefulWidget {
  final String title;
  String dateTime;

  RecordItem({
    @required this.title,
    @required this.dateTime,
  });

  @override
  _RecordItemState createState() => _RecordItemState();
}

class _RecordItemState extends State<RecordItem> {
  void _updateRecord() async {
    final newTime = await Provider.of<Storage>(context, listen: false)
        .updateRecord(widget.title);
    setState(() {
      widget.dateTime = newTime;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      shadowColor: Colors.greenAccent,
      elevation: 20,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            ListTile(
              contentPadding:
                  const EdgeInsets.only(top: 4, left: 10, right: 10),
              title: Text(
                '${widget.title}:',
                softWrap: true,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              trailing: Text(
                '${widget.dateTime}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 12),
                  child: ElevatedButton(
                    child: const Icon(Icons.delete),
                    style: ElevatedButton.styleFrom(
                      elevation: 8,
                      primary: Theme.of(context).accentColor,
                    ),
                    onPressed: () async {
                      await Provider.of<Storage>(context, listen: false)
                          .deleteRecord(widget.title);
                      Toast.show('Record Deleted!', context, duration: 2);
                    },
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(right: 12),
                  child: ElevatedButton(
                    child: const Text(
                      'Reset',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      elevation: 8,
                      primary: Theme.of(context).accentColor,
                    ),
                    onPressed: _updateRecord,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
