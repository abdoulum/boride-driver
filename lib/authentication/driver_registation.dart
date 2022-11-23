import 'package:boride_driver/assistants/assistant_methods.dart';
import 'package:boride_driver/authentication/login_screen.dart';
import 'package:boride_driver/global/global.dart';
import 'package:boride_driver/widgets/progress_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class NewDriver extends StatefulWidget {
  const NewDriver({Key? key}) : super(key: key);

  @override
  State<NewDriver> createState() => _NewDriverState();
}

class _NewDriverState extends State<NewDriver> {
  TextEditingController fullNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController colorController = TextEditingController();
  TextEditingController brandController = TextEditingController();
  TextEditingController yearController = TextEditingController();
  TextEditingController modelController = TextEditingController();
  TextEditingController lPlateController = TextEditingController();
  TextEditingController dLicenseController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController password2Controller = TextEditingController();

  String selectedColor = "";
  String selectedbrand = "";
  String selectedyear = "";
  String selectedState = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          iconTheme: const IconThemeData(
            color: Colors.black,
          ),
          leading: GestureDetector(
              onTap: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LoginScreen()));
              },
              child: const Icon(Icons.arrow_back)),
          title: const Text(
            "Signup As A Driver",
            style: TextStyle(color: Colors.black, fontFamily: "Brand-Regular"),
          ),
          shadowColor: Colors.transparent,
          backgroundColor: Colors.white,
        ),
        body: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            margin: const EdgeInsets.all(20),
            child: Column(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Personal Information.",
                      style: TextStyle(fontSize: 24, fontFamily: "Brand-Bold"),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Full Name",
                          style: TextStyle(
                              fontFamily: "Brand-Regular",
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          //     margin: EdgeInsets.all(12),
                          height: 55,
                          decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 243, 245, 247),
                              borderRadius: BorderRadius.circular(8)),
                          child: Center(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              child: TextFormField(
                                controller: fullNameController,
                                textCapitalization: TextCapitalization.words,
                                keyboardType: TextInputType.name,
                                decoration: const InputDecoration(
                                  hintText: "First & last name",
                                  prefixStyle: TextStyle(color: Colors.black),
                                  // prefixIcon: Icon(Icons.person),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Email",
                          style: TextStyle(
                              fontFamily: "Brand-Regular",
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          //     margin: EdgeInsets.all(12),
                          height: 55,
                          decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 243, 245, 247),
                              borderRadius: BorderRadius.circular(8)),
                          child: Center(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              child: TextFormField(
                                controller: emailController,
                                textCapitalization: TextCapitalization.words,
                                keyboardType: TextInputType.emailAddress,
                                decoration: const InputDecoration(
                                  hintText: "Example@gmail.com",
                                  prefixStyle: TextStyle(color: Colors.black),
                                  // prefixIcon: Icon(Icons.person),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    GestureDetector(
                      onTap: _openBottomSheet,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Select State",
                              style: TextStyle(
                                  fontFamily: "Brand-Regular",
                                  fontWeight: FontWeight.bold)),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            height: 50,
                            decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 243, 245, 247),
                                borderRadius: BorderRadius.circular(8)),
                            child: Row(
                              children: [
                                const SizedBox(
                                  width: 25.0,
                                ),
                                Text(
                                  selectedState.isNotEmpty
                                      ? selectedState
                                      : "State",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontFamily: "Brand-Regular",
                                  ),
                                ),
                                const SizedBox(
                                  width: 6.0,
                                ),
                                const Icon(
                                  Icons.keyboard_arrow_down,
                                  color: Colors.black54,
                                  size: 16.0,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Phone",
                          style: TextStyle(
                              fontFamily: "Brand-Regular",
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Container(
                          //     margin: EdgeInsets.all(12),
                          height: 55,
                          decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 243, 245, 247),
                              borderRadius: BorderRadius.circular(8)),
                          child: Center(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              child: TextFormField(
                                controller: phoneController,
                                textCapitalization: TextCapitalization.words,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  hintText: "080XXXXXXXX",
                                  prefixStyle: TextStyle(color: Colors.black),
                                  // prefixIcon: Icon(Icons.person),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                Divider(
                  color: Colors.grey.shade500,
                ),
                const SizedBox(
                  height: 15,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Vehicle Details & Information",
                      style: TextStyle(
                          fontSize: 20,
                          fontFamily: "Brand-Regular",
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    const Text(
                      "Please fill in the required fields about your vehicle",
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: "Brand-Regular",
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    GestureDetector(
                      onTap: _openColorSheet,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Vehicle color.",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "Brand-Regular")),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            height: 50,
                            decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 243, 245, 247),
                                borderRadius: BorderRadius.circular(8)),
                            child: Row(
                              children: [
                                const SizedBox(
                                  width: 25.0,
                                ),
                                Text(
                                  selectedColor.isNotEmpty
                                      ? selectedColor
                                      : "Color",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontFamily: "Brand-Regular",
                                  ),
                                ),
                                const SizedBox(
                                  width: 6.0,
                                ),
                                const Icon(
                                  Icons.keyboard_arrow_down,
                                  color: Colors.black54,
                                  size: 16.0,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    GestureDetector(
                      onTap: _openBrandSheet,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Vehicle Brand.",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "Brand-Regular")),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            height: 50,
                            decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 243, 245, 247),
                                borderRadius: BorderRadius.circular(8)),
                            child: Row(
                              children: [
                                const SizedBox(
                                  width: 25.0,
                                ),
                                Text(
                                  selectedbrand.isNotEmpty
                                      ? selectedbrand
                                      : "Brand",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontFamily: "Brand-Regular",
                                  ),
                                ),
                                const SizedBox(
                                  width: 6.0,
                                ),
                                const Icon(
                                  Icons.keyboard_arrow_down,
                                  color: Colors.black54,
                                  size: 16.0,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    Container(
                      padding: const EdgeInsets.all(8),
                      child: const Text(
                        "Enter Vehicle Model",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            fontFamily: "Brand-Regular"),
                      ),
                    ),
                    Container(
                      //     margin: EdgeInsets.all(12),
                      height: 55,
                      decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 243, 245, 247),
                          borderRadius: BorderRadius.circular(8)),
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: TextFormField(
                          controller: modelController,
                          textCapitalization: TextCapitalization.words,
                          decoration: const InputDecoration(
                            hintText: "eg Camry, Corolla, Accord, e.t.c",
                            prefixStyle: TextStyle(color: Colors.black),
                            // prefixIcon: Icon(Icons.person),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    GestureDetector(
                      onTap: _openYearSheet,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Vehicle year.",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "Brand-Regular")),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            height: 50,
                            decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 243, 245, 247),
                                borderRadius: BorderRadius.circular(8)),
                            child: Row(
                              children: [
                                const SizedBox(
                                  width: 25.0,
                                ),
                                Text(
                                  selectedyear.isNotEmpty
                                      ? selectedyear
                                      : "year",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontFamily: "Brand-Regular",
                                  ),
                                ),
                                const SizedBox(
                                  width: 6.0,
                                ),
                                const Icon(
                                  Icons.keyboard_arrow_down,
                                  color: Colors.black54,
                                  size: 16.0,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    const Text("Vehicle Plate Number",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            fontFamily: "Brand-Regular")),
                    Container(
                      height: 55,
                      decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 243, 245, 247),
                          borderRadius: BorderRadius.circular(8)),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25),
                          child: TextFormField(
                            controller: lPlateController,
                            textCapitalization: TextCapitalization.characters,
                            decoration: const InputDecoration(
                              hintText: "DKA-707-PV",
                              // prefixIcon: Icon(Icons.person),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                Divider(
                  color: Colors.grey.shade500,
                ),
                const SizedBox(
                  height: 15,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Driver License Number",
                      style: TextStyle(
                          fontFamily: "Brand-Regular",
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Container(
                      height: 55,
                      decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 243, 245, 247),
                          borderRadius: BorderRadius.circular(8)),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25),
                          child: TextFormField(
                            controller: dLicenseController,
                            textCapitalization: TextCapitalization.characters,
                            decoration: const InputDecoration(
                              hintText: "XXXXXXXXXX",
                              // prefixIcon: Icon(Icons.person),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      "Please make sure that you entered the correct license number",
                      style: TextStyle(
                        fontFamily: "Brand-Regular",
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                Divider(
                  color: Colors.grey.shade500,
                ),
                const SizedBox(
                  height: 15,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Documents",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Brand-Regular",
                      ),
                    ),
                    const Text(
                      "You are legally required to submit some documents to register you as a driver",
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: "Brand-Regular",
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Driver License",
                          style: TextStyle(
                              fontFamily: "Brand-Regular",
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        const Text(
                          "Please provide a clear photo of your driver's license",
                          style: TextStyle(
                            fontFamily: "Brand-Regular",
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          height: 45,
                          width: 100,
                          decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 243, 245, 247),
                              borderRadius: BorderRadius.circular(20)),
                          child: Center(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              child: TextFormField(
                                textCapitalization:
                                    TextCapitalization.characters,
                                decoration: const InputDecoration(
                                  hintText: "Upload  + ",
                                  // prefixIcon: Icon(Icons.person),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                    Divider(
                      color: Colors.grey.shade500,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Driver Photo",
                          style: TextStyle(
                              fontFamily: "Brand-Regular",
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        const Text(
                          "Please provide a clear portrait of yourself. Make sure your face is clear with a white background",
                          style: TextStyle(
                            fontFamily: "Brand-Regular",
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          height: 45,
                          width: 100,
                          decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 243, 245, 247),
                              borderRadius: BorderRadius.circular(20)),
                          child: Center(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              child: TextFormField(
                                textCapitalization:
                                    TextCapitalization.characters,
                                decoration: const InputDecoration(
                                  hintText: "Upload  + ",
                                  // prefixIcon: Icon(Icons.person),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                    Divider(
                      color: Colors.grey.shade500,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Vehicle Exterior",
                          style: TextStyle(
                              fontFamily: "Brand-Regular",
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text(
                          "Provide a clear photo of your Vehicle's Exterior from the from",
                          style: TextStyle(
                            fontFamily: "Brand-Regular",
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          height: 45,
                          width: 100,
                          decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 243, 245, 247),
                              borderRadius: BorderRadius.circular(20)),
                          child: Center(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              child: TextFormField(
                                textCapitalization:
                                    TextCapitalization.characters,
                                decoration: const InputDecoration(
                                  hintText: "Upload  + ",
                                  // prefixIcon: Icon(Icons.person),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                    Divider(
                      color: Colors.grey.shade500,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Vehicle Interior",
                          style: TextStyle(
                              fontFamily: "Brand-Regular",
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text(
                          "Provide a clear photo of your Vehicle's Interior, Dashboard should be visible",
                          style: TextStyle(
                            fontFamily: "Brand-Regular",
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          height: 45,
                          width: 100,
                          decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 243, 245, 247),
                              borderRadius: BorderRadius.circular(20)),
                          child: Center(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              child: TextFormField(
                                textCapitalization:
                                    TextCapitalization.characters,
                                decoration: const InputDecoration(
                                  hintText: "Upload  + ",
                                  // prefixIcon: Icon(Icons.person),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    )
                  ],
                ),
                const Divider(),
                const SizedBox(
                  height: 20,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Password",
                      style: TextStyle(
                          fontFamily: "Brand-Regular",
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      //     margin: EdgeInsets.all(12),
                      height: 55,
                      decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 243, 245, 247),
                          borderRadius: BorderRadius.circular(8)),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: TextFormField(
                            controller: passwordController,
                            textCapitalization: TextCapitalization.words,
                            keyboardType: TextInputType.emailAddress,
                            decoration: const InputDecoration(
                              hintText: "Type in password",
                              prefixStyle: TextStyle(color: Colors.black),
                              // prefixIcon: Icon(Icons.person),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      //     margin: EdgeInsets.all(12),
                      height: 55,
                      decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 243, 245, 247),
                          borderRadius: BorderRadius.circular(8)),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: TextFormField(
                            controller: password2Controller,
                            textCapitalization: TextCapitalization.words,
                            keyboardType: TextInputType.emailAddress,
                            decoration: const InputDecoration(
                              hintText: "Re-type password",
                              prefixStyle: TextStyle(color: Colors.black),
                              // prefixIcon: Icon(Icons.person),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 40,
                ),
                SizedBox(
                  height: 45,
                  child: ElevatedButton(
                    onPressed: verifyFields,
                    child: Row(
                      children: const [
                        Text(
                          "Submit",
                          style: TextStyle(
                              fontFamily: "Brand-Regular",
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                        Spacer(),
                        Icon(Icons.arrow_right_sharp),
                      ],
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                    "After you submit, you cannot be able to change the information entered",
                    style: TextStyle(fontFamily: "Brand-Regular", fontSize: 14))
              ],
            ),
          ),
        ));
  }

  void _openBottomSheet() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return _getState();
        });
  }

  Widget _getState() {
    final paymentMethods = ["Abuja"];
    return Container(
      height: 140,
      margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
      color: Colors.white,
      child: ListView(
        children: paymentMethods
            .map((paymentMethod) => ListTile(
                  onTap: () => {_handleStateTap(paymentMethod)},
                  title: Column(
                    children: [
                      Text(
                        paymentMethod,
                        textAlign: TextAlign.start,
                        style: const TextStyle(
                            color: Colors.black, fontFamily: "Brand-Regular"),
                      ),
                      const SizedBox(height: 4),
                      const Divider(height: 1)
                    ],
                  ),
                ))
            .toList(),
      ),
    );
  }

  _handleStateTap(String state) {
    setState(() {
      selectedState = state;
      stateController.text = state;
    });
    Navigator.pop(context);
  }

  void _openColorSheet() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return _getColor();
        });
  }

  Widget _getColor() {
    final color = [
      "Blue",
      "Black",
      "Green",
      "Purple",
      "Orange",
      "Yellow",
    ];
    return Container(
      height: 180,
      margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
      color: Colors.white,
      child: ListView(
        children: color
            .map((colorM) => ListTile(
                  onTap: () => {_handleColorTap(colorM)},
                  title: Column(
                    children: [
                      Text(
                        colorM,
                        textAlign: TextAlign.start,
                        style: const TextStyle(
                            color: Colors.black, fontFamily: "Brand-Regular"),
                      ),
                      const SizedBox(height: 4),
                      const Divider(height: 1)
                    ],
                  ),
                ))
            .toList(),
      ),
    );
  }

  _handleColorTap(String color) {
    setState(() {
      selectedColor = color;
      colorController.text = color;
    });
    Navigator.pop(context);
  }

  void _openBrandSheet() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return _getBrand();
        });
  }

  Widget _getBrand() {
    final brand = [
      'Acura',
      'Audi',
      'Toyota',
      'Honda',
      'Mercedes',
      'BMW',
      'Peugeot',
    ];
    return Container(
      height: 180,
      margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
      color: Colors.white,
      child: ListView(
        children: brand
            .map((brandM) => ListTile(
                  onTap: () => {_handleBrandTap(brandM)},
                  title: Column(
                    children: [
                      Text(
                        brandM,
                        textAlign: TextAlign.start,
                        style: const TextStyle(
                            color: Colors.black, fontFamily: "Brand-Regular"),
                      ),
                      const SizedBox(height: 4),
                      const Divider(height: 1)
                    ],
                  ),
                ))
            .toList(),
      ),
    );
  }

  _handleBrandTap(String brand) {
    setState(() {
      selectedbrand = brand;
      brandController.text = brand;
    });
    Navigator.pop(context);
  }

  void _openYearSheet() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return _getYear();
        });
  }

  Widget _getYear() {
    final year = [
      '2002',
      '2003',
      '2004',
      '2005',
      '2006',
      '2007',
      '2008',
      '2009',
      '2010',
      '2011',
      '2012',
      '2013',
      '2014',
      '2015',
      '2016',
      '2017',
      '2018',
      '2019',
      '2020',
      '2021',
      '2022',
    ];
    return Container(
      height: 180,
      margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
      color: Colors.white,
      child: ListView(
        children: year
            .map((yearM) => ListTile(
                  onTap: () => {_handleYearTap(yearM)},
                  title: Column(
                    children: [
                      Text(
                        yearM,
                        textAlign: TextAlign.start,
                        style: const TextStyle(
                            color: Colors.black, fontFamily: "Brand-Regular"),
                      ),
                      const SizedBox(height: 4),
                      const Divider(height: 1)
                    ],
                  ),
                ))
            .toList(),
      ),
    );
  }

  _handleYearTap(String year) {
    setState(() {
      selectedyear = year;
      yearController.text = year;
    });
    Navigator.pop(context);
  }

  verifyFields() {
    if (fullNameController.text.isEmpty) {
      Fluttertoast.showToast(msg: "Please enter your name");
    } else if (emailController.text.isEmpty) {
      Fluttertoast.showToast(msg: "Please enter your email address");
    } else if (stateController.text.isEmpty) {
      Fluttertoast.showToast(msg: "Please enter state");
    } else if (phoneController.text.isEmpty) {
      Fluttertoast.showToast(msg: "Please enter phone number");
    } else if (colorController.text.isEmpty) {
      Fluttertoast.showToast(msg: "Please enter color");
    } else if (brandController.text.isEmpty) {
      Fluttertoast.showToast(msg: "Please enter brand");
    } else if (modelController.text.isEmpty) {
      Fluttertoast.showToast(msg: "Please enter model");
    } else if (yearController.text.isEmpty) {
      Fluttertoast.showToast(msg: "Please enter year");
    } else if (lPlateController.text.isEmpty) {
      Fluttertoast.showToast(msg: "Please enter plate number");
    } else if (dLicenseController.text.isEmpty) {
      Fluttertoast.showToast(msg: "Please enter License number");
    } else if (passwordController.text.isEmpty) {
      Fluttertoast.showToast(msg: "Please enter password1");
    } else if (password2Controller.text.isEmpty) {
      Fluttertoast.showToast(msg: "Please enter password2");
    } else {
      if (passwordController.text != password2Controller.text) {
        Fluttertoast.showToast(msg: "Passwords does not match");
      } else {
        _registerDriver();
      }
    }
  }

  _registerDriver() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext c) {
          return ProgressDialog(
            message: "Processing, Please wait...",
          );
        });

    final User? firebaseUser = (await fAuth
            .createUserWithEmailAndPassword(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    )
            .catchError((msg) {
      Navigator.pop(context);
      Fluttertoast.showToast(msg: "Error: " + msg.toString());
    }))
        .user;

    if (firebaseUser != null) {
      _uploadDocument();
    }
  }

  _uploadDocument() {
    DatabaseReference driversRef =
        FirebaseDatabase.instance.ref().child("drivers");

    Map driverMap = {
      "id": fAuth.currentUser!.uid,
      "name": fullNameController.text.trim(),
      "email": emailController.text.trim(),
      "phone": phoneController.text.trim(),
    };
    driversRef.child(fAuth.currentUser!.uid).set(driverMap);

    Map driverCarInfoMap = {
      "car_color": colorController.text.trim(),
      "car_number": lPlateController.text.trim(),
      "car_model": modelController.text.trim(),
      "type": "boride-go",
    };

    driversRef
        .child(fAuth.currentUser!.uid)
        .child("car_details")
        .set(driverCarInfoMap);

    Map newUserMap = {
      "name": fullNameController.text.toString(),
      "email": emailController.text.trim(),
      "phone": phoneController.text.trim(),
      "state": stateController.text.trim(),
      "type": "Boride-Go",
      "car_color": colorController.text.trim(),
      "car_brand": brandController.text.trim(),
      "car_year": yearController.text.trim(),
      "car_model": modelController.text.trim(),
      "car_number": lPlateController.text.trim(),
      "driver_license_number": dLicenseController.text.trim(),
    };
    DatabaseReference newDriverRef =
        FirebaseDatabase.instance.ref().child("Driver Signup Request");
    newDriverRef.child(fAuth.currentUser!.uid).set(newUserMap);
    AssistantMethods.readDriverTotalEarnings(context);
    AssistantMethods.readDriverWeeklyEarnings(context);
    AssistantMethods.readDriverRating(context);
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const LoginScreen()));
  }
}
