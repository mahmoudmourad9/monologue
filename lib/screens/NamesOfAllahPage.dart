import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';

class NamesOfAllahPage extends StatefulWidget {
  @override
  _NamesOfAllahPageState createState() => _NamesOfAllahPageState();
}

class _NamesOfAllahPageState extends State<NamesOfAllahPage> {
  List<Map<String, String>> names = [];
  List<Map<String, String>> filteredNames = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadNames();
  }

  Future<void> _loadNames() async {
    try {
      final String response =
          await rootBundle.loadString('assets/namesofallah.json');
      final List<dynamic> data = json.decode(response);
      setState(() {
        names = data.map((item) => Map<String, String>.from(item)).toList();
        filteredNames = names;
      });
    } catch (e) {
      print("خطأ في تحميل الأسماء: $e");
    }
  }

  void _searchNames(String query) {
    if (names.isEmpty) return;
    final suggestions = names.where((name) {
      final nameLower = name['name']?.toLowerCase() ?? '';
      final searchLower = query.toLowerCase();
      return nameLower.contains(searchLower);
    }).toList();

    setState(() {
      filteredNames = suggestions;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality( // ✅ يجعل الصفحة كلها RTL
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            'أسماء الله الحسنى',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Color(0xff00a2b5),
          elevation: 0,
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: searchController,
                decoration: const InputDecoration(
                  hintText: 'ابحث عن اسم...',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.search),
                ),
                onChanged: _searchNames,
              ),
            ),
            Expanded(
              child: names.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : filteredNames.isEmpty && searchController.text.isNotEmpty
                      ? const Center(child: Text("لا توجد نتائج بحث مطابقة"))
                      : Directionality(
                          textDirection: TextDirection.rtl, //  لضمان أن الجريد RTL
                          child: GridView.builder(
                            padding: const EdgeInsets.all(8),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                            ),
                            itemCount: filteredNames.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Center(
                                          child: Text(
                                            filteredNames[index]['name']!,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xff00a2b5),
                                            ),
                                          ),
                                        ),
                                        content: SingleChildScrollView(
                                          child: Text(
                                            filteredNames[index]['meaning']!,
                                            style:
                                                const TextStyle(fontSize: 18),
                                            textDirection: TextDirection.rtl,
                                          ),
                                        ),
                                        actions: [
                                          TextButton(
                                            child: const Center(
                                              child: Text(
                                                'إغلاق',
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  color: Color(0xffF8672F),
                                                ),
                                              ),
                                            ),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                child: Card(
                                  color: Colors.teal[50],
                                  elevation: 3,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        filteredNames[index]['name']!,
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: "Anton-Regular",
                                          color: Colors.teal[900],
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomSearchDelegate extends SearchDelegate<String?> {
  final List<Map<String, String>> names;
  final Function(String) searchCallback;

  CustomSearchDelegate(this.names, this.searchCallback);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
          searchCallback(query);
          showSuggestions(context);
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        searchCallback('');
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    searchCallback(query);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      close(context, query);
    });
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return ListView.builder(
        itemCount: names.length > 10 ? 10 : names.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(names[index]['name']!),
            onTap: () {
              query = names[index]['name']!;
              searchCallback(query);
              showResults(context);
            },
          );
        },
      );
    }

    final suggestions = names.where((name) {
      final nameLower = name['name']?.toLowerCase() ?? '';
      final searchLower = query.toLowerCase();
      return nameLower.contains(searchLower);
    }).toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(suggestions[index]['name']!),
          onTap: () {
            query = suggestions[index]['name']!;
            searchCallback(query);
            showResults(context);
          },
        );
      },
    );
  }
}
