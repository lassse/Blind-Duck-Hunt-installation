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

//String server="danielmahal.local";
String server="spacebrew.local";
String name="Sound Cylinder";
String description ="x";

Spacebrew sb;

void setup() {
  size(400, 400);
  bg = loadImage("bg.jpg");

  sb = new Spacebrew( this );

  sb.addSubscribe("Gun trigger", "boolean"); 
  sb.addSubscribe("Bird angle", "range");
  sb.addSubscribe("Bird flying", "boolean");
  sb.addSubscribe("Bird hit", "boolean");
  sb.addSubscribe("Bird missed", "boolean");

  sb.connect(server, name, description );

  oscP5 = new OscP5(this, 12000);
  local = new NetAddress("127.0.0.1", 12000);
  remote = new NetAddress("lassekorsgaard.local", 12000);
}


void draw() {
  background(0);

  pushMatrix();
  translate(200, -81);
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

void onBooleanMessage(String name, boolean value) {
  println("Got boolean message: " + name + " " + value);

  if (name.equals("Gun trigger") && value ) {
    println ("gun fired!");
    gunTrigger();
  }

  if (name.equals("Bird flying") && value) {
    println ("bird flying!");
    birdFlying();
  }

  if (name.equals("Bird hit") && value) {
    println ("bird shot!");
    birdHit();
  }

  if (name.equals("Bird missed") && value) {
    println ("bird missed!");
    birdMissed();
  }
}

void onRangeMessage( String name, int value ) {
  println("Got range message: " + name + " " + value);

  if (name.equals("Bird angle")) {
    float angle = map (value, 0, 1024, 0, TWO_PI); 
    birdAngle(angle);
    println ("Bird angle!");  
  }
}


//  OscMessage myMessage = new OscMessage("/sound");
//  myMessage.add(value);
//  oscP5.send(myMessage, myRemoteLocation);

void birdAngle(float angle) {

  OscMessage birdAngle = new OscMessage("/birdAngle");
  birdAngle.add(angle);
  sendMessage(birdAngle);
}

void birdFlying() {
  OscMessage birdFlying = new OscMessage("/birdFlying");
  sendMessage(birdFlying);
}

void gunTrigger() { 
  OscMessage gunTrigger = new OscMessage("/gunTrigger");
  sendMessage(gunTrigger);
}

void birdHit() {
  OscMessage birdHit = new OscMessage("/birdHit");
  sendMessage(birdHit);
}

void birdMissed() {
  OscMessage birdMissed = new OscMessage("/birdMissed");
  sendMessage(birdMissed);
}


void sendMessage(OscMessage message) {
  oscP5.send(message, remote);
  oscP5.send(message, local);
}

