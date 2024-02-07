import 'package:flutter/material.dart';
import 'package:todo_withapi/pages/add_page.dart';
import 'package:todo_withapi/services/todo_service.dart';
import 'package:todo_withapi/values/colors.dart';
import 'package:todo_withapi/utils/snackbar.dart';
import 'package:todo_withapi/widget/todo_card.dart';

import '../main.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoading = true;
  List items = [];

  @override
  void initState() {
    super.initState();
    fetchTodo();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: MyApp.themeNotifier,
      builder: (_, ThemeMode currentMode, __) {
         return Scaffold(
          appBar: AppBar(
            backgroundColor: currentMode == ThemeMode.light
                ? AppColors.amber
                : AppColors.deepPurple,
            centerTitle: true,
            title: const Text(
              'To-Do List',
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.white),
            ),
            actions: [
              ValueListenableBuilder(
                  valueListenable: MyApp.themeNotifier,
                  builder: (_, ThemeMode currentMode, __) {
                    return IconButton(
                      icon: Icon(
                        currentMode == ThemeMode.light ? Icons
                            .dark_mode_outlined
                            : Icons.light_mode_outlined,
                        color: Colors.white,
                      ),
                      onPressed: MyApp.toggleTheme,
                    );
                  }
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton.extended(
            backgroundColor: currentMode == ThemeMode.light
                ? AppColors.amber
                : AppColors.deepPurple,
            onPressed: navigationToAddPage,
            label: const Text(
              'Add Todo',
              style: TextStyle(color: Colors.white),
            ),
          ),
          body: Visibility(
            visible: isLoading,
            replacement: RefreshIndicator(
              onRefresh: fetchTodo,
              child: Visibility(
                visible: items.isNotEmpty,
                replacement: const Center(
                  child: Text('No Todo Item Found'),
                ),
                child: ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final reversedIndex = items.length - 1 - index;
                    final item = items[reversedIndex];
                    return TodoCard(
                        index: index,
                        item: item,
                        navigateEdit: navigationToEditPage,
                        deleteById: deleteById
                    );
                  },
                ),
              ),
            ),
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          ),
        );
      }
    );
  }

  Future<void> navigationToAddPage() async {
    final route = MaterialPageRoute(builder: (context) => const AddPage());
    await Navigator.push(context, route);
    setState(() {
      isLoading = true;
    });
    fetchTodo();
  }

  Future<void> navigationToEditPage(Map item) async {
    final route = MaterialPageRoute(builder: (context) => AddPage(todo: item));
    await Navigator.push(context, route);
    setState(() {
      isLoading = true;
    });
    fetchTodo();
  }

  Future<void> deleteById(String id) async {
    final isSuccess = await TodoService.deleteById(id);
    if (isSuccess) {
      final filteredItem =
          items.where((element) => element['_id'] != id).toList();
      setState(() {
        items = filteredItem;
      });
    } else {
      if (!mounted) return;
      showFailureMessage(context, msg: 'Deletion Failed');
    }
  }

  Future<void> fetchTodo() async {
    final response = await TodoService.fetchTodo();

    if (response != null) {
      setState(() {
        items = response;
      });
    } else {
      if (!mounted) return;
      showFailureMessage(context, msg: 'Something went wrong');
    }
    setState(() {
      isLoading = false;
    });
  }
}
