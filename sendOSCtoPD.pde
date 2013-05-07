boolean hit = false;
import spacebrew.*;
import oscP5.*;
import netP5.*;


import controlP5.*;

ControlP5 cp5;

float randomValue = 0;
int value = 0;

OscP5 oscP5;
NetAddress myRemoteLocation;
//String server="sandbox.spacebrew.cc";
String server="danielmahal.local";
String name="Gomakeussomesounds";
String description ="x";

Spacebrew sb;

void setup(){
  
  //size(displayWidth,displayHeight);
  size(400,200);
  background(0);  
  cp5 = new ControlP5(this);
  cp5.addSlider("value")
     .setPosition(0,50)
     .setSize(400,50)
     .setRange(0,1024)
     .setSliderMode(Slider.FLEXIBLE)

     ;
    
  
  sb = new Spacebrew( this );
  sb.addSubscribe( "direction","range");
  sb.connect(server, name, description );
  
  oscP5 = new OscP5(this,12000);
  myRemoteLocation = new NetAddress("127.0.0.1",12000);
  
  //frameRate(1);
 
}


void draw(){
  //OscMessage myMessage = new OscMessage("/sound");
  //myMessage.add(value);
  //oscP5.send(myMessage, myRemoteLocation);
}

void onRangeMessage( String name, int value ){
//  println("got boolean message " + name + " : " + value); 
//  hit = value; 
//  OscMessage myMessage = new OscMessage("/test ");
//  myMessage.add(1);
//  oscP5.send(myMessage, myRemoteLocation);
  OscMessage myMessage = new OscMessage("/sound");
  myMessage.add(value);
  oscP5.send(myMessage, myRemoteLocation);

}
