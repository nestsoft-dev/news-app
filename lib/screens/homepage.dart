import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:newapp/constants/appConstantFile.dart';

class Homepage extends StatefulWidget {
  const new({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  BannerAd? _bannerAd;
  void _loadAd() async {
    // Get an AnchoredAdaptiveBannerAdSize before loading the ad.
    final size = await AdSize.getLargeAnchoredAdaptiveBannerAdSize(
      MediaQuery.sizeOf(context).width.truncate(),
    );

    if (size == null) {
      // Unable to get width of anchored banner.
      return;
    }

    BannerAd(
      adUnitId: "ca-app-pub-3940256099942544/2435281174",
      request: const AdRequest(),
      size: size,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          // Called when an ad is successfully received.
          debugPrint('Ad was loaded.');
          setState(() {
            _bannerAd = ad as BannerAd;
          });
        },
        onAdFailedToLoad: (ad, err) {
          // Called when an ad request failed.
          debugPrint('Ad failed to load with error: $err');
          ad.dispose();
        },
      ),
    ).load();
  }

  didChangeDependencies() {
    super.didChangeDependencies();
    _loadAd();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('News'),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      bottomNavigationBar: Container(
        height: size.height * .07,
        child: _bannerAd != null
            ? Align(
                alignment: Alignment.bottomCenter,
                child: SafeArea(
                  child: SizedBox(
                    width: _bannerAd!.size.width.toDouble(),
                    height: _bannerAd!.size.height.toDouble(),
                    child: AdWidget(ad: _bannerAd!),
                  ),
                ),
              )
            : SizedBox.shrink(),
      ),
      body: Column(
        children: [
          //carousel slider
          SizedBox(
            height: size.height * .35,

            child: CarouselSlider(
              items: dummyNews['news']!.map((e) {
                return Container(
                  width: size.width,
                  margin: EdgeInsets.symmetric(horizontal: 5.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Stack(
                    children: [
                      //Container for image

                      Container(
                        width: size.width,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(e['image_url'].toString()),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),

                      //griedient overlay
                      Container(
                        alignment: Alignment.bottomCenter,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          gradient: LinearGradient(
                            colors: [
                              Colors.black.withOpacity(0.8),
                              Colors.black.withOpacity(0.3),
                            ],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                          ),
                        ),
                      ),

                      //title
                      Positioned(
                        bottom: size.height * .02,
                        left: 0,
                        right: 0,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            e['title'].toString(),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: size.height * .018,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                      ),

                      //views
                      Positioned(
                        top: size.height * .02,
                        right: 0,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Views ${e['views']}',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: size.height * .018,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
              options: CarouselOptions(
                height: 400,
                aspectRatio: 16 / 9,
                viewportFraction: 0.8,
                initialPage: 0,
                enableInfiniteScroll: true,
                reverse: false,
                autoPlay: true,
                autoPlayInterval: Duration(seconds: 3),
                autoPlayAnimationDuration: Duration(milliseconds: 800),
                autoPlayCurve: Curves.fastOutSlowIn,
                enlargeCenterPage: true,
                enlargeFactor: 0.3,
                // onPageChanged: callbackFunction,
                scrollDirection: Axis.horizontal,
              ),
            ),
          ),
          SizedBox(height: size.height * .02),
          //news text
          Text(
            'Latest News',
            style: GoogleFonts.poppins(
              color: Colors.black,
              fontSize: size.height * .02,
              fontWeight: FontWeight.bold,
            ),
          ),

          //news listview
          SizedBox(
            height: size.height * .4,
            width: size.width,

            child: ListView.builder(
              itemCount: dummyNews['news']!.length,
              itemBuilder: (_, index) {
                return Container(
                  height: size.height * .13,
                  width: size.width,
                  padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
                  margin: EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: Image.network(
                          dummyNews['news']![index]['thumbnail_url'].toString(),
                          height: size.height * .13,
                          width: size.width * .23,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(width: size.width * .02),
                      SizedBox(
                        width: size.width * .7,
                        height: size.height * .13,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            //title
                            Text(
                              dummyNews['news']![index]['title'].toString(),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.poppins(
                                color: Colors.black,
                                fontSize: size.height * .012,
                                fontWeight: FontWeight.w500,
                              ),
                            ),

                            //description
                            Text(
                              dummyNews['news']![index]['short_description']
                                  .toString(),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.poppins(
                                color: Colors.black,
                                fontSize: size.height * .012,
                                fontWeight: FontWeight.normal,
                              ),
                            ),

                            //time and views
                            Row(
                              children: [
                                Text(
                                  dummyNews['news']![index]['time'].toString(),
                                  style: GoogleFonts.poppins(
                                    color: Colors.black,
                                    fontSize: size.height * .012,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                                SizedBox(width: size.width * .02),
                                Text(
                                  'Views ${dummyNews['news']![index]['views']}',
                                  style: GoogleFonts.poppins(
                                    color: Colors.black,
                                    fontSize: size.height * .012,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          //ads
        ],
      ),
    );
  }
}
