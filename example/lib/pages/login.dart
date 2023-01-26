
import 'package:flutter/material.dart';
import '../app_routes.dart';

bool isLogged = false;

bool computerTest () {
  if (isLogged) {
    return isLogged;  
  } else {
    return isLogged;
  }
}

class Login extends StatelessWidget {
  const Login({ Key? key }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('login'),
      ),
      body: Center(
        child: ColoredBox(
          color: Theme.of(context).primaryColor.withOpacity(0.7),
          child: TextButton(
            onPressed: (){
              isLogged = true;
              CreatePageRoute.upgradeInitialRoute();
            },
            child: const Text(
              'AnyPage',
              style: TextStyle(
                fontSize: 25,
                color: Colors.white
              ),
            ),  
          ),
        )
      ),
    );
  }
}


