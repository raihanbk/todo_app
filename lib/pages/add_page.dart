import 'package:flutter/material.dart';
import 'package:todo_withapi/main.dart';
import 'package:todo_withapi/services/todo_service.dart';
import 'package:todo_withapi/values/colors.dart';
import 'package:todo_withapi/utils/snackbar.dart';

class AddPage extends StatefulWidget {
  final Map? todo;

  const AddPage({super.key, this.todo});

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  bool isEdit = false;

  @override
  void initState() {
    super.initState();
    final todo = widget.todo;
    if (todo != null) {
      isEdit = true;
      final title = todo['title'];
      final description = todo['description'];
      titleController.text = title;
      descriptionController.text = description;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyApp.themeNotifier.value == ThemeMode.light
            ? AppColors.amber
            : AppColors.deepPurple,
        centerTitle: true,
        title: Text(
          isEdit ? 'Edit Todo' : 'Add Todo',
          style:
              const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.white,
            )),
      ),
      body: ListView(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 30),
        children: [
          TextField(
            controller: titleController,
            decoration: InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10))),
          ),
          const SizedBox(
            height: 20,
          ),
          TextField(
            controller: descriptionController,
            minLines: 2,
            maxLines: 5,
            keyboardType: TextInputType.multiline,
            decoration: InputDecoration(
                hintText: 'description',
                hintStyle: const TextStyle(fontWeight: FontWeight.normal),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10))),
          ),
          const SizedBox(
            height: 20,
          ),
          Container(
            height: 55,
            decoration: BoxDecoration(
                color: MyApp.themeNotifier.value == ThemeMode.light
                    ? AppColors.amber
                    : AppColors.deepPurple,
                borderRadius: BorderRadius.circular(20)),
            child: TextButton(
                onPressed: () {
                  isEdit ? updateData() : submitData();
                },
                child: Text(
                  isEdit ? 'Update' : 'Submit',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 16),
                )),
          ),
        ],
      ),
    );
  }

  Future<void> submitData() async {
    //submit data to server
    final isSuccess = await TodoService.addTodo(body);
    //show success or fail message
    if (isSuccess) {
      titleController.text = '';
      descriptionController.text = '';
      if (!mounted) return;
      Navigator.pop(context);
      if (!mounted) return;
      showSuccessMessage(context, msg: 'Creation Success...');
    } else {
      if (!mounted) return;
      showFailureMessage(context, msg: 'Creation Failure...');
    }
  }

  Future<void> updateData() async {
    final todo = widget.todo;
    if (todo == null) {
      print('Cannot call updated without todo data');
      return;
    }
    final id = todo['_id'];

    final isSuccess = await TodoService.updateData(id, body);
    if (isSuccess) {
      if (!mounted) return;
      showSuccessMessage(context, msg: 'Updated Successfully');
      Navigator.pop(context);
    } else {
      if (!mounted) return;
      showFailureMessage(context, msg: 'Update Failed');
    }
  }

  Map get body {
    //Get data from form
    final title = titleController.text;
    final description = descriptionController.text;
    return {"title": title, "description": description, "is_completed": false};
  }
}
