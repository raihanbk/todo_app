import 'package:flutter/material.dart';
import 'package:todo_withapi/main.dart';
import 'package:todo_withapi/values/colors.dart';

class TodoCard extends StatefulWidget {
  final int index;
  final Map item;
  final Function(Map) navigateEdit;
  final Function(String) deleteById;

  const TodoCard({
    super.key,
    required this.index,
    required this.item,
    required this.navigateEdit,
    required this.deleteById,
  });

  @override
  State<TodoCard> createState() => _TodoCardState();
}

class _TodoCardState extends State<TodoCard> {

  bool isExpanded =false;

  @override
  Widget build(BuildContext context) {
    final id = widget.item['_id'] as String;
    return Card(
      margin: const EdgeInsets.all(6),
      child: GestureDetector(
        onTap: () {
          setState(() {
            isExpanded = !isExpanded;
          });
        },
        child: ListTile(
          splashColor: Colors.transparent,
          leading: CircleAvatar(
            backgroundColor: Colors.white70,
            child: Text(
              '${widget.index + 1}',
              style: const TextStyle(color: Colors.black),
            ),
          ),
          trailing: PopupMenuButton(onSelected: (value) {
            if (value == 'edit') {
              //open edit page
              widget.navigateEdit(widget.item);
            } else if (value == 'delete') {
              //delete and remove item
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Confirm Delete'),
                    content: const Text('Are you sure you want to delete this item?'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          widget.deleteById(id);
                          Navigator.of(context).pop();
                        },
                        child: const Text('Delete'),
                      ),
                    ],
                  );
                },
              );
            }
          }, itemBuilder: (context) {
            return [
              const PopupMenuItem(
                value: 'edit',
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [Icon(Icons.edit, color: Colors.blue), Text('Edit')],
                ),
              ),
              const PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Icon(
                        Icons.delete_forever,
                        color: Colors.red,
                      ),
                      Text('Delete')
                    ],
                  )),
            ];
          }),
          title: Text(
            widget.item['title'],
            style: TextStyle(
                color: MyApp.themeNotifier.value == ThemeMode.light
                    ? AppColors.black
                    : AppColors.white),
          ),
          subtitle: isExpanded ? Text(widget.item['description'],
            style: TextStyle(
              color: MyApp.themeNotifier.value == ThemeMode.light
                  ? AppColors.black
                  : AppColors.white),) : null
        ),
      ),
    );
  }
}
