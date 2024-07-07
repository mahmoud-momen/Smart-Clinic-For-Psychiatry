import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:smart_clinic_for_psychiatry/domain/model/articlesModel/article.dart';
import 'package:smart_clinic_for_psychiatry/presentation/common/components/appTheme/my_theme.dart';
import 'package:smart_clinic_for_psychiatry/presentation/common/components/dialogUtils/dialogUtils.dart';
import 'package:smart_clinic_for_psychiatry/presentation/newsScreen/logic/cubit/NewCubit.dart';
import 'package:smart_clinic_for_psychiatry/presentation/newsScreen/logic/cubit/NewsState.dart';
import 'package:smart_clinic_for_psychiatry/presentation/newsScreen/logic/cubit/SearchCubit.dart';
import 'package:smart_clinic_for_psychiatry/presentation/newsScreen/screens/ArticleNewsScreen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:smart_clinic_for_psychiatry/provider/app_config_provider.dart';

class NewsScreen extends StatefulWidget {
  static const String routeName = 'news_screen';

  const NewsScreen({super.key});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<AppConfigProvider>(context);
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: provider.isDarkMode()
                ? [Color(0xff5078F2), Color(0xff121212)]
                : [Color(0xff5078F2), Color(0xffFFFFFF)],
          ),
        ),
        child: BlocProvider(
          create: (context) => NewsCubit()
            ..getSources(
                NewsCubit.get(context).catergorieModel?.id ?? 'health'),
          child: BlocConsumer<NewsCubit, HomeState>(
            listener: (context, state) {
              if (state is HomeLoadindState) {
              } else if (state is HomeSorcesErrorState) {
                DialogUtils.showMessage(
                  context,
                  'Error',
                  posActionName:
                      'No internet connection, Please try again later',
                  negActionName: 'OK',
                );
              } else if (state is HomeSorcesSuccessState) {
                NewsCubit.get(context).getNewsData();
              }
            },
            builder: (context, state) {
              var cubit = NewsCubit.get(context);

              if (state is HomeLoadindState) {
                return const Center(child: CircularProgressIndicator());
              }

              List<Article> filteredList = cubit.articlesList.where((article) {
                return article.title!
                    .toLowerCase()
                    .contains(searchController.text.toLowerCase());
              }).toList();

              return Column(
                children: [
                  SizedBox(height: 100.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.articles,
                        style: TextStyle(
                            fontSize: 50,
                            fontWeight: FontWeight.bold,
                            color: MyTheme.whiteColor),
                      ),
                    ],
                  ),
                  SizedBox(height: 30.h),
                  Container(
                    width: 450.w,
                    height: 80.h,
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                    child: TextField(
                      controller: searchController,
                      style: TextStyle(
                        color: provider.isDarkMode()
                            ? MyTheme.whiteColor
                            : MyTheme.primaryDark,
                        fontSize: 20,
                      ),
                      onChanged: (value) {
                        setState(() {});
                      },
                      decoration: InputDecoration(
                        hintStyle: TextStyle(
                          color: provider.isDarkMode()
                              ? MyTheme.whiteColor
                              : MyTheme.primaryDark,
                        ),
                        hintText: AppLocalizations.of(context)!.search,
                        suffixIcon: Icon(Icons.search,color:
                        provider.isDarkMode()
                            ? MyTheme.whiteColor
                            : MyTheme.primaryDark,),
                        filled: true,
                        fillColor: provider.isDarkMode()
                            ? MyTheme.primaryDark
                            : MyTheme.whiteColor,
                        enabled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50.0),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: filteredList.length,
                      itemBuilder: (context, index) {
                        return ArticlesNewsWidget(
                          articles: filteredList[index],
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

//ignore: must_be_immutable
class SuccessNews extends StatelessWidget {
  SuccessNews(
      {super.key, required this.mediaQuery, required this.list, this.isSearch});

  final Size mediaQuery;
  bool? isSearch = false;
  final List<Article> list;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          alignment: Alignment.center,
          width: mediaQuery.width * 1,
          height: mediaQuery.height * 0.05,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
          child: Center(
            child: TextField(
              textAlign: TextAlign.start,
              textAlignVertical: TextAlignVertical.bottom,
              controller: SearchCubit.get(context).searchController,
              onChanged: (value) {
                SearchCubit.get(context).seachNews(value);
              },
              onSubmitted: (value) {
                SearchCubit.get(context).seachNews(value);
              },
              decoration: const InputDecoration(
                hintText: 'Search',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: list.length,
              itemBuilder: (context, index) {
                return ArticlesNewsWidget(articles: list[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}
