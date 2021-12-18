import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:googleapis/youtube/v3.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:youtubeapis/Ui/appDrawer.dart';
import 'package:youtubeapis/bloc/SearchBloc/search_bloc.dart';
import 'package:youtubeapis/bloc/SignInBloc/signinbloc_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void initState() {
    super.initState();
    // BlocProvider.of<SigninblocBloc>(context)..add(SignInInitialEvent());
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  ScrollController scrollController = ScrollController();
  FloatingSearchBarController floatingSearchBarController = FloatingSearchBarController();
  List<dynamic> ls = ["sd", "sdss", "sss"];
  @override
  Widget build(BuildContext context) {
    bool isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    return BlocBuilder<SigninblocBloc, SigninblocState>(
      builder: (context, state) {
        if (state is SigninblocSignedInState) {
          // if (true) {
          return BlocProvider(
            // create: (context) =>SearchBloc(client: state.client)..add(SearchVideosPressButton(query: "innomatrix", maxResults: 200)),
            create: (context) => SearchBloc(client: state.client),

            child: BlocBuilder<SearchBloc, SearchState>(
              builder: (context, state) {
                return Scaffold(
                  drawer: Drawer(child: AppDrawer()),
                  body: FloatingSearchBar(
                    controller: floatingSearchBarController,
                    hint: 'Search...',
                    scrollPadding: const EdgeInsets.only(top: 16, bottom: 56),
                    transitionDuration: const Duration(milliseconds: 50),
                    transitionCurve: Curves.easeInOut,
                    physics: const BouncingScrollPhysics(),
                    // axisAlignment: isPortrait ? 0.0 : -1.0,
                    openAxisAlignment: 0.0,
                    width: isPortrait ? 800 : 700,
                    debounceDelay: const Duration(milliseconds: 200),
                    isScrollControlled: false,
                    actions: [
                      FloatingSearchBarAction(
                        showIfOpened: false,
                        child: CircularButton(
                          icon: const Icon(Icons.place),
                          onPressed: () {},
                        ),
                      ),
                      FloatingSearchBarAction.searchToClear(
                        showIfClosed: false,
                      ),
                    ],
                    transition: CircularFloatingSearchBarTransition(),
                    onSubmitted: (String query) {
                      BlocProvider.of<SearchBloc>(context)..add(SearchVideosPressButton(query: query));
                      floatingSearchBarController.close();
                    },
                    onQueryChanged: (String query) async {
                      if (query == "") {
                        setState(() {
                          ls = [];
                        });
                        return;
                      }
                      // Call your model, bloc, controller here.
                      final Response response = await Dio().get(
                        "https://suggestqueries.google.com/complete/search",
                        queryParameters: {
                          "client": "firefox",
                          "ds": "yt",
                          "q": query,
                        },
                        options: Options(
                          headers: {
                            "Access-Control-Allow-Origin": "*",
                            "Access-Control-Allow-Headers": "Content-Type",
                            "Referrer-Policy": "no-referrer-when-downgrade",
                          },
                        ),
                      );
                      List<dynamic> data = jsonDecode(response.data) as List<dynamic>;
                      // debugPrint(data[1]);
                      setState(() {
                        ls = data[1] as List<dynamic>;
                      });
                    },
                    builder: (context, transition) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Material(
                          color: Colors.white,
                          elevation: 4.0,
                          child: Column(
                            // mainAxisSize: MainAxisSize.min,
                            // children: Colors.accents.map((color) {
                            //   return Container(height: 112, color: color);
                            // }).toList(),
                            children: ls
                                .map((e) => InkWell(
                                    onTap: () {
                                      BlocProvider.of<SearchBloc>(context)..add(SearchVideosPressButton(query: e));
                                    },
                                    child: SizedBox(height: 20, child: Text(e))))
                                .toList(),
                          ),
                        ),
                      );
                    },
                    body: Builder(builder: (BuildContext context) {
                      if (state.searchStatus == SearchStatus.success) {
                        bool flag = true;
                        scrollController.addListener(() {
                          if (flag &&
                              scrollController.position.maxScrollExtent == scrollController.position.pixels &&
                              !state.hasReachedMax) {
                            flag = false;
                            BlocProvider.of<SearchBloc>(context)..add(SearchMoreVideosEvent());
                          }
                        });

                        return FloatingSearchBarScrollNotifier(
                          child: CustomScrollView(controller: scrollController, slivers: [
                            SliverList(delegate: SliverChildListDelegate([SizedBox(height: 80)])),
                            SliverGrid(
                              delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
                                ThumbnailDetails thumbnailDetails = state.items[index].snippet!.thumbnails!;
                                return Image.network(
                                  thumbnailDetails.maxres?.url ??
                                      thumbnailDetails.high?.url ??
                                      thumbnailDetails.medium?.url! ??
                                      thumbnailDetails.default_!.url!,
                                  fit: BoxFit.contain,
                                );
                              }, childCount: state.items.length),
                              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                                  maxCrossAxisExtent: 600,
                                  childAspectRatio: 3 / 2,
                                  crossAxisSpacing: 20,
                                  mainAxisSpacing: 20),
                            ),
                            if (!state.hasReachedMax)
                              SliverList(
                                delegate: SliverChildListDelegate([
                                  // (!state.hasReachedMax) ? LinearProgressIndicator(minHeight: 7) : Container(),
                                  LinearProgressIndicator(minHeight: 7),
                                ]),
                              ),
                          ]),
                        );
                      }
                      BlocProvider.of<SearchBloc>(context)..add(SearchVideosPressButton());

                      return Text("Loading");
                    }),
                  ),
                );
              },
            ),
          );
        } else {
          return Scaffold(
              drawer: Drawer(
                child: AppDrawer(),
              ),
              appBar: AppBar(),
              body: Text("Not Signed IN"));
        }
      },
    );
  }
}

AppBar myAppBar(BuildContext context) {
  TextEditingController textEditingController = TextEditingController();
  return AppBar(
    centerTitle: true,
    titleSpacing: 40,
    title: Container(
      // color: Colors.pink,
      // margin: EdgeInsets.all(30),
      // padding: EdgeInsets.all(30),
      constraints: BoxConstraints(maxWidth: 800, minWidth: 200, maxHeight: 40),
      child: TextFormField(
        controller: textEditingController,
        decoration: InputDecoration(
            focusedBorder: OutlineInputBorder(borderRadius: const BorderRadius.all(Radius.circular(7.0))),
            border: OutlineInputBorder(
                borderSide: BorderSide(style: BorderStyle.solid),
                borderRadius: const BorderRadius.all(Radius.circular(7.0))),
            suffixIcon: IconButton(
              icon: Icon(Icons.search, color: Colors.black),
              onPressed: () {
                BlocProvider.of<SearchBloc>(context)
                  ..add(SearchVideosPressButton(query: textEditingController.text, maxResults: 50));
              },
            )),
        onFieldSubmitted: (String? value) async {
          BlocProvider.of<SearchBloc>(context)..add(SearchVideosPressButton(query: value, maxResults: 50));
        },
        onSaved: (String? value) async {
          BlocProvider.of<SearchBloc>(context)..add(SearchVideosPressButton(query: value));
        },
      ),
    ),
    actions: [],
  );
}
