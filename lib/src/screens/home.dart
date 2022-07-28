import 'package:flutter/material.dart';
import '../widgets/cat.dart';
import 'dart:math';

class Home extends StatefulWidget{
  HomeState createState() => HomeState();

}

class HomeState extends State<Home> with TickerProviderStateMixin {
  late Animation<double> catAnimation;
  late AnimationController catController;
  late Animation<double> boxAnimation;
  late AnimationController boxController;
  
  //anytime a new instance of HomeState is created initState is automatically invoked which makes it a perfect place to do some initial setup of the different variables that we defined in side our class....it's only available for classes that extends off of State based class...like State<Home>...it's already defined on the base State class so if we want to define it again we have to call the original implementation of the initState that is defined on the base class...
  initState(){
    super.initState();

    boxController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
    boxAnimation = Tween(begin: pi* 0.6, end: pi* 0.65).animate(
      CurvedAnimation(
        parent: boxController,
        curve: Curves.easeInOut,
      ),
    );
    boxAnimation.addStatusListener((status){
      if(status == AnimationStatus.completed){
        boxController.reverse(); //resets the animation value back to its beginning value 
      }
      else if(status == AnimationStatus.dismissed){
        boxController.forward();
      }

    });
    boxController.forward();



    catController = AnimationController( 
      duration: Duration(milliseconds: 200),
      //tickerprovider is kinda a handle from the outside world into our widget that gives the outside world or flutter the ability to reach in and tell our animation to kind of progress along and essentially render the next frame of our animation...notice how it is imported like a mixin...cuz it acts as a link  
      vsync: this,
    );

    catAnimation = Tween(
      begin: -35.0,
      end: -80.0
    ).animate(
      CurvedAnimation(
        parent: catController,
        curve: Curves.easeIn,
      ),
    );

  }

  onTap(){
    // boxController.stop();
    if(catController.status == AnimationStatus.completed){
      catController.reverse();
      boxController.forward();
    }
    else if(catController.status == AnimationStatus.dismissed){
      catController.forward();
      boxController.stop();
    }
  }

  Widget build(context){
    return Scaffold(
      appBar: AppBar(
        title: Text('Animation!'),
      ),
      body: GestureDetector(
        //anytime a user taps on anything that is a child of this gesture detector widget that tap event is essentially going to bubble up until it gets to this gesture detector...and that will then trigger the ontap callback...
        child: Center(
          child: Stack( //we use this widget to stack the widgets on top of each other...the cat and the box
            children: [
              buildCatAnimation(),
              buildBox(),
              buildLeftFlap(),
              buildRightFlap(),
            ],
            overflow: Overflow.visible,
          ),
        ),
        onTap: onTap,
      ),
    );
  }

  Widget buildCatAnimation(){
    return AnimatedBuilder( //animatedbuilder makes the builder function of the animation...it fires the animation every time the state of the animation changes 
    
      animation: catAnimation,
      builder: (context, child){
        return Positioned(
          child: child!, //notice the ! that i put here....child on the right is of the type Widget? while on the left it's of the type Widget and so to tell explicitly that it is non null type(the right one) we put a !
          top: catAnimation.value,
          right: 0.0,
          left: 0.0,
        );
      },
      child: Cat(), //we recreate another instance of cat to pass on to the builder function so that the builder function doesnt have to create the entire thing again and again 60 times a minute or whatever the frequency is....this make so that now we can use the builder function to change specific parts of this Cat instance and not the entire thing..
    );
  }

  Widget buildBox(){ ///this is a helper widget that builds a box around the cat...we use the stack widget to stack them both on top of each other..this way we can simulate the cat being inside the box
    return Container(
      height: 200.0,
      width: 200.0,
      color: Color.fromARGB(255, 20, 119, 124),
    );
  }

  Widget buildLeftFlap(){

    return Positioned(
      left: 3.0,
      child: AnimatedBuilder(
        animation: boxAnimation,
        child: Container(
           height: 10.0,
           width: 125.0,
           color: Color.fromARGB(255, 14, 125, 138), //just for letting you see where this thing locates itself on the app cleary tostart off
        ),
        builder: (context, child){
          return Transform.rotate(
            child: child,
            alignment: Alignment.topLeft,
            angle: boxAnimation.value,
    
          );
        },
        
      ),
    );

    
  }

  Widget buildRightFlap(){

    return Positioned(
      right: 3.0,
      child: AnimatedBuilder(
        animation: boxAnimation,
        child: Container(
           height: 10.0,
           width: 125.0,
           color: Color.fromARGB(255, 22, 132, 128), //just for letting you see where this thing locates itself on the app cleary tostart off
        ),
        builder: (context, child){
          return Transform.rotate(
            child: child,
            alignment: Alignment.topRight ,
            angle: -boxAnimation.value, //the negative sign applies the rotation same as the left flap but now in the opposite direction
    
          );
        },
      ),
    );
  }

}






