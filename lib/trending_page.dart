import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youtube/category_item.dart';
import 'categories_model.dart';

class TrendingPage extends StatefulWidget {
  @override
  _TrendingPageState createState() => _TrendingPageState();
}

class _TrendingPageState extends State<TrendingPage> {
  var _isInit = true;
  @override
  Future<void> didChangeDependencies() async {
    if (_isInit) {
      await Provider.of<CategoriesList>(context).getTrendingVideos();
    }

    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      child: Consumer<CategoriesList>(
        builder: (ctx, data, _) => data.isLoading
            ? Center(child: CircularProgressIndicator())
            : NotificationListener<ScrollNotification>(
                onNotification: (ScrollNotification scrollDetails) {
                  if (!data.isLoading &&
                      scrollDetails.metrics.pixels ==
                          scrollDetails.metrics.maxScrollExtent) {
                    Provider.of<CategoriesList>(context).getNewTrendingVideos();
                  }
                  return false;
                },
                child: ListView.builder(
                    padding: EdgeInsets.only(bottom: 10, top: 10),
                    itemCount: data.items.length,
                    itemBuilder: (ctx, i) => CategoryItem(data, i)),
              ),
      ),
    );
  }
}
