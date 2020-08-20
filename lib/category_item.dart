import 'package:flutter/material.dart';

import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class CategoryItem extends StatefulWidget {
  final data;
  final i;
  CategoryItem(this.data, this.i);
  @override
  _CategoryItemState createState() => _CategoryItemState();
}

class _CategoryItemState extends State<CategoryItem> {
  String _url;

  YoutubePlayerController _controller;
//https://www.youtube.com/watch?v=OLcisxAV4gc
  var _isExpanded = false;
  var _isPlay = false;

  @override
  void initState() {
    _controller = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(
          "https://www.youtube.com/watch?v=" +
              widget.data.items[widget.i].videoId
          //"https://www.youtube.com/watch?v=OLcisxAV4gc"),
          ),
      flags: YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
        loop: true,
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.only(left: 20, right: 20),
      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(width: 1),
              right: BorderSide(width: 1),
              left: BorderSide(width: 1),
              top: BorderSide(width: 1)),
          borderRadius: BorderRadius.circular(20)),
      height: _isExpanded ? 460 : 328,
      width: 300,
      child: Column(
        children: <Widget>[
          SizedBox(height: 20),
          Card(
            elevation: 20,
            child: Container(
                height: 200,
                width: 330,
                alignment: Alignment.centerLeft,
                child: _isPlay
                    ? YoutubePlayer(
                        controller: _controller,
                        showVideoProgressIndicator: true,
                        aspectRatio: 33 / 20,
                      )
                    : GestureDetector(
                        onTap: () {
                          setState(() {
                            _isPlay = true;
                          });
                        },
                        child: Image.network(
                          widget.data.items[widget.i].imageUrl,
                          fit: BoxFit.fill,
                          filterQuality: FilterQuality.low,
                          height: 200,
                          width: 330,
                        ),
                      )),
          ),
          SizedBox(height: 15),
          Container(
            height: _isExpanded ? 210 : 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: _isExpanded ? 210 : 50,
                  width: 280,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        height: _isExpanded ? 100 : 25,
                        child: Text(
                          widget.data.items[widget.i].title,
                          overflow: TextOverflow.fade,
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                      ),
                      _isExpanded
                          ? Container(
                              height: _isExpanded ? 100 : 50,
                              child: Text(
                                "Description - " +
                                    widget.data.items[widget.i].description,
                                overflow: TextOverflow.fade,
                                style: TextStyle(fontSize: 12),
                              ),
                            )
                          : Container(),
                    ],
                  ),
                ),
                IconButton(
                    onPressed: () {
                      setState(() {
                        _isExpanded = !_isExpanded;
                      });
                    },
                    icon: Icon(
                        _isExpanded ? Icons.expand_less : Icons.expand_more)),
              ],
            ),
          )
        ],
      ),
    );
  }
}
