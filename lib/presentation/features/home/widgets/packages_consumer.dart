import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:perminda/core/mappers/failure_to_string_mapper.dart';
import 'package:perminda/presentation/features/home/bloc/packages_bloc/packages_bloc.dart';
import 'package:perminda/data/db/app_database/app_database.dart';

class PackagesConsumer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PackagesBloc, PackagesState>(
      listener: (context, state) {
        if (state is PackagesFailedState) {
          Fluttertoast.showToast(msg: failureToString(state.failure));
        }
      },
      builder: (context, state) {
        // if (state is PackagesGottenState) {
        return StreamBuilder<List<PackageData>>(
            stream: context.watch<PackagesBloc>().watchPackagesCase(),
            initialData: [],
            builder: (context, AsyncSnapshot<List<PackageData>> snapshot) {
              // print('hasData?' + snapshot.hasData.toString());
              // print('data?' + snapshot.data.toString());
              // print('hasError?' + snapshot.hasError.toString());
              // print('connectionState' + snapshot.connectionState.toString());
              return CarouselSlider.builder(
                itemCount: snapshot.data.length,
                options: CarouselOptions(
                  aspectRatio: 16 / 9,
                  autoPlay: false,
                  enableInfiniteScroll: true,
                  enlargeCenterPage: true,
                ),
                itemBuilder: (context, index) {
                  return snapshot.data.isNotEmpty
                      ? CachedNetworkImage(
                          imageUrl: snapshot.data[index].image,
                          useOldImageOnUrlChange: true,
                        )
                      : CircularProgressIndicator();
                },
              );
            });
        // } else {
        //   return Container();
        // }
      },
    );
  }
}
