// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:smat_crow/features/domain/entities/user/news_entity.dart';
// import 'package:smat_crow/features/domain/repository/firebase_repository.dart';
// import 'package:smat_crow/features/presentation/pages/news/views/presentation/screens/news_page_category_button.dart';
// import 'package:smat_crow/features/presentation/pages/news/views/presentation/widget/app_bar_widget.dart';
// import 'package:smat_crow/features/presentation/pages/news/views/presentation/widget/news_data_constant.dart';
// import 'package:smat_crow/features/presentation/pages/news/views/presentation/widget/news_feeds.dart';
// import 'package:smat_crow/features/presentation/pages/news/views/presentation/widget/show_loader.dart';
// import 'package:smat_crow/features/presentation/provider/news_provider.dart';
// import 'package:smat_crow/utils/constants.dart';
// import 'package:smat_crow/utils2/decoration.dart';
// import 'package:smat_crow/utils2/spacing_constants.dart';

// //news page content

// class NewsPageContent extends StatelessWidget {
//   final NewsEntity newsEntity;
//   final String randomImageUrl;
//   final FirebaseRepository firebaseRepository;
//   const NewsPageContent({
//     Key? key,
//     required this.newsEntity,
//     required this.randomImageUrl,
//     required this.firebaseRepository,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final model = Provider.of<NewsProvider>(context);

//     return FutureBuilder(
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.none || snapshot.connectionState == ConnectionState.waiting) {
//           return const ShowLoader();
//         }
//         return Stack(
//           children: [
//             DecorationBox.newsContainer(context),
//             NestedScrollView(
//               physics: const BouncingScrollPhysics(),
//               controller: model.scrollController,
//               headerSliverBuilder: (context, value) {
//                 return [
//                   SliverToBoxAdapter(
//                     child: Column(
//                       children: [
//                         const AppBarWidget(),
//                         Container(
//                           height: SpacingConstants.size10,
//                         )
//                       ],
//                     ),
//                   ),
//                   SliverToBoxAdapter(
//                     child: Padding(
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: SpacingConstants.double25,
//                       ),
//                       child: SizedBox(
//                         height: SpacingConstants.size49,
//                         child: ListView.builder(
//                           physics: const BouncingScrollPhysics(),
//                           controller: model.scrollController,
//                           scrollDirection: Axis.horizontal,
//                           itemCount: categories.length,
//                           itemBuilder: (BuildContext context, int index) {
//                             return NewsPageCategoryButton(index: index);
//                           },
//                         ),
//                       ),
//                     ),
//                   ),
//                 ];
//               },
//               body: Padding(
//                 padding: const EdgeInsets.only(top: SpacingConstants.double24),
//                 child: TabBarView(
//                   controller: model.controller,
//                   children: List.generate(categories.length, (index) {
//                     final category = categories[index];
//                     final key = category.imageUrl.toString();
//                     return ListView.separated(
//                       itemCount: SpacingConstants.int10,
//                       separatorBuilder: (context, index) {
//                         return customSizedBoxHeight(SpacingConstants.size20);
//                       },
//                       shrinkWrap: true,
//                       itemBuilder: (context, i) {
//                         if (model.newsData[key] != null) {
//                           final newsData = model.newsData[key]![i];
//                           return NewsFeedCard(
//                             newsEntity: NewsEntity(
//                               source: newsData['source'][r"$t"],
//                               title: newsData['title'][r"$t"],
//                               url: newsData['link'][r"$t"],
//                               imageUrl: newsData['image'][r"$t"],
//                             ),
//                           );
//                         }
//                         return const NewsConstantWidget();
//                       },
//                       padding: DecorationBox.padding25(),
//                     );
//                   }),
//                 ),
//               ),
//             )
//           ],
//         );
//       },
//       future: model.getProfileInformation(),
//     );
//   }
// }
