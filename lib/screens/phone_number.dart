
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:loginlogoutflutter/screens/home_screen.dart';


enum MobileVerificationState {
  showMobileFormState,
  showOtpFormState,
}

class PhoneNumber extends StatefulWidget {
  const PhoneNumber({ Key? key }) : super(key: key);

  @override
  _PhoneNumberState createState() => _PhoneNumberState();
}

class _PhoneNumberState extends State<PhoneNumber> {
MobileVerificationState currentState =
      MobileVerificationState.showMobileFormState;

  final phoneController = TextEditingController();
  final otpController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  late String verificationId;

  bool showLoading = false;


  void signInWithPhoneAuthCredential(
      PhoneAuthCredential phoneAuthCredential) async {
    setState(() {
      showLoading = true;
    });

    try {
      final authCredential =
          await _auth.signInWithCredential(phoneAuthCredential);

      setState(() {
        showLoading = false;
      });

      if(authCredential.user != null){
        Navigator.push(context, MaterialPageRoute(builder: (context)=>const HomeScreen()));
      }

    } on FirebaseAuthException catch (e) {
      setState(() {
        showLoading = false;
      });

      // _scaffoldKey.currentState
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message!)));
    }
  }
    String boldText = "Enter your mobile number with country code";
  String lightText = "Example : +[country code] [mobile number]";

  Widget getMobileFormWidget(context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xfff7f6fb),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 25),
          child: Column(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(
                    Icons.arrow_back,
                    size: 32,
                    color: Colors.black54,
                  ),
                ),
              ),
              
              const SizedBox(
                height: 18,
              ),
              // Container(
              //   width: 200,
              //   height: 200,
              //   decoration: BoxDecoration(
              //     color: Colors.deepPurple.shade50,
              //     shape: BoxShape.circle,
              //   ),
              //   child: Image.asset(
              //     'assets/images/illustration-2.png',
              //   ),
              // ),
              const SizedBox(
                height: 24,
              ),
              Text(
                'Registration',
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.height/20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
               const Text(
                "Add your phone number. we'll send you a verification code so we know you're real",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.black38,
                ),
                textAlign: TextAlign.center,
              ),
             const SizedBox(
                height: 20,
              ),
              const SizedBox(height: 30,),
              TextFormField(
                controller: phoneController,
                decoration: InputDecoration(
                  hintText: "Phone Number",
                  enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.black12),
                            borderRadius: BorderRadius.circular(10)),
                  focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.black12),
                            borderRadius: BorderRadius.circular(10)),
                            suffixIcon: showLoading
                                ? Transform.scale(
                                  scale: 0.4,
                                  child: const CircularProgressIndicator())
                                : 
                                currentState == MobileVerificationState.showMobileFormState
                            
                            ? const Icon(
                                Icons.check_circle,
                                color: Colors.grey
                        ) 
                        : 
                       const Icon(
                                Icons.check_circle,
                                color: Colors.green
                        ),)
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Ex : [+country code] [phone number]",
                style: TextStyle(
                  color: Colors.grey.shade800,
                  fontSize: 10
                ),
                ),
              ),
              const SizedBox(
                      height: 22,
                    ),
              SizedBox(
                width: MediaQuery.of(context).size.width/2.5,
                child: ElevatedButton(
                  onPressed: () async {
                    setState(() {
                      showLoading = true;
                    });
            
                    await _auth.verifyPhoneNumber(
                      phoneNumber: phoneController.text,
                      verificationCompleted: (phoneAuthCredential) async {
                        setState(() {
                          showLoading = false;
                        });
                        //signInWithPhoneAuthCredential(phoneAuthCredential);
                      },
                      verificationFailed: (verificationFailed) async {
                        setState(() {
                          showLoading = false;
                        });
                        // _scaffoldKey.currentState
                        ScaffoldMessenger.of(context)
                        .showSnackBar(
                          
                            SnackBar(content: Text(verificationFailed.message!)));
                      },
                      codeSent: (verificationId, resendingToken) async {
                        setState(() {
                          showLoading = false;
                          currentState = MobileVerificationState.showOtpFormState;
                          this.verificationId = verificationId;
                        });
                      },
                      codeAutoRetrievalTimeout: (verificationId) async {},
                    );
                  },
                   child: const Padding(
                          padding: EdgeInsets.all(14.0),
                          child: Text(
                            'Send',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                    style: ButtonStyle(
                          foregroundColor:
                              MaterialStateProperty.all<Color>(Colors.white),
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.deepPurpleAccent.shade700),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                          ),
                        ),
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ));
  }

  getOtpFormWidget(context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xfff7f6fb),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 32),
          child: Column(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(
                    Icons.arrow_back,
                    size: 32,
                    color: Colors.black54,
                  ),
                ),
              ),
              const SizedBox(
                height: 18,
              ),
              Container(
                constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width,
                maxHeight: MediaQuery.of(context).size.height,
                ),
                
                child: 
                // Image.asset(
                //   'assets/images/illustration-3.png',
                // ),
                Icon(Icons.mobile_friendly_rounded,
                size: MediaQuery.of(context).size.height/10,
                )
              ),
              const SizedBox(
                height: 24,
              ),
              const Text(
                'Verification',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                "Enter your OTP code number",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black38,
                  
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 28,
              ),
              TextField(
                controller: otpController,
                decoration: InputDecoration(
                  hintText: "Enter OTP",
                  enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.black12),
                            borderRadius: BorderRadius.circular(10)),
                  focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.black12),
                            borderRadius: BorderRadius.circular(10)),
                ),
                
              ),
              const SizedBox(
                height: 16,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width/2,
                child: ElevatedButton(
                  onPressed: () async {
                    PhoneAuthCredential phoneAuthCredential =
                        PhoneAuthProvider.credential(
                            verificationId: verificationId, smsCode: otpController.text);
      
                    signInWithPhoneAuthCredential(phoneAuthCredential);
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(14.0),
                    child: Text("VERIFY"),
                  ),
                  style: ButtonStyle(
                            foregroundColor:
                                MaterialStateProperty.all<Color>(Colors.white),
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.deepPurpleAccent.shade700),
                            shape:
                                MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                            ),
                          ),
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
            ),
      );
  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // key: _scaffoldKey,
        body: SingleChildScrollView(
          child: Container(
            constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height),
            child: 
            // showLoading
            //     ? const Center(
            //         child: CircularProgressIndicator(),
            //       )
            //     : 
                currentState == MobileVerificationState.showMobileFormState
                    ? getMobileFormWidget(context)
                    : getOtpFormWidget(context),
            padding: const EdgeInsets.all(16),
          ),
        ));
  }
}