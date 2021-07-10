import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:youtubeapi/data/model/search/search.dart';
import 'package:youtubeapi/ui/search/bloc/search_bloc.dart';

import 'ui/search/bloc/search_bloc.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ScrollController _scrollController = ScrollController();
  List<Item> aaa = [];
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Material App Bar'),
        ),
        body: BlocProvider(
          create: (context) => SearchBloc(),
          child: BlocConsumer<SearchBloc, SearchState>(
            listener: (context, state) {
              // if (state is SearchMoreVideosSuccessfullState) {
              // } else if (state is SearchVideosSuccessfullState) {
              //   // aaa = state.items;
              // }
            },
            builder: (context, state) {
              switch (state.status) {
                case ListStatus.initial:
                  return Container(
                    child: TextButton(
                        onPressed: () {
                          BlocProvider.of<SearchBloc>(context)
                            ..add(SearchVideosPressButton(query: "flutterw"));
                        },
                        child: Text(" search Query")),
                  );
                case ListStatus.loading:
                  return Container(
                    child: LinearProgressIndicator(),
                  );
                case ListStatus.success:
                  _scrollController.addListener(() {
                    if (_scrollController.position.extentAfter == 0) {
                      print("end Reached");
                      // aaa.addAll(state.items);
                      // setState(() {});
                      if (!state.hasReachedMax) {
                        BlocProvider.of<SearchBloc>(context)
                          ..add(SearchMoreVideosEvent());
                      }
                    }
                  });
                  // aaa.addAll(state.items);
                  return ListView.builder(
                      controller: _scrollController,
                      itemCount: state.items.length + 1,
                      itemBuilder: (BuildContext context, int index) {
                        // print(index.toString());
                        if (index == state.items.length) {
                          if (state.hasReachedMax) {
                            return Container(
                              color: Colors.red,
                              height: 10,
                            );
                          }
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        return Container(
                          padding: EdgeInsets.all(10),
                          color: Colors.amber,
                          height: 250,
                          child: Text(
                            state.items[index].snippet.title,
                            textScaleFactor: 3,
                          ),
                        );
                      });
                case ListStatus.failure:
                  return Container(
                    child: Text("Bloc faliure in main dart"),
                  );
              }
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
        ),
      ),
    );
  }
}
//  BlocProvider.of<SearchBloc>(context)
//                         ..add(SearchVideosPressButton(query: "flutter"));