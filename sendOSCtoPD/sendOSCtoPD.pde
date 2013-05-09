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
NetAddress remote;
NetAddress local;

String server="danielmahal.local";
String name="Sound Cylinder";
String description ="x";

Spacebrew sb;

void setup(){
  size(400,400);
  bg = loadImage("bg.jpg");
  
  sb = new Spacebrew( this );
 
  sb.addSubscribe("Gun angle", "range");
  sb.addSubscribe("Gun fire", "boolean"); 
  sb.addSubscribe("Bird angle","range");
  sb.addPublisher("Bird trigger","boolean");
  sb.addPublisher("Bird hit","boolean");
  sb.addPublisher("Bird missed","boolean");
  
  sb.connect(server, name, description );
  
  oscP5 = new OscP5(this,12000);
  local = new NetAddress("127.0.0.1",12000);
  remote = new NetAddress("danielmahal.local",12000);
}


void draw(){
    background(0);
    
    pushMatrix();
    translate(200,-81);
    //rotate(radians(45));
    rotate(QUARTER_PI);
    image(bg, 0, 0);  
    popMatrix();
  
  stroke(255);  
  line(200, 200, mouseX, mouseY);
  
  //println(angle);
  fill(255);
  text( angle, 100, 100);

  if (angle == PI) {
    text("PIE", 100, 150);
  }
  
  
}

void onRangeMessage( String name, int value ){
//  OscMessage myMessage = new OscMessage("/sound");
//  myMessage.add(value);
//  oscP5.send(myMessage, myRemoteLocation);
}

void mouseMoved() {
    angle = atan2(mouseY-200, mouseX-200) - QUARTER_PI;
    
    OscMessage myMessage = new OscMessage("/sound");
    myMessage.add(angle);
    oscP5.send(myMessage, remote);
    oscP5.send(myMessage, local);
}

void mousePressed() {
  OscMessage myMessage = new OscMessage("/start");
  oscP5.send(myMessage, remote);
 oscP5.send(myMessage, local); 
}
