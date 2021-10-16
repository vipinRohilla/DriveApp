
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:loginlogoutflutter/screens/phone_number.dart';

class Welcome extends StatefulWidget {
  const Welcome({Key? key}) : super(key: key);

  @override
  _WelcomeState createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      // backgroundColor: const Color(0xfff7f6fb),
      backgroundColor:  Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 32),
          child: Column(
            children: [
              const SizedBox(
                height: 40,
              ),
              Container(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height/2,
                  maxWidth: MediaQuery.of(context).size.width
                ),
                child: 
                // Image.asset(
                //   'assets/images/illustration-111.png',
                // ),
                 SizedBox(
                   width: double.infinity,
                   child: Text("Create\nYour\nAccount", 
                   style: TextStyle(
                     fontSize: MediaQuery.of(context).size.height/13,
                     fontWeight: FontWeight.bold,
                
                   ),),
                 )
              ),
              const SizedBox(
                height: 40,
              ),
              Container(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height/2,
                  maxWidth: MediaQuery.of(context).size.width
                ),
                
                child: Icon(
                  Icons.mobile_friendly, 
                  size: MediaQuery.of(context).size.height/10,)
                  ),
                  const SizedBox(
                height: 40,
              ),
                const Text(
                "Let's get started",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                "Create your account using Mobile Number",
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Colors.black38,
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(
                height: 38,
              ),
              
              Container(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height,
                  maxWidth: MediaQuery.of(context).size.width/2
                ),
                child: SizedBox(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => const PhoneNumber()),
                      );
                    },
                    style: ButtonStyle(
                      foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.white),
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.deepPurpleAccent.shade700),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(14.0),
                      child: Text(
                        'Create Account',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 22,
              ),
            ],
          ),
        ),
      ),
    );
  }
}