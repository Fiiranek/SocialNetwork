import 'package:art_platform/screens/other/input_decoration.dart';
import 'package:art_platform/screens/other/loading.dart';
import 'package:art_platform/screens/other/signin_decoration.dart';
import 'package:art_platform/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SignUp extends StatefulWidget {
  final Function toggleView;
  SignUp({this.toggleView});

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  String name = '';
  String surname = '';
  String email = '';
  String password = '';
  String passwordRepeat = '';
  String error = '';


  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    Widget bckg = SvgPicture.asset('assets/bckg.svg');
    return loading
        ? Loading()
        : Scaffold(
            body: SingleChildScrollView(
            child: Container(
              width: screenWidth,
              height: screenHeight,
              decoration: signInDecoration,
              child: 
                  Container(
                    padding: EdgeInsets.all(20),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Image.asset('assets/logo.png',width: 140,),
                          SizedBox(height: 10),

                          // name textfield
                          TextFormField(
                            style: inputTextStyle,
                            keyboardType: TextInputType.text,
                            decoration: signUpInputDecoration.copyWith(
                                prefixIcon: Icon(Icons.person,color: Color(0xff820000)),
                                hintText: 'Name'),
                            validator: (val) =>
                                val.isEmpty ? 'Field is empty' : null,
                            onChanged: (val) {
                              if(mounted){
                                setState(() => name = val);
                              }
                              
                            },
                          ),
                          SizedBox(height: 10),

                          // surname textfield
                          TextFormField(
                            style: inputTextStyle,
                            keyboardType: TextInputType.text,
                            decoration: signUpInputDecoration.copyWith(
                                prefixIcon: Icon(Icons.person,color: Color(0xff820000)),
                                hintText: 'Surname'),
                            validator: (val) =>
                                val.isEmpty ? 'Field is empty' : null,
                            onChanged: (val) {
                              if(mounted){
                                setState(() => surname = val);
                              }
                            },
                          ),
                          SizedBox(height: 10),


                          // email textfield
                          TextFormField(
                            style: inputTextStyle,
                            keyboardType: TextInputType.emailAddress,
                            decoration: signUpInputDecoration.copyWith(
                                prefixIcon: Icon(Icons.email,color: Color(0xff820000)),
                                hintText: 'Email'),
                            validator: (val) =>
                                val.isEmpty ? 'Field is empty' : null,
                            onChanged: (val) {
                              setState(() => email = val);
                            },
                          ),
                          SizedBox(height: 10),
                          // password textfield
                          TextFormField(
                            style: inputTextStyle,
                            decoration: signUpInputDecoration.copyWith(
                                prefixIcon: Icon(Icons.lock,color: Color(0xff820000),),
                                hintText: 'Password'),
                            validator: (val) => val.length < 6
                                ? 'Password must be longer than 6 characters'
                                : null,
                            onChanged: (val) {
                              setState(() => password = val);
                            },
                            obscureText: true,
                          ),

                          // repeat password
                          SizedBox(height: 10),
                          TextFormField(
                            style: inputTextStyle,
                            decoration: signUpInputDecoration.copyWith(
                                prefixIcon: Icon(Icons.lock,color: Color(0xff820000)),
                                hintText: 'Repeat password'),
                            validator: (val) => passwordRepeat == password
                                ? null
                                : 'Passwords must be the same',
                            onChanged: (val) {
                              setState(() => passwordRepeat = val);
                            },
                            obscureText: true,
                          ),
                          SizedBox(height: 20),
                          GestureDetector(
                            onTap: () {
                              widget.toggleView();
                            },
                            child: Text('Have an account? Sign in!',style: createAccountText,),
                          ),
                          SizedBox(height: 20),
                          GestureDetector(
                            onTap: () async {
                              if (_formKey.currentState.validate()) {
                                setState(() => loading = true);
                                dynamic result =
                                    await _auth.registerWithEmailAndPassword(
                                        email, password, name, surname);
                                if (result == null) {
                                  setState(() {
                                    error = 'Something went wrong!';
                                    loading = false;
                                  });
                                }
                              }
                            },
                            child: Container(
                               margin: EdgeInsets.symmetric(horizontal: 30),
                                padding: EdgeInsets.all(10),
                                alignment: Alignment.center,
                                decoration: signInButtonDecoration,
                                child: Text(
                                  'Sign up',
                                  style: signInButtonText,
                                )),
                          ),
                          SizedBox(
                              height: 20,
                              ),
                              Text(
                                error,
                                style:
                                    TextStyle(color: Colors.red, fontSize: 14),
                              )
                        ],
                      ),
                    ),
                  )
            ),
          ));
  }
}
