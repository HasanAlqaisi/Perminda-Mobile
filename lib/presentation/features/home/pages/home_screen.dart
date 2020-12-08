import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:perminda/core/mappers/failure_to_string_mapper.dart';
import 'package:perminda/data/db/app_database/app_database.dart';
import 'package:perminda/data/db/relations/order_item/product_info.dart';
import 'package:perminda/presentation/features/home/bloc/categories_bloc/categories_bloc.dart';
import 'package:perminda/presentation/features/home/bloc/packages_bloc/packages_bloc.dart';
import 'package:perminda/presentation/features/home/bloc/products_by_category_bloc/productsbycategory_bloc.dart';
import 'package:perminda/presentation/features/home/widgets/categories_consumer.dart';
import 'package:perminda/presentation/features/home/widgets/customized_appbar.dart';
import 'package:perminda/presentation/features/home/widgets/packages_consumer.dart';
import 'package:perminda/presentation/features/home/widgets/product_show.dart';
import 'package:perminda/injection_container.dart' as di;
import 'package:shimmer/shimmer.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomizedAppBar(),
      body: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => di.sl<PackagesBloc>()),
          BlocProvider(create: (context) => di.sl<CategoriesBloc>()),
          BlocProvider(create: (context) => di.sl<ProductsbycategoryBloc>()),
        ],
        child: SafeArea(
          child: HomeScreenBody(),
        ),
      ),
    );
  }
}

class HomeScreenBody extends StatefulWidget {
  @override
  _HomeScreenBodyState createState() => _HomeScreenBodyState();
}

class _HomeScreenBodyState extends State<HomeScreenBody> {
  final _categoriesScroll = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<PackagesBloc>().add(RequestPackagesEvent());
    context.read<CategoriesBloc>().add(RequestCategoriesEvent());
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: _handleCategoriesScrolling,
      child: ListView(
        controller: _categoriesScroll,
        children: [
          PackagesConsumer(),
          CategoriesConsumer(),
        ],
      ),
    );
  }

  bool _handleCategoriesScrolling(ScrollNotification notification) {
    if (notification is ScrollEndNotification &&
        _categoriesScroll.position.extentAfter == 0) {
      context.read<CategoriesBloc>().add(RequestCategoriesEvent());
    }
    return false;
  }

  // Widget _buildHomeUI(HomeState homeState) {
  //   return ListView(
  //     children: [
  //       StreamBuilder<List<PackageData>>(
  //           stream: context.read<HomeBloc>().watchPackagesCase(),
  //           initialData: [],
  //           builder: (context, AsyncSnapshot<List<PackageData>> snapshot) {
  //             print('hasData?' + snapshot.hasData.toString());
  //             print('data?' + snapshot.data.toString());
  //             print('hasError?' + snapshot.hasError.toString());
  //             print('connectionState' + snapshot.connectionState.toString());
  //             return CarouselSlider.builder(
  //               itemCount: snapshot.data.length,
  //               options: CarouselOptions(
  //                 aspectRatio: 16 / 7,
  //                 autoPlay: true,
  //               ),
  //               itemBuilder: (context, index) {
  //                 return snapshot.data.isNotEmpty
  //                     ? Image.network(snapshot.data[index].image)
  //                     : CircularProgressIndicator();
  //               },
  //             );
  //           }),
  //       Padding(
  //         padding: EdgeInsets.only(top: 12.0),
  //         child: StreamBuilder<List<CategoryData>>(
  //             stream: context.read<HomeBloc>().watchCategories(),
  //             builder: (context, snapshot) {
  //               final categoriesData = snapshot.data;

  //               return NotificationListener<ScrollNotification>(
  //                 onNotification: _handleCategoriesScrolling,
  //                 child: ListView.builder(
  //                     itemCount: categoriesData.length,
  //                     physics: NeverScrollableScrollPhysics(),
  //                     shrinkWrap: true,
  //                     controller: _categoriesScroll,
  //                     itemBuilder: (context, index) {
  //                       return Column(
  //                         crossAxisAlignment: CrossAxisAlignment.start,
  //                         children: [
  //                           Padding(
  //                             padding: EdgeInsets.only(
  //                                 top: 16.0,
  //                                 bottom: 8.0,
  //                                 left: 8.0,
  //                                 right: 8.0),
  //                             child: Row(
  //                               mainAxisAlignment:
  //                                   MainAxisAlignment.spaceBetween,
  //                               children: [
  //                                 Text(
  //                                   categoriesData[index].name,
  //                                   style: TextStyle(
  //                                       fontSize: 18.0, color: Colors.black),
  //                                 ),
  //                                 Text(
  //                                   'See more',
  //                                   style: TextStyle(
  //                                       fontSize: 10.0, color: Colors.red),
  //                                 ),
  //                               ],
  //                             ),
  //                           ),
  //                           Container(
  //                               // margin: EdgeInsets.only(left: 4),
  //                               height: 250.0,
  //                               child: StreamBuilder<List<ProductData>>(
  //                                   stream: context
  //                                       .read<HomeBloc>()
  //                                       .watchProductsByCategory(
  //                                           categoriesData[index].id),
  //                                   builder: (context, snapshot) {
  //                                     final productsData = snapshot.data;

  //                                     return NotificationListener<
  //                                         ScrollNotification>(
  //                                       onNotification: (notification) {
  //                                         if (notification
  //                                                 is ScrollEndNotification &&
  //                                             _productsByCategoryScroll
  //                                                     .position.extentAfter ==
  //                                                 0) {
  //                                           context.read<HomeBloc>().add(
  //                                                   RequestProductsByCategoryEvent(
  //                                                 productsData[0].category,
  //                                                 productsData.length,
  //                                               ));
  //                                         }
  //                                         return false;
  //                                       },
  //                                       child: ListView.builder(
  //                                           controller:
  //                                               _productsByCategoryScroll,
  //                                           scrollDirection: Axis.horizontal,
  //                                           itemCount: productsData.length,
  //                                           itemBuilder: (context, index) {
  //                                             return ProductShow(
  //                                                 productData:
  //                                                     productsData[index]);
  //                                           }),
  //                                     );
  //                                   }))
  //                         ],
  //                       );
  //                     }),
  //               );
  //             }),
  //       )
  //     ],
  //   );
  // }
}
