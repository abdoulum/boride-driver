import 'package:flutter/material.dart';


class FareAmountCollectionDialog extends StatefulWidget
{
  double? totalFareAmount;

  FareAmountCollectionDialog({Key? key, this.totalFareAmount}) : super(key: key);

  @override
  State<FareAmountCollectionDialog> createState() => _FareAmountCollectionDialogState();
}




class _FareAmountCollectionDialogState extends State<FareAmountCollectionDialog>
{
  @override
  Widget build(BuildContext context)
  {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      backgroundColor: Colors.grey,
      child: Container(
        margin: const EdgeInsets.all(5.0),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 22.0,),

            const Text("Trip Fare", style: TextStyle(fontSize: 18.0, fontFamily: "Brand-Bold"),),

            const SizedBox(height: 22.0,),

            const Divider(height: 2.0, thickness: 2.0,),

            const SizedBox(height: 16.0,),

            Text("\$" + widget.totalFareAmount!.toStringAsFixed(0), style: const TextStyle(fontSize: 55.0, fontFamily: "Brand-Bold"),),

            const SizedBox(height: 16.0,),const SizedBox(height: 16.0,),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Text("This is the total trip amount, it has been charged to the rider.", textAlign: TextAlign.center,style: TextStyle(fontFamily: "Brand-Regular"),),
            ),

            const SizedBox(height: 30.0,),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ElevatedButton(
                onPressed: () async
                {
                  Navigator.pop(context, "fareCollected");

                },
                child: Padding(
                  padding: const EdgeInsets.all(17.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text("Collect Cash", style: TextStyle(fontFamily: "Brand-Bold",fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.white),),
                      Icon(Icons.attach_money, color: Colors.white, size: 26.0,),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30.0,),
          ],
        ),
      ),
    );
  }
}
