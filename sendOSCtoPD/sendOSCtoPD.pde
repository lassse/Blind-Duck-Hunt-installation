float angle = 0;

PImage bg;

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
  
  size(400,400);
  bg = loadImage("bg.jpg");
//  cp5 = new ControlP5(this);
//  cp5.addSlider("value")
//     .setPosition(0,50)
//     .setSize(400,50)
//     .setRange(0,1024)
//     .setSliderMode(Slider.FLEXIBLE)
//
//     ;
    
  
//  sb = new Spacebrew( this );
//  sb.addSubscribe( "direction","range");
//  sb.connect(server, name, description );
  
  oscP5 = new OscP5(this,12000);
  myRemoteLocation = new NetAddress("127.0.0.1",12000);
}


void draw(){ 
  //background(0);
  image(bg, 0, 0);
  stroke(255);  
  line(200, 200, mouseX, mouseY);

  angle = atan2(mouseY-200, mouseX-200);
  //println(angle);
  fill(255);
  text( angle, 100, 100);

  if (angle == PI) {
    text("PIE", 100, 150);
  }
  
 // cp5.getController("value").setValue( value );
 
  OscMessage myMessage = new OscMessage("/sound");
  myMessage.add(angle);
  oscP5.send(myMessage, myRemoteLocation); 
}

void onRangeMessage( String name, int value ){
  OscMessage myMessage = new OscMessage("/sound");
  myMessage.add(value);
  oscP5.send(myMessage, myRemoteLocation);
}
