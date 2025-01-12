import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final LocalAuthentication _auth = LocalAuthentication();
  bool _show = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildUI(),
      floatingActionButton: _button(),
    );
  }

  Widget _button() {
    return FloatingActionButton(
        onPressed: () async {
          if (!_show) {
            final bool canAuthenticateWithBiometrics =
                await _auth.canCheckBiometrics;
            if (canAuthenticateWithBiometrics) {
              try {
                final bool didAuthenticate = await _auth.authenticate(
                    localizedReason: "Please authenticate to view the balance",
                    options: const AuthenticationOptions(biometricOnly: false));
                setState(() {
                  _show = didAuthenticate;
                });
              } catch (e) {
                print(e);
              }
            }
            print(canAuthenticateWithBiometrics);
          } else {
            setState(() {
              _show = false;
            });
          }
        },
        child: Icon(_show ? Icons.lock : Icons.lock_open_sharp),
        backgroundColor: Colors.white);
  }

  Widget _buildUI() {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            "Biometric",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 35),
          ),
          if (_show)
            const Text(
              "",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 35),
            ),
          if (!_show)
            const Text(
              "*******",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 35),
            ),
        ],
      ),
    );
  }
}
