import 'package:flutter/material.dart';


class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();

  List<String> searchResults = [];
  List<String> searchLabs = [
    'Amri Hospital','AIMS Hospital', 'Swastik Patholabs','Marigala Hospital', 'Paisa Na dele Pala Hospital'
  ];
  bool isTapped = false;
  int count = 0;

  void _onSearchTextChanged(String text) {
    setState(() {
      searchResults = List.generate(10, (index) => 'Result $index for "$text"');
    });
  }

  void _toggleContainer() {
    setState(() {
      count++;
      if(count == 1) {
        isTapped = !isTapped;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          titleSpacing: 0,
          leading: IconButton(
            onPressed: () {},
            icon: const Icon(Icons.view_agenda_outlined, color: Colors.black),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 280,
                child: TextField(
                  controller: _searchController,
                  onTap: _toggleContainer,
                  onChanged: _onSearchTextChanged,
                  decoration: const InputDecoration(
                    hintText: 'Search...',
                    border: InputBorder.none,
                    icon:Icon(Icons.search, color: Colors.black, size: 20,),
                  ),
                ),
              ),
              IconButton(onPressed: (){
                setState(() {
                  _searchController.clear();
                });
              },
                  icon: const Icon(Icons.cancel_outlined, color: Colors.grey,)
              )
            ],
          ),
          backgroundColor: Colors.white,
        ),
        body: Stack(
          children: [
            SizedBox(
              height: screenHeight,
              child: SingleChildScrollView(
                child: Container(
                  height: screenHeight * 0.6,
                  color: Colors.grey[300],
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 80, right: 8, left: 8),
                    child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: searchResults.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          trailing: IconButton(
                            onPressed: (){
                            },
                            icon: const Icon(Icons.keyboard_arrow_up_outlined),
                          ),
                          title: Text(searchResults[index]),
                          onTap: () {},
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
                bottom: 0,
                child: Container(
                  decoration: isTapped ? BoxDecoration(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
                    border: Border.all(
                        style: BorderStyle.solid,
                        color: Colors.black,
                        width: 4),
                    color: Colors.cyanAccent[100],
                  ) : BoxDecoration(
                    color: Colors.cyanAccent[100],
                  ),
                  height: isTapped ? screenHeight * 0.4 : screenHeight * 0.9,
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20.0, left: 8, right: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Suggested Labs Near You: ",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.black,
                          ),
                        ),
                        const Divider(thickness: 2),
                        SizedBox(
                          height: isTapped ? screenHeight * 0.31 : screenHeight * 0.8,
                          width: MediaQuery.of(context).size.width,
                          child: ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            itemCount: searchLabs.length,
                            itemBuilder: (context, index) {
                              return Card(
                                elevation: 5,
                                color: Colors.cyanAccent[200],
                                child: Column(
                                  children: [
                                    ListTile(
                                      leading: SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: Image.asset("Place your Image"),
                                      ),
                                      title: Text(searchLabs[index], style: const TextStyle(fontSize: 18)),
                                      subtitle: const SizedBox(
                                        width: 250,
                                        child: Text(
                                          "hghghgj hgjhghghj hjgjhgjgjh gjhgj jgjhgffuuyg gg hghghgj hgjhghghj hjgjhgjgjh gjhgj jgjhgffuuyg gg",
                                          overflow: TextOverflow.clip,
                                          style: TextStyle(color: Colors.black87),
                                        ),
                                      ),
                                      onTap: () {},
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                )

            ),
          ],
        ),
      );
  }


  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

