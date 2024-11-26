import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gif_with_bloc/search/UI/Enter_text.dart';
import 'package:gif_with_bloc/search/UI/Build_AppBar.dart';
import 'package:gif_with_bloc/search/UI/GIF_tile_widget.dart';
import 'package:gif_with_bloc/search/UI/No_Gifs_Found.dart';
import 'package:gif_with_bloc/search/UI/SearchDetail.dart';
import 'package:gif_with_bloc/search/bloc/search_bloc.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final SearchBloc searchBloc = SearchBloc();
  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    searchBloc.add(InitialEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SearchBloc, SearchState>(
      bloc: searchBloc,
      listenWhen: (previous, current) => current is SearchActionState,
      buildWhen: (previous, current) => current is! SearchActionState,
      listener: (context, state) {},
      builder: (context, state) {
        switch (state.runtimeType) {
          case SearchLoadingState:
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          case SearchInitial:
            return Scaffold(
              body: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(
                          'https://i.pinimg.com/736x/e5/84/e3/e584e3705a240bd65d40fb59918773ac.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Column(
                    children: [
                      BuildAppbar(),
                      Text(
                        '',
                        style: TextStyle(fontSize: 10),
                      ),
                      _buildSearchBar(),
                      EnterText(),
                    ],
                  )),
            );

          case SearchLoadedSuccessState:
            final successState = state as SearchLoadedSuccessState;
            return Scaffold(
              body: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(
                          'https://i.pinimg.com/736x/e5/84/e3/e584e3705a240bd65d40fb59918773ac.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Column(
                    children: [
                      BuildAppbar(),
                      Text(
                        '',
                        style: TextStyle(fontSize: 10),
                      ),
                      _buildSearchBar(),
                      Flexible(
                        child: NotificationListener<ScrollNotification>(
                          onNotification: (ScrollNotification scrollInfo) {
                            if (scrollInfo.metrics.pixels >=
                                scrollInfo.metrics.maxScrollExtent * 0.9) {
                              searchBloc.add(LoadMoreGifs(
                                  text: _textController.text.trim()));
                            }
                            return false;
                          },
                          child: ListView.builder(
                            itemCount: successState.gifs.length + 1,
                            itemBuilder: (context, index) {
                              if (index == successState.gifs.length) {
                                return Center(
                                    child: CircularProgressIndicator());
                              }
                              return GestureDetector(
                                onTap: () {
                                  print(
                                      'GIF clicked: ${successState.gifs[index].title}');
                                  searchBloc.add(GifClicked(
                                      gif: successState.gifs[index]));
                                },
                                child: GifTileWidget(
                                  gifModel: successState.gifs[index],
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  )),
            );

          case SearchDetailState:
            final successState = state as SearchDetailState;
            return Scaffold(
              body: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(
                          'https://i.pinimg.com/736x/e5/84/e3/e584e3705a240bd65d40fb59918773ac.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Column(
                    children: [
                      BuildAppbar(),
                      Text(
                        '',
                        style: TextStyle(fontSize: 10),
                      ),
                      _buildSearchBar(),
                      SearchDetail(gifModel: successState.gif)
                    ],
                  )),
            );
          case NoGifsFoundState:
            return Scaffold(
              body: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(
                          'https://i.pinimg.com/736x/e5/84/e3/e584e3705a240bd65d40fb59918773ac.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Column(
                    children: [
                      BuildAppbar(),
                      Text(
                        '',
                        style: TextStyle(fontSize: 10),
                      ),
                      _buildSearchBar(),
                      NoGifsFound(),
                    ],
                  )),
            );
          case SearchErrorState:
            final errorState = state as SearchErrorState;
            return Scaffold(
              backgroundColor: Colors.white,
              body: Center(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.red.shade300, Colors.red.shade700],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        offset: Offset(0, 10),
                        blurRadius: 15,
                      ),
                    ],
                  ),
                  child: Text(
                    errorState.message,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          blurRadius: 5.0,
                          color: Colors.black.withOpacity(0.3),
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          default:
            return SizedBox();
        }
      },
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF4facfe), Color(0xFF00f2fe)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      padding: const EdgeInsets.all(3.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 17.0),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.8),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.white.withOpacity(0.6),
              blurRadius: 10,
              offset: Offset(-2, -2),
            ),
          ],
        ),
        child: TextField(
          controller: _textController,
          decoration: InputDecoration(
            labelText: 'Search for GIFs',
            labelStyle: TextStyle(
              color: Colors.black.withOpacity(0.6),
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
            border: InputBorder.none,
            suffixIcon: IconButton(
              icon: SizedBox(
                width: 24,
                height: 24,
                child: Image.network(
                  'https://cdn2.iconfinder.com/data/icons/crystalproject/128x128/apps/search.png',
                  fit: BoxFit.contain,
                ),
              ),
              onPressed: () {
                searchBloc.add(
                    SearchButtonClicked(text: _textController.text.trim()));
              },
            ),
          ),
          cursorColor: Color(0xFF4facfe),
          onChanged: (value) {
            searchBloc.add(SearchButtonClicked(text: value.trim()));
          },
        ),
      ),
    );
  }
}
