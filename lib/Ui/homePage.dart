import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:googleapis/youtube/v3.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
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

  ScrollController scrollController = ScrollController();
  FloatingSearchBarController floatingSearchBarController = FloatingSearchBarController();
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SigninblocBloc, SigninblocState>(
      builder: (context, state) {
        if (state is SigninblocSignedInState) {
          return BlocProvider(
            // create: (context) =>SearchBloc(client: state.client)..add(SearchVideosPressButton(query: "innomatrix", maxResults: 200)),
            create: (context) => SearchBloc(client: state.client),

            child: BlocBuilder<SearchBloc, SearchState>(
              builder: (context, state) {
                return Scaffold(
                  drawer: Drawer(child: AppDrawer()),
                  body: SearchBar(
                      floatingSearchBarController: floatingSearchBarController,
                      scrollController: scrollController,
                      child: Builder(builder: (BuildContext context) {
                        // if (false){
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

                          return CustomScrollView(controller: scrollController, slivers: [
                            SliverList(delegate: SliverChildListDelegate([SizedBox(height: 80)])),
                            SliverGrid(
                              delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
                                ThumbnailDetails thumbnailDetails = state.items[index].snippet!.thumbnails!;
                                return Image.network(
                                  thumbnailDetails.maxres?.url ??
                                      thumbnailDetails.high?.url ??
                                      thumbnailDetails.medium?.url! ??
                                      thumbnailDetails.default_!.url!,
                                  // color: Colors.white,
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
                          ]);
                        }
                        BlocProvider.of<SearchBloc>(context)..add(SearchVideosPressButton());

                        return Center(
                          child: LoadingAnimationWidget.staggeredDotWave(color: Colors.redAccent, size: 60),
                        );
                      })),
                );
              },
            ),
          );
        } else {
          return Scaffold(
              drawer: Drawer(
                child: AppDrawer(),
              ),
              body: SearchBar(
                  scrollController: scrollController,
                  floatingSearchBarController: floatingSearchBarController,
                  child: Center(
                      child: Container(
                    margin: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(color: Colors.redAccent, borderRadius: BorderRadius.circular(8)),
                    child: TextButton(
                      child: Text(
                        "Sign In",
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        BlocProvider.of<SigninblocBloc>(context)..add(SignInButtonPressed());
                      },
                    ),
                  ))));
        }
      },
    );
  }
}

class SearchBar extends StatefulWidget {
  SearchBar({Key? key, required this.child, required this.scrollController, required this.floatingSearchBarController})
      : super(key: key);
  final Widget child;
  final ScrollController scrollController;
  final FloatingSearchBarController floatingSearchBarController;

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  List<dynamic> ls = ["sd", "sdss", "sss"];
  @override
  Widget build(BuildContext context) {
    bool isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    return FloatingSearchBar(
      controller: widget.floatingSearchBarController,
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
        widget.floatingSearchBarController.close();
      },
      clearQueryOnClose: false,
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
            child: ListView.builder(
              itemCount: ls.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                // print('build $index');

                return InkWell(
                  onTap: () {
                    BlocProvider.of<SearchBloc>(context)..add(SearchVideosPressButton(query: ls[index]));
                    widget.floatingSearchBarController.query = ls[index];
                    widget.floatingSearchBarController.close();
                  },
                  child: Container(
                    color: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    child: Text(ls[index]),
                  ),
                );
              },
            ),
          ),
        );
      },
      body: FloatingSearchBarScrollNotifier(child: widget.child),
    );
  }
}
