import 'package:flutter/material.dart';
import 'package:youtube/Categories_page.dart';
import 'package:youtube/categories_model.dart';
import 'package:youtube/profile_page.dart';
import 'package:provider/provider.dart';
import 'trending_page.dart';
import 'channel_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController _controller = TextEditingController();
  FocusNode node = FocusNode(canRequestFocus: true);
  String search = "";
  int _currentindex = 0;

  final List<Widget> pages = [
    CategoriesPage(),
    TrendingPage(),
    ChannelPage(),
    ProfilePage()
  ];

  void changePage(int index) {
    setState(() {
      _currentindex = index;
    });
    if (index == 1) {
      Provider.of<CategoriesList>(context).getTrendingVideos();
      _isSearching = false;
    } else if (index == 0) {
      _isSearching = false;
      if (search != "")
        Provider.of<CategoriesList>(context).getVideos(search);
      else
        Provider.of<CategoriesList>(context).getTrendingVideos();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    node.dispose();
    super.dispose();
  }

  var _isSearching = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _currentindex == 3
          ? PreferredSize(
              preferredSize: Size.fromHeight(70),
              child: AppBar(
                backgroundColor: Colors.blueGrey,
                title: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 30,
                    ),
                    Center(
                        child: Text(
                      "Name",
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    )),
                  ],
                ),
                actions: <Widget>[
                  Icon(
                    Icons.settings,
                    size: 40,
                  )
                ],
              ),
            )
          : AppBar(
              backgroundColor: Colors.blueGrey,
              title: Container(
                child: _isSearching == false
                    ? Text(
                        "YouTube",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 15),
                      )
                    : TextField(
                        controller: _controller,
                        focusNode: node,
                        onTap: () {
                          setState(() {
                            _isSearching = true;
                          });
                        },
                        onChanged: (value) {
                          setState(() {
                            search = value;
                          });
                        },
                        onSubmitted: (value) {
                          setState(() {
                            _isSearching = false;
                          });
                          if (value != "")
                            Provider.of<CategoriesList>(context)
                                .getVideos(search);
                        },
                        decoration: InputDecoration(
                            enabled: true,
                            hintText: "Search",
                            disabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                              color: Colors.white,
                              width: 3.5,
                            )),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                              color: Colors.white,
                              width: 3.5,
                            )),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                              color: Colors.white,
                              width: 3.5,
                            )),
                            border: OutlineInputBorder(
                                borderSide: BorderSide(
                              color: Colors.white,
                              width: 3.5,
                            )),
                            hintStyle: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                      ),
              ),
              leading: _isSearching
                  ? null
                  : Container(
                      color: Colors.green,
                      child: Image.network(
                        "https://upload.wikimedia.org/wikipedia/commons/a/ac/Logo_youtube_ios_%28cropped%29.jpg",
                        fit: BoxFit.none,
                        filterQuality: FilterQuality.low,
                        cacheHeight: 80,
                        cacheWidth: 80,
                      ),
                    ),
              actions: <Widget>[
                _isSearching == false
                    ? FlatButton(
                        child: Icon(Icons.search),
                        onPressed: () async {
                          setState(() {
                            _isSearching = true;
                          });
                          await Future.delayed(Duration(milliseconds: 50));
                          FocusScope.of(context).requestFocus(node);
                        },
                      )
                    : SizedBox(
                        width: 20,
                      ),
                SizedBox(width: 20),
                _isSearching
                    ? FlatButton(
                        child: Icon(Icons.search),
                        onPressed: () async {
                          //print("ok");
                          FocusScope.of(context).unfocus();
                          setState(() {
                            _isSearching = false;
                          });
                          await Provider.of<CategoriesList>(context)
                              .getVideos(search);
                        },
                      )
                    : GestureDetector(
                        onTap: () => changePage(3),
                        child: CircleAvatar(
                            radius: 25,
                            backgroundColor: Colors.black,
                            child: Image.network(
                              "https://upload.wikimedia.org/wikipedia/en/thumb/b/ba/Hitman_4_artwork.jpg/220px-Hitman_4_artwork.jpg",
                              fit: BoxFit.fill,
                              cacheHeight: 30,
                              cacheWidth: 30,
                            )),
                      )
              ],
            ),
      bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.green,
          unselectedItemColor: Colors.white,
          selectedItemColor: Colors.black,
          currentIndex: _currentindex,
          onTap: changePage,
          items: [
            BottomNavigationBarItem(
                backgroundColor: Colors.blueGrey,
                title: Text(""),
                icon: Icon(Icons.home)),
            BottomNavigationBarItem(
                backgroundColor: Colors.blueGrey,
                title: Text(""),
                icon: Icon(Icons.trending_up)),
            BottomNavigationBarItem(
                backgroundColor: Colors.blueGrey,
                title: Text(""),
                icon: Icon(Icons.live_tv)),
            BottomNavigationBarItem(
                backgroundColor: Colors.blueGrey,
                title: Text(""),
                icon: Icon(Icons.account_circle)),
          ]),
      body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: pages[_currentindex]),
    );
  }
}
