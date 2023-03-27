import 'package:chat/widgets/Picker/user_image_picker.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'dart:io';

class AuthForm extends StatefulWidget {
  AuthForm(this.submitFn, this.isLoading);
  final void Function(
    String email,
    String username,
    File? image,
    String password,
    bool isLogin,
    BuildContext ctx,
  ) submitFn;
  bool isLoading;
  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();

  var _isLogin = true;

  String _userEmail = '';
  String _userName = '';
  String _userPassword = '';
  File? _userImage;

  bool _passwordValidator(String value) {
    RegExp regExp =
        RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');

    if (!regExp.hasMatch(value)) {
      return true;
    }

    return false;
  }

  void _trySubmit() {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context)
        .unfocus(); //move the focus away from any input field to nothing. bascially closes the soft keyboard.

    if (_userImage == null && !_isLogin) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please pick an image.'),
        backgroundColor: Theme.of(context).colorScheme.error,
      ));
      return;
    }

    if (isValid) {
      _formKey.currentState!.save();
      widget.submitFn(
        _userEmail,
        _userName,
        _userImage,
        _userPassword,
        _isLogin,
        context,
      );
    }
  }

  void _pickedImage(File image) {
    _userImage = image;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Card(
      color: Theme.of(context).colorScheme.background,
      margin: const EdgeInsets.all(20),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!_isLogin) UserImagePicker(_pickedImage),
                  TextFormField(
                    key: ValueKey('email'),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value!.isEmpty || !EmailValidator.validate(value)) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      labelText: 'Email Address',
                    ),
                    onSaved: (value) {
                      _userEmail = value!.trim();
                    },
                  ), //email

                  if (!_isLogin)
                    TextFormField(
                      key: ValueKey('username'),
                      validator: (value) {
                        if (value!.isEmpty || value.length < 4) {
                          return 'Please enter a valid username';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        labelText: 'Username',
                      ),
                      onSaved: (value) {
                        _userName = value!.trim();
                      },
                    ), //username
                  TextFormField(
                    key: ValueKey('password'),
                    validator: (value) {
                      if (value == null || _passwordValidator(value)) {
                        return 'Enter a valid password.';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      hintText:
                          'Min 1 Upper case, Min 1 lowercase, Min 1 Numeric Number, Min 1 Special Character.',
                      hintStyle: TextStyle(fontSize: 9),
                      labelText: 'Password',
                    ),
                    obscureText: true,
                    onSaved: (value) {
                      _userPassword = value!;
                    },
                  ),
                  //password
                  SizedBox(
                    height: 12,
                  ),

                  if (widget.isLoading) CircularProgressIndicator(),
                  if (!widget.isLoading)
                    ElevatedButton(
                      onPressed: _trySubmit,
                      child: Text(_isLogin ? 'Login' : 'Signup'),
                    ),
                  if (!widget.isLoading)
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _isLogin = !_isLogin;
                        });
                      },
                      child: Text(_isLogin
                          ? 'Create new account'
                          : 'I already have an account'),
                    ),
                ],
              )),
        ),
      ),
    ));
  }
}
