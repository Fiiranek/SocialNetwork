import 'package:art_platform/screens/other/input_decoration.dart';
import 'package:art_platform/screens/other/loading.dart';
import 'package:art_platform/screens/other/signin_decoration.dart';
import 'package:art_platform/services/auth.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;
  SignIn({this.toggleView});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

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

                          // email textfield
                          TextFormField(
                            style: inputTextStyle,
                            keyboardType: TextInputType.emailAddress,
                            decoration: signUpInputDecoration.copyWith(
                                prefixIcon: Icon(Icons.email,color: Color(0xff820000),),
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
                                prefixIcon: Icon(Icons.lock,color: Color(0xff820000)),
                                hintText: 'Password'),
                            validator: (val) => val.length < 6
                                ? 'Password must be longer than 6 characters'
                                : null,
                            onChanged: (val) {
                              setState(() => password = val);
                            },
                            obscureText: true,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          GestureDetector(
                            onTap: () {
                              widget.toggleView();
                            },
                            child: Text('Sign up!',style: createAccountText,),
                          ),
                          SizedBox(height: 20),
                          GestureDetector(
                            onTap: () async {
                              if (_formKey.currentState.validate()) {
                                setState(() => loading = true);
                                dynamic result =
                                    await _auth.signInWithEmailAndPassword(
                                        email, password);
                                if (result == null) {
                                  setState(() => error =
                                      'Please check password and email');
                                  loading = false;
                                }
                              }
                            },
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 30),
                                padding: EdgeInsets.all(10),
                                alignment: Alignment.center,
                                decoration: signInButtonDecoration,
                                child: Text(
                                  'Sign in',
                                  style: signInButtonText,
                                )),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            error,
                            style: TextStyle(color: Colors.red, fontSize: 14),
                          )
                        ],
                      ),
                    ),
                  )
            ),
          ));
    
  }
}
