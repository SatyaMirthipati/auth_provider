import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../bloc/auth_bloc.dart';
import '../../../data/local/shared_prefs.dart';
import '../../../resources/images.dart';
import '../../widgets/error_snackbar.dart';
import '../../widgets/navbar_button.dart';
import '../home/home_screen.dart';

class LoginScreen extends StatefulWidget {
  static Future open(BuildContext context) {
    return Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      ),
      (_) => false,
    );
  }

  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final formKey = GlobalKey<FormState>();

  final loginIdCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();
  bool showPassword = false;

  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 2),
    vsync: this,
  );

  late final CurvedAnimation _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.fastOutSlowIn,
  );

  @override
  void initState() {
    super.initState();
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    var primaryColor = Theme.of(context).primaryColor;
    var authBloc = Provider.of<AuthBloc>(context, listen: false);
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const SizedBox(height: 40),
            Image.asset(
              Images.logo,
              height: 100,
              alignment: Alignment.centerLeft,
            ),
            const SizedBox(height: 40),
            SizeTransition(
              sizeFactor: _animation,
              child: Text(
                'Login to your account',
                style: textTheme.titleLarge,
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              style: textTheme.titleMedium,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(labelText: 'Username'),
              validator: (text) {
                if (text?.trim().isEmpty ?? true) {
                  return 'This field cannot be empty';
                }
                return null;
              },
            ),
            const SizedBox(height: 25),
            TextFormField(
              style: textTheme.titleMedium,
              obscureText: !showPassword,
              keyboardType: TextInputType.visiblePassword,
              decoration: InputDecoration(
                labelText: 'Password',
                suffixIcon: IconButton(
                  icon: Icon(
                    showPassword
                        ? Icons.visibility_off_rounded
                        : Icons.visibility_rounded,
                  ),
                  onPressed: () => setState(() => showPassword = !showPassword),
                ),
              ),
              validator: (text) {
                if (text?.trim().isEmpty ?? true) {
                  return 'This field cannot be empty';
                }
                return null;
              },
            ),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  return ErrorSnackBar.show(
                    context,
                    'Team will get back to you soon',
                  );
                },
                child: Text(
                  'Forgot Password?',
                  style: textTheme.titleMedium!.copyWith(
                    color: primaryColor,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            Text.rich(
              TextSpan(
                text: 'Create your account - ',
                style: textTheme.titleSmall,
                children: [
                  TextSpan(
                    text: 'Sign up',
                    style: textTheme.titleMedium!.copyWith(
                      color: primaryColor,
                      fontSize: 15,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        return ErrorSnackBar.show(
                          context,
                          'This is a upcoming feature, you will able use this in next release',
                        );
                      },
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
      extendBody: true,
      bottomNavigationBar: NavbarButton(
        onPressed: () async {
          // TODO: Create the body response to send the data to api.
          // TODO: Example body response to send server var body = {'username': loginIdCtrl.text, 'password': passwordCtrl.text };
          await authBloc.login(body: {});
          var token = await Prefs.getToken();
          if (token == null) {
            return ErrorSnackBar.show(
              context,
              'Login failed due to wrong credentials',
            );
          } else {
            return HomeScreen.open(context);
          }
        },
        child: const Text('Submit'),
      ),
    );
  }

  @override
  void dispose() {
    _animation.dispose();
    _controller.dispose();
    super.dispose();
  }
}
