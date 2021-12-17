import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:googleapis/youtube/v3.dart';
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

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SigninblocBloc, SigninblocState>(
      builder: (context, state) {
        if (state is SigninblocSignedInState) {
          return BlocProvider(
            // create: (context) =>SearchBloc(client: state.client)..add(SearchVideosPressButton(query: "innomatrix", maxResults: 200)),
            create: (context) => SearchBloc(client: state.client),

            child: Scaffold(
              // drawer: Drawer(child: AppDrawer()),
              // appBar: myAppBar(context),
              body: BlocBuilder<SearchBloc, SearchState>(
                builder: (context, state) {
                  return Scaffold(
                    drawer: Drawer(child: AppDrawer()),
                    appBar: myAppBar(context),
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

                        return CustomScrollView(controller: scrollController, slivers: [
                          SliverGrid(
                            // itemCount: state.items.length + 1,
                            delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
                              // if (state.items.length == index) {
                              //   if (state.hasReachedMax) {
                              //     return Container();
                              //   }
                              //   return LinearProgressIndicator(
                              //     minHeight: 7,
                              //   );
                              // }
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
                        ]);
                      }

                      return Text("Loading");
                    }),
                  );
                },
              ),
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
