import 'package:flutter/material.dart';
import 'package:skeleton_text/skeleton_text.dart';

class BookingSkeleton extends StatelessWidget {
  final int count;

  const BookingSkeleton({Key key, this.count}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 195 * count.toDouble(),
      child: ListView.builder(
          scrollDirection: Axis.vertical,
          physics: BouncingScrollPhysics(),
          itemCount: count,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.only(
                left: 8,
                right: 8,
                bottom: 27
              ),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                        Radius.circular(10.0)),
                    color: Colors.white70),
                child: Container(
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment:
                        CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment:
                        MainAxisAlignment.start,
                        children: <Widget>[
                          SkeletonAnimation(
                            child: Container(
                              width: MediaQuery.of(context)
                                  .size
                                  .width *
                                  0.65,
                              height: 60.0,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          SkeletonAnimation(
                            child: Container(
                              width: MediaQuery.of(context)
                                  .size
                                  .width *
                                  0.25,
                              height: 60.0,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Row(
                        crossAxisAlignment:
                        CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment:
                        MainAxisAlignment.center,
                        children: <Widget>[
                          SkeletonAnimation(
                            child: Container(
                              width: 40,
                              height: 40.0,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          SkeletonAnimation(
                            child: Container(
                              height: 50,
                              width: 50,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.grey[300]),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Row(
                        crossAxisAlignment:
                        CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment:
                        MainAxisAlignment.start,
                        children: <Widget>[
                          SkeletonAnimation(
                            child: Container(
                              width: MediaQuery.of(context)
                                  .size
                                  .width *
                                  0.45,
                              height: 60.0,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          SkeletonAnimation(
                            child: Container(
                              width: MediaQuery.of(context)
                                  .size
                                  .width *
                                  0.45,
                              height: 60.0,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }
}
