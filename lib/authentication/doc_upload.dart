import 'dart:async';
import 'dart:io';

import 'package:boride_driver/global/global.dart';
import 'package:boride_driver/widgets/brand_colors.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';

class Upload extends StatefulWidget {
  const Upload({Key? key}) : super(key: key);

  @override
  State<Upload> createState() => _UploadState();
}

class _UploadState extends State<Upload> {
  PlatformFile? pickedFile;
  UploadTask? uploadTask;

  bool isDriverPhotoU = false;
  bool isDriverLicenceU = false;
  bool isDriverVInteriorU = false;
  bool isDriverVExteriorU = false;

  var geoLocator = Geolocator();
  LocationPermission? _locationPermission;

  Future selectFile(String uploadT) async {
    if (uploadT == "driverPhoto") {
      final result = await FilePicker.platform.pickFiles(
          allowMultiple: false,
          type: FileType.custom,
          allowedExtensions: ['png', 'jpg']);
      if (result == null) {
        Fluttertoast.showToast(msg: 'No file selected');
      }
      setState(() {
        pickedFile = result!.files.first;
      });
    }

    final result = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        type: FileType.custom,
        allowedExtensions: ['png', 'jpg']);
    if (result == null) {
      Fluttertoast.showToast(msg: 'No file selected');
    }
    setState(() {
      pickedFile = result!.files.first;
    });

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => const Center(
        child: CircularProgressIndicator(
          color: Colors.indigo,
        ),
      ),
    );
    final file = File(pickedFile!.path!);

    final ppRef = FirebaseStorage.instance
        .ref()
        .child("Drivers")
        .child(fAuth.currentUser!.uid);

    DatabaseReference puRef = FirebaseDatabase.instance
        .ref()
        .child("drivers")
        .child(fAuth.currentUser!.uid);

    DatabaseReference pu2Ref = FirebaseDatabase.instance
        .ref()
        .child("Driver Signup Request")
        .child(fAuth.currentUser!.uid);

    String downloadUrl;

    if (uploadT == "driverLicense") {
      TaskSnapshot uploadTask =
          await ppRef.child("driver_license").putFile(file);
      downloadUrl = await (uploadTask).ref.getDownloadURL();
      pu2Ref.child("driver_license").set(downloadUrl);
      setState(() {
        isDriverLicenceU = true;
      });
      Navigator.pop(context);
    } else if (uploadT == "driverPhoto") {
      TaskSnapshot uploadTask = await ppRef.child("driver_photo").putFile(file);
      downloadUrl = await (uploadTask).ref.getDownloadURL();
      puRef.child("driver_photo").set(downloadUrl);
      pu2Ref.child("driver_photo").set(downloadUrl);
      await fAuth.currentUser!.updatePhotoURL(downloadUrl);
      setState(() {
        isDriverPhotoU = true;
      });
      Navigator.pop(context);
    } else if (uploadT == "interior") {
      TaskSnapshot uploadTask =
          await ppRef.child("driver_vehicle_interior").putFile(file);
      downloadUrl = await (uploadTask).ref.getDownloadURL();
      pu2Ref.child("driver_vehicle_interior").set(downloadUrl);
      setState(() {
        isDriverVInteriorU = true;
      });
      Navigator.pop(context);
    } else if (uploadT == "exterior") {
      TaskSnapshot uploadTask =
          await ppRef.child("driver_vehicle_exterior").putFile(file);
      downloadUrl = await (uploadTask).ref.getDownloadURL();
      pu2Ref.child("driver_vehicle_exterior").set(downloadUrl);
      setState(() {
        isDriverVExteriorU = true;
      });
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(Icons.arrow_back)),
        title: const Text(
          "Complete your Registration",
          style: TextStyle(color: Colors.black, fontFamily: "Brand-Regular"),
        ),
        shadowColor: Colors.transparent,
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: 20,
              vertical: MediaQuery.of(context).size.height * 0.05),
          child: Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "Documents Upload",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Brand-Regular",
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "We are legally obliged to ask you for some documents to register you as a driver.",
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: "Brand-Regular",
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "Driver License",
                    style: TextStyle(
                        fontFamily: "Brand-Regular",
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "Please provide a clear photo of your driver's license",
                    style: TextStyle(
                      fontFamily: "Brand-Regular",
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      selectFile("driverLicense");
                    },
                    child: Container(
                      height: 45,
                      width: 100,
                      decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 243, 245, 247),
                          borderRadius: BorderRadius.circular(20)),
                      child: const Center(
                        child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 15),
                            child: Text(
                              "Upload  + ",
                              style: TextStyle(
                                  fontFamily: "brand-regular",
                                  color: BrandColors.colorTextT),
                            )),
                      ),
                    ),
                  ),
                  const Spacer(),
                  !isDriverLicenceU
                      ? const Text(
                          "* Required",
                          style: TextStyle(fontSize: 12, color: Colors.red),
                        )
                      : Container()
                ],
              ),
              Divider(
                height: MediaQuery.of(context).size.height * 0.06,
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
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          selectFile("driverPhoto");
                        },
                        child: Container(
                          height: 45,
                          width: 100,
                          decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 243, 245, 247),
                              borderRadius: BorderRadius.circular(20)),
                          child: const Center(
                            child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 15),
                                child: Text("Upload  + ",
                                    style: TextStyle(
                                        color: BrandColors.colorTextT,
                                        fontFamily: "brand-regular"))),
                          ),
                        ),
                      ),
                      const Spacer(),
                      !isDriverPhotoU
                          ? const Text(
                              "* Required",
                              style: TextStyle(fontSize: 12, color: Colors.red),
                            )
                          : Container()
                    ],
                  ),
                ],
              ),
              Divider(
                height: MediaQuery.of(context).size.height * 0.06,
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
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          selectFile("exterior");
                        },
                        child: Container(
                          height: 45,
                          width: 100,
                          decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 243, 245, 247),
                              borderRadius: BorderRadius.circular(20)),
                          child: const Center(
                            child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 15),
                                child: Text("Upload  + ",
                                    style: TextStyle(
                                        color: BrandColors.colorTextT,
                                        fontFamily: "brand-regular"))),
                          ),
                        ),
                      ),
                      const Spacer(),
                      !isDriverVExteriorU
                          ? const Text(
                              "* Required",
                              style: TextStyle(fontSize: 12, color: Colors.red),
                            )
                          : Container()
                    ],
                  ),
                ],
              ),
              Divider(
                height: MediaQuery.of(context).size.height * 0.06,
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
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          selectFile("interior");
                        },
                        child: Container(
                          height: 45,
                          width: 100,
                          decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 243, 245, 247),
                              borderRadius: BorderRadius.circular(20)),
                          child: const Center(
                            child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 15),
                                child: Text("Upload  + ",
                                    style: TextStyle(
                                        color: BrandColors.colorTextT,
                                        fontFamily: "brand-regular"))),
                          ),
                        ),
                      ),
                      const Spacer(),
                      !isDriverVInteriorU
                          ? const Text(
                              "* Required",
                              style: TextStyle(fontSize: 12, color: Colors.red),
                            )
                          : Container()
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.05,
                  ),
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        checkUpload();
                      },
                      child: Container(
                        height: 50,
                        width: MediaQuery.of(context).size.width * 0.8,
                        decoration: BoxDecoration(
                            color: Colors.indigo,
                            borderRadius: BorderRadius.circular(30)),
                        child: const Center(
                            child: Text(
                          "Continue",
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: "Brand-Regular",
                              fontSize: 18),
                        )),
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
  }

  checkUpload() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext c) {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.indigo,
            ),
          );
        });

    if (isDriverLicenceU &&
        isDriverPhotoU &&
        isDriverVExteriorU &&
        isDriverVInteriorU) {
      checkIfLocationPermissionAllowed();

      Timer.periodic(const Duration(seconds: 5), (timer) {
        Phoenix.rebirth(context);
      });
    }
  }

  checkIfLocationPermissionAllowed() async {
    _locationPermission = await Geolocator.requestPermission();

    if (_locationPermission == LocationPermission.denied) {
      _locationPermission = await Geolocator.requestPermission();
    }
  }
}
