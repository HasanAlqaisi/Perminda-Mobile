import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:perminda/data/db/app_database/app_database.dart';

class ProductShow extends StatelessWidget {
  final ProductData productData;
  const ProductShow({this.productData});

  @override
  Widget build(BuildContext context) {
    int sale = productData.sale;
    double price = productData.price;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6.0),
      child: Container(
        width: 160,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(12.0)),
        child: Stack(
          alignment: AlignmentDirectional.bottomCenter,
          children: [
            Positioned(
                top: 0,
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.0)),
                  height: 250 - 80.0,
                  width: 160,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12.0),
                    child: CachedNetworkImage(
                        imageUrl: productData.image, fit: BoxFit.cover),
                  ),
                )),
            sale > 0
                ? Positioned(
                    top: 0,
                    left: 0,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(8),
                          bottomRight: Radius.circular(8),
                        ),
                        color: Colors.red,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: Text(
                          ' %$sale OFF ',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  )
                : Container(),
            Positioned(
              top: 0,
              right: 4,
              child: Icon(Icons.favorite_outline, color: Colors.grey),
            ),
            Container(
              height: 80,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey, width: 0.1),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8.0),
                  topRight: Radius.circular(8.0),
                  bottomRight: Radius.circular(12.0),
                  bottomLeft: Radius.circular(12.0),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.only(top: 4.0, left: 4.0, right: 4.0),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        productData.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                      text:
                                          'IQD ${(sale > 0 ? price - (price * (sale / 100)) : price).toInt()}',
                                      style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    // TextSpan(
                                    //   text: productData.price.toString(),
                                    //   style: TextStyle(
                                    //       fontSize: 12,
                                    //       fontWeight: FontWeight.bold),
                                    // )
                                  ],
                                ),
                              ),
                            ),
                            sale > 0
                                ? Align(
                                    alignment: Alignment.bottomRight,
                                    child: Text(
                                      'IQD ${price.toInt()}',
                                      style: TextStyle(
                                        fontSize: 10,
                                        decoration: TextDecoration.lineThrough,
                                      ),
                                    ),
                                  )
                                : Container()
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );

    // Placeholder(color: Colors.red),
    // Container(
    //   height: 80,
    //   color: Colors.white,
    //   child: Column(
    //     children: [
    //       Text(
    //         'Samsung Galaxy S20 RAM 4 GB',
    //         maxLines: 2,
    //         overflow: TextOverflow.ellipsis,
    //       ),
    //       Text.rich(
    //         TextSpan(children: [
    //           TextSpan(
    //             text: 'IQD ',
    //             style: TextStyle(fontSize: 9),
    //           ),
    //           TextSpan(
    //             text: '400,000',
    //             style:
    //                 TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
    //           )
    //         ]),
    //       )
    //     ],
    //   ),
    // )
  }
}
