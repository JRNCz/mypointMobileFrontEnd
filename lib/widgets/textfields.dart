import 'package:flutter/material.dart';

class buildText extends StatelessWidget {
  const buildText({
    super.key,
    required TextEditingController controller,
    required String text,
    required Icon icon,
  })  : _userNameEmail = controller,
        texticon = icon,
        hinttext = text;

  final TextEditingController _userNameEmail;
  final String hinttext;
  final Icon texticon;

  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: TextInputType.emailAddress,
      controller: _userNameEmail,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(vertical: 10),
        hintText: hinttext,
        border: const OutlineInputBorder(),
        prefixIcon: texticon,
        labelText: hinttext,
        suffixIcon: IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            _userNameEmail.clear();
          },
        ),
      ),
    );
  }
}

// statefull e setstate
class buildTextPassword extends StatefulWidget {
  buildTextPassword({
    super.key,
    required TextEditingController userPassword,
  }) : _userPassword = userPassword;

  final TextEditingController _userPassword;

  @override
  State<buildTextPassword> createState() => _buildTextPasswordState();
}

class _buildTextPasswordState extends State<buildTextPassword> {
  bool isPasswordVisable = true;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget._userPassword,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(vertical: 10),
        hintText: "your password",
        border: const OutlineInputBorder(),
        prefixIcon: const Icon(Icons.password),
        labelText: 'Password',
        suffixIcon: IconButton(
          icon: isPasswordVisable
              ? const Icon(Icons.visibility)
              : const Icon(Icons.visibility_off),
          onPressed: () {
            setState(() {
              isPasswordVisable = !isPasswordVisable;
            });
          },
        ),
      ),
      obscureText: isPasswordVisable,
    );
  }
}
