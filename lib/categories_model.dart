import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

//https://www.googleapis.com/youtube/v3/videos?part=snippet&type=video&key=AIzaSyBxu_y7IgKTzyR5FSD9rKHxNEoFoYtOAbk&chart=mostPopular&regionCode=US
//https://www.googleapis.com/youtube/v3/videos?part=snippet&type=video&key=AIzaSyBxu_y7IgKTzyR5FSD9rKHxNEoFoYtOAbk&chart=mostPopular&regionCode=US&pageToken=CAUQAA
class Categories {
  final String title;
  final String videoId;
  final String description;
  final String imageUrl;

  Categories({this.title, this.videoId, this.description, this.imageUrl});
}

class CategoriesList with ChangeNotifier {
  var isLoading = false;
  var nextPageToken = "";
  var isSearch = false;
  var previousSearch = "";
  List<Categories> _items = [];
  List<Categories> get items {
    return [..._items];
  }

  Future<void> getVideos(String search) async {
    isLoading = true;
    isSearch = true;
    print("enterred");
    var data;
    previousSearch = search;
    final url =
        "https://www.googleapis.com/youtube/v3/search?part=snippet&type=video&key=AIzaSyBxu_y7IgKTzyR5FSD9rKHxNEoFoYtOAbk&q=$search";
    final response = await http.get(url);
    print(url);
    data = json.decode(response.body);
    _items = [];
    nextPageToken = data["nextPageToken"];
    data["items"].forEach((element) {
      _items.add(Categories(
          videoId: element["id"]["videoId"],
          title: element["snippet"]["title"].toString().trim(),
          description: element["snippet"]["description"].toString().trim(),
          imageUrl: element["snippet"]["thumbnails"]["default"]["url"]));
    });
    notifyListeners();
    isLoading = false;
  }

  Future<void> getNewVideos() async {
    isLoading = true;
    isSearch = true;
    print("enterred");
    var data;
    final url =
        "https://www.googleapis.com/youtube/v3/search?part=snippet&type=video&key=AIzaSyBxu_y7IgKTzyR5FSD9rKHxNEoFoYtOAbk&q=$previousSearch&pageToken=$nextPageToken";
    final response = await http.get(url);
    print(url);
    data = json.decode(response.body);
    nextPageToken = data["nextPageToken"];
    data["items"].forEach((element) {
      _items.add(Categories(
          videoId: element["id"]["videoId"],
          title: element["snippet"]["title"].toString().trim(),
          description: element["snippet"]["description"].toString().trim(),
          imageUrl: element["snippet"]["thumbnails"]["default"]["url"]));
    });
    notifyListeners();
    isLoading = false;
  }

  Future<void> getTrendingVideos() async {
    isLoading = true;
    isSearch = false;
    print("enterred");
    var data;

    final url =
        "https://www.googleapis.com/youtube/v3/videos?part=snippet&type=video&key=AIzaSyBxu_y7IgKTzyR5FSD9rKHxNEoFoYtOAbk&chart=mostPopular&regionCode=US";
    final response = await http.get(url);
    print(url);
    data = json.decode(response.body);
    _items = [];
    nextPageToken = data["nextPageToken"];
    data["items"].forEach((element) {
      _items.add(Categories(
          videoId: element["id"],
          title: element["snippet"]["title"].toString().trim(),
          description: element["snippet"]["description"].toString().trim(),
          imageUrl: element["snippet"]["thumbnails"]["default"]["url"]));
    });
    notifyListeners();
    isLoading = false;
  }

  Future<void> getNewTrendingVideos() async {
    isLoading = true;
    isSearch = false;
    print("enterred");
    var data;
    final url =
        "https://www.googleapis.com/youtube/v3/videos?part=snippet&type=video&key=AIzaSyBxu_y7IgKTzyR5FSD9rKHxNEoFoYtOAbk&chart=mostPopular&regionCode=US&pageToken=$nextPageToken";
    final response = await http.get(url);
    print(url);
    data = json.decode(response.body);
    nextPageToken = data["nextPageToken"];
    data["items"].forEach((element) {
      _items.add(Categories(
          videoId: element["id"],
          title: element["snippet"]["title"].toString().trim(),
          description: element["snippet"]["description"].toString().trim(),
          imageUrl: element["snippet"]["thumbnails"]["default"]["url"]));
    });
    notifyListeners();
    isLoading = false;
  }
}
