import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:refactor_task/controllers/theme_controller.dart';
import 'package:refactor_task/models/item.dart';
import 'package:refactor_task/services/items.dart';

class TestApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return TestAppPageState();
  }
}

class TestAppPageState extends State<TestApp> {
  List<Item> items = [];
  bool isLoading = true, isListView = true;
  Box? box;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      box = await Hive.openBox('items');
      items = (box!.get('itemKey', defaultValue: []) ?? []).cast<Item>();
      if (items.isEmpty) {
        ItemService().fetchAndStoreItems().then((value) {
          box!.put('itemKey', value);
          items = value;
        });
      }
      isLoading = false;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.put(ThemeController());
    return Scaffold(
      appBar: AppBar(
        title: const Text('Refactor Task App'),
        centerTitle: false,
        actions: [
          Obx(
            () => Switch(
              value: themeController.isDarkMode.value,
              onChanged: (value) => themeController.toggleTheme(),
              activeTrackColor: Colors.blue.withOpacity(0.1),
              activeColor: Colors.blue,
              inactiveThumbColor: Colors.blue,
              thumbIcon: MaterialStateProperty.resolveWith<Icon?>(
                (Set<MaterialState> states) {
                  if (states.contains(MaterialState.selected)) {
                    return const Icon(
                      Icons.brightness_2,
                      color: Colors.grey,
                    );
                  }
                  return const Icon(
                    Icons.sunny,
                    color: Colors.yellow,
                  ); // other states will use default thumbIcon.
                },
              ),
            ),
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  margin: const EdgeInsets.only(right: 30, top: 20, bottom: 20),
                  child: InkWell(
                    onTap: () {
                      isListView = !isListView;
                      setState(() {});
                    },
                    child: isListView
                        ? const Icon(
                            Icons.list,
                            size: 40,
                          )
                        : const Icon(
                            Icons.grid_view,
                            size: 40,
                          ),
                  ),
                ),
                Expanded(
                  child: isListView
                      ? ListView.builder(
                          itemCount: items.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                Get.toNamed('/home');
                              },
                              child: itemListTile(item: items[index]),
                            );
                          },
                        )
                      : GridView.builder(
                          itemCount: items.length,
                          itemBuilder: (context, index) => Container(
                            margin: const EdgeInsets.only(top: 30),
                            child: InkWell(
                              onTap: () {
                                Get.toNamed('/home');
                              },
                              child: itemListTile(item: items[index]),
                            ),
                          ),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 2,
                            mainAxisSpacing: 50,
                          ),
                        ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          isLoading = true;
          await box!.clear();
          items.clear();
          setState(() {});
          ItemService().fetchAndStoreItems().then((value) {
            box!.put('itemKey', value);
            items = value;
            isLoading = false;
            setState(() {});
          });
        },
        tooltip: 'Fetch Data',
        child: const Icon(Icons.refresh),
      ),
    );
  }

  Widget itemListTile({Item? item}) {
    return ListTile(
      title: Text(item?.title ?? ''),
      subtitle: Text(item?.body ?? ''),
    );
  }
}
