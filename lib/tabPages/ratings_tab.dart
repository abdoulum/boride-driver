import 'package:boride_driver/brand_colors.dart';
import 'package:boride_driver/infoHandler/app_info.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smooth_star_rating_nsafe/smooth_star_rating.dart';

import '../global/global.dart';



class RatingsTabPage extends StatefulWidget
{
  const RatingsTabPage({Key? key}) : super(key: key);

  @override
  State<RatingsTabPage> createState() => _RatingsTabPageState();
}




class _RatingsTabPageState extends State<RatingsTabPage>
{
  double ratingsNumber=0;

  @override
  void initState() {
    super.initState();
    getRatingsNumber();
  }

  getRatingsNumber()
  {
    setState(() {
      ratingsNumber = double.parse(Provider.of<AppInfo>(context, listen: false).driverAverageRatings);
    });

    setupRatingsTitle();
  }

  setupRatingsTitle()
  {
    if(ratingsNumber == 1)
    {
      setState(() {
        titleStarsRating = "Very Bad";
      });
    }
    if(ratingsNumber == 2)
    {
      setState(() {
        titleStarsRating = "Bad";
      });
    }
    if(ratingsNumber == 3)
    {
      setState(() {
        titleStarsRating = "Good";
      });
    }
    if(ratingsNumber == 4)
    {
      setState(() {
        titleStarsRating = "Very Good";
      });
    }
    if(ratingsNumber == 5)
    {
      setState(() {
        titleStarsRating = "Excellent";
      });
    }
  }

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
        backgroundColor: Colors.black,
        child: Container(
          margin: const EdgeInsets.all(1),
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              const SizedBox(height: 15.0,),

              const Text(
                "Your Ratings :",
                style: TextStyle(
                  fontSize: 22,
                  fontFamily: "Brand-Bold",
                  letterSpacing: 2,
                  color: Colors.black54,
                ),
              ),

              const SizedBox(height: 15.0,),

              const Divider(height: 1.0, thickness: 2.0,),

              const SizedBox(height: 20.0,),

              SmoothStarRating(
                rating: double.parse(Provider.of<AppInfo>(context, listen: false).driverAverageRatings),
                allowHalfRating: false,
                starCount: 5,
                color: BrandColors.colorPrimary,
                borderColor: BrandColors.colorAccent2,
                size: 46,
              ),

              const SizedBox(height: 10.0,),

              Text(
                titleStarsRating,
                style: const TextStyle(
                  fontSize: 30,
                  fontFamily: "Brand-Bold",
                  color: Colors.black,
                ),
              ),

              const SizedBox(height: 18.0,),

            ],
          ),
        ),
      ),
    );
  }
}
