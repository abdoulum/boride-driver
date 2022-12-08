import 'package:boride_driver/global/global.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ionicons/ionicons.dart';

class BankInfo extends StatefulWidget {
  const BankInfo({Key? key}) : super(key: key);

  @override
  State<BankInfo> createState() => _BankInfoState();
}

class _BankInfoState extends State<BankInfo> {
  String accountName = "j";
  String bankName = "k";
  String accountNumber = "i";



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
          backgroundColor: Colors.white,
          shadowColor: Colors.transparent,
          title: const Text(
            "Bank",
            style: TextStyle(color: Colors.black,fontSize: 22, fontFamily: "Brand-Regular"),
          ),
        ),
        body: bankInfoModel !=null ?
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.05,
                vertical: MediaQuery.of(context).size.height * 0.05),
            child:   Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: const Color.fromARGB(100, 225, 226, 233),
                  borderRadius: BorderRadius.circular(20)),

              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    height: 50,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20.0)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [

                        Expanded(
                          child: Text(
                            "Account name:  ${bankInfoModel!.accountName}",
                            style: const TextStyle(
                              fontFamily: "Brand-Regular",
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    height: 50,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20.0)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [

                        Expanded(
                          child: Text(
                            "Account number:  ${bankInfoModel!.accountNumber}",
                            style: const TextStyle(
                              fontFamily: "Brand-Regular",
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),

                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    height: 50,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20.0)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [

                        Expanded(
                          child: Text(
                            "Bank name:  ${bankInfoModel!.bankName}",
                            style: const TextStyle(
                              fontFamily: "Brand-Regular",
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),

                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: Column(
                      children: [
                        const Text("if you wish to change your bank details, please contact us via email", style: TextStyle(fontFamily: "Brand-Regular", fontSize: 14),),
                       const SizedBox(height: 50,),
                        Center(
                          child: Container(
                            height: 70,
                            width: 70,
                            decoration: BoxDecoration(
                                color: const Color.fromARGB(50, 200, 200, 250),
                                borderRadius: BorderRadius.circular(50)),
                            child: const Icon(Icons.email_outlined, color:Color.fromARGB(
                                180, 150, 90, 250),size: 25,),

                          ),
                        ),
                        const SizedBox(height: 10,),

                        const Text("Boridehq@gmail.com", style: TextStyle(fontSize: 15, fontFamily: "Brand-Regular", fontWeight: FontWeight.bold),),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ) :
          Padding(
            padding: EdgeInsets.only(
                left: MediaQuery.of(context).size.width * 0.08,
                right: MediaQuery.of(context).size.width * 0.08,
                top: MediaQuery.of(context).size.height * 0.05
            ),
            child: Column(
              children: [
                const Text(
                  "Bank information",
                  style: TextStyle(
                    fontFamily: "Brand-Regular",
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                const Text(
                  "Enter your bank account details. The information you entered will be used to send your earnings.",
                  style: TextStyle(
                    fontFamily: "Brand-Regular",
                    fontSize: 12,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  margin: const EdgeInsets.all(12),
                  height: 55,
                  width: 350,
                  decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 243, 245, 247),
                      borderRadius: BorderRadius.circular(8)),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: TextFormField(
                      keyboardType: TextInputType.name,
                      textCapitalization: TextCapitalization.words,
                      onChanged: (value) {
                        setState(() {
                          bankName = value;
                        });
                      },
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(null)
                      ],
                      decoration: const InputDecoration(
                        hintText: "Name of bank",
                        hintStyle: TextStyle(fontFamily: "Brand-Regular"),
                        labelStyle: TextStyle(fontFamily: "Brand-Regular"),
                        // prefixIcon: Icon(Icons.person),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(12),
                  height: 55,
                  width: 350,
                  decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 243, 245, 247),
                      borderRadius: BorderRadius.circular(8)),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: TextFormField(
                      keyboardType: TextInputType.name,
                      textCapitalization: TextCapitalization.words,
                      onChanged: (value) {
                        setState(() {
                          accountName = value;
                        });
                      },
                      decoration: const InputDecoration(
                        hintText: "Account name",
                        hintStyle: TextStyle(fontFamily: "Brand-Regular"),
                        //  prefixIcon: Icon(Icons.person),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(12),
                  height: 55,
                  width: 350,
                  decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 243, 245, 247),
                      borderRadius: BorderRadius.circular(8)),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      textCapitalization: TextCapitalization.words,
                      onChanged: (value) {
                        setState(() {
                          accountNumber = value;
                        });
                      },
                      decoration: const InputDecoration(
                        hintText: "Account number",
                        hintStyle: TextStyle(fontFamily: "Brand-Regular"),
                        //  prefixIcon: Icon(Icons.person),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  child: Padding(
                    padding: EdgeInsets.all(15.0),
                    child: Center(
                      child: Text(
                        "Please make sure that the information you entered are correct, as it will be used to send your payments",
                        style: TextStyle(
                          fontFamily: "Brand-Regular",
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).size.height * 0.2),
                  child: GestureDetector(
                    onTap: () {
                      verifyFields();
                    },
                    child: Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width * 0.8,
                      decoration: BoxDecoration(
                          color: Colors.indigo,
                          borderRadius: BorderRadius.circular(30)),
                      child: const Center(
                          child: Text(
                            "submit",
                            style: TextStyle(
                                fontFamily: "Brand-Regular",
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 22),
                          )),
                    ),
                  ),
                ),
              ],
            ),
          )
         );
  }

  verifyFields() {
    if (bankName == "") {
      Fluttertoast.showToast(
          msg: "Please enter the fields", toastLength: Toast.LENGTH_SHORT);
    } else if (accountName == "") {
      Fluttertoast.showToast(
          msg: "Please enter the fields", toastLength: Toast.LENGTH_SHORT);
    } else if (accountNumber == "") {
      Fluttertoast.showToast(
          msg: "Please enter the fields", toastLength: Toast.LENGTH_SHORT);
    } else {
      updateBankProfile();
    }
  }

  updateBankProfile() {
    Map bankMap = {
      "bank_name": bankName.trim(),
      "account_name": accountName.trim(),
      "account_number": accountNumber.trim(),
    };

    DatabaseReference profileRef = FirebaseDatabase.instance
        .ref()
        .child("drivers")
        .child(FirebaseAuth.instance.currentUser!.uid);
    profileRef.child("bank_details").set(bankMap);

    Navigator.pop(context);
  }
}
