import 'package:boride_driver/authentication/driver_registation.dart';
import 'package:boride_driver/global/global.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';



class ProfileTabPage extends StatefulWidget
{
  const ProfileTabPage({Key? key}) : super(key: key);

  @override
  State<ProfileTabPage> createState() => _ProfileTabPageState();
}

class _ProfileTabPageState extends State<ProfileTabPage>
{
  @override
  Widget build(BuildContext context)
  {
    return  Scaffold(
      body: ListView(
        children: [Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.052,
            ),
            Container(
              padding:
              const EdgeInsets.only(left: 30, right: 30, bottom: 10),
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 15),
                    child: Container(
                      margin: const EdgeInsets.only(top: 45),
                      child: Stack(
                        children: [
                          const CircleAvatar(
                            radius: 45,
                            backgroundImage: AssetImage(''),
                          ),
                          Container(
                              margin: const EdgeInsets.only(top: 60, left: 70),
                              child: const Icon(Icons.edit)),
                        ],
                      ),
                    ),
                  ),
                  Column(children: [
                    Text(onlineDriverData.name ?? "Getting name...",
                        style: const TextStyle(
                            fontSize: 24,fontFamily: "Brand-Bold", fontWeight: FontWeight.bold)),
                    Container(
                      margin: const EdgeInsets.only(top: 5),
                      child: Text(onlineDriverData.email ?? "Getting info...",
                          style: const TextStyle(
                              fontSize: 14, fontFamily: "Brand-Regular" ,fontWeight: FontWeight.w400)),
                    ),
                  ]),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.1,
                  ),
                  Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        height: 50,
                        decoration: BoxDecoration(
                            color: Theme.of(context).backgroundColor,
                            borderRadius: BorderRadius.circular(20.0)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.privacy_tip),
                            SizedBox(width: 40),
                            Expanded(
                              child: Text(
                                'Privacy',
                                style: TextStyle(
                                  fontFamily: "Brand-Regular",
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            SizedBox(width: 15),
                            Icon(Icons.arrow_forward_ios_outlined)
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
                            color: Theme.of(context).backgroundColor,
                            borderRadius: BorderRadius.circular(20.0)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.help_outline),
                            SizedBox(width: 40),
                            Expanded(
                              child: Text(
                                'Help & Support',
                                style: TextStyle(
                                  fontFamily: "Brand-Regular",
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            SizedBox(width: 15),
                            Icon(Icons.arrow_forward_ios_outlined)
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      GestureDetector(
                        onTap: () {
                          // Navigator.push(context, MaterialPageRoute(builder: (context) => Setting()));
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          height: 50,
                          decoration: BoxDecoration(
                              color: Theme.of(context).backgroundColor,
                              borderRadius: BorderRadius.circular(20.0)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.settings),
                              SizedBox(width: 40),
                              Expanded(
                                child: Text(
                                  'Settings',
                                  style: TextStyle(
                                    fontFamily: "Brand-Regular",
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              Spacer(),
                              Icon(Icons.arrow_forward_ios_outlined)
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        height: 50,
                        decoration: BoxDecoration(
                            color: Theme.of(context).backgroundColor,
                            borderRadius: BorderRadius.circular(20.0)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.person_add),
                            SizedBox(width: 40),
                            Expanded(
                              child: Text(
                                'Invite Friends',
                                style: TextStyle(
                                  fontFamily: "Brand-Regular",
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Spacer(),
                            Icon(Icons.arrow_forward_ios_outlined)
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      GestureDetector(
                        onTap: () async {

                          await FirebaseAuth.instance.signOut();
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const NewDriver()));
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          height: 50,
                          decoration: BoxDecoration(
                              color: Theme.of(context).backgroundColor,
                              borderRadius: BorderRadius.circular(20.0)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.logout),
                              SizedBox(width: 40),
                              Expanded(
                                child: Text(
                                  'Logout',
                                  style: TextStyle(
                                    fontFamily: "Brand-Regular",
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              Spacer(),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ]),
    );
  }
}
