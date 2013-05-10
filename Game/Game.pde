import spacebrew.*;
import controlP5.*;

//String server = "danielmahal.local";
String server = "spacebrew.local";
//String server = "sandbox.spacebrew.cc";
String name = "Duck hunt";
String description = "Game logic";

Spacebrew sb;
ControlP5 cp5;

int birdLifeSpan = 2000; 
float hitTolerance = 0.5;

float birdAngle = 0;
int birdDeathTime = 0;
boolean birdAlive = false;

float gunAngle = 0;
float gunAngleOffset = 0;
float gunMinAngle = 0;
float gunMaxAngle = 0;

int spawnTime;

float gunTrailAngle = 0;
int gunTrailTime = 0;

void setup() {
    size(displayWidth, displayHeight);
    frameRate(60.0);
    
    cp5 = new ControlP5(this);
    
    cp5.addSlider("hitTolerance").setPosition(20,20).setSize(120,30).setRange(0,1);
    cp5.addSlider("birdLifeSpan").setPosition(20,60).setSize(120,30).setRange(0, 10000).setValue(2000);
    
    sb = new Spacebrew(this);
    
    sb.addPublish("Bird angle", "range", 0);
    sb.addPublish("Bird trigger", "boolean", false);
    sb.addPublish("Bird hit", "boolean", false);
    sb.addPublish("Bird missed", "boolean", false);
    
    sb.addSubscribe("Gun angle", "range");
    sb.addSubscribe("Gun fire", "boolean");
    
    sb.connect(server, name, description);
    
    spawnTime = timeFromNow(random(2000, 4000));
}

void update() {
    gunMinAngle = gunAngle - hitTolerance;
    gunMaxAngle = gunAngle + hitTolerance;
        
    if(birdAlive && birdDeathTime - millis() < 0) {
        birdAlive = false;
        spawnTime = timeFromNow(random(3000, 6000));
    }
    
    if(!birdAlive && spawnTime - millis() < 0) {
        spawnBird(random(0.0, TWO_PI));
    }
}

void draw() {
    background(0);
    
    update();
    
    pushMatrix();
    translate(width / 2, height / 2);
    textAlign(CENTER);
    
    if(birdAlive) {
        int x = int(cos(birdAngle) * 300);
        int y = int(sin(birdAngle) * 300);
        
        stroke(255, 0, 0);
        line(0, 0, x, y);
        
        noStroke();
        
        pushMatrix();
        translate(x, y);
        ellipse(0, 0, 20, 20);
        text("Bird", 0, 30);
        popMatrix();
    }
    
    fill(255);
    
    int x = int(cos(gunAngle) * 200);
    int y = int(sin(gunAngle) * 200);
    
    stroke(0, 0, 255);
    line(0, 0, x, y);
    
    stroke(0, 255, 255);
    
    PVector minPoint = new PVector(cos(gunMinAngle) * 100, sin(gunMinAngle) * 100);
    PVector maxPoint = new PVector(cos(gunMaxAngle) * 100, sin(gunMaxAngle) * 100);
    
    line(0, 0, minPoint.x, minPoint.y);
    line(0, 0, maxPoint.x, maxPoint.y);
    
    pushMatrix();
    noStroke();
    translate(x, y);
    ellipse(0, 0, 10, 10);
    text("Gun", 0, 20);
    popMatrix();
    
    if(gunTrailTime - millis() > 0) {
        fill(0, 0, 255, 127);
        beginShape();
        vertex(0, 0);
        vertex(cos(gunTrailAngle - hitTolerance) * 1000, sin(gunTrailAngle - hitTolerance) * 1000);
        vertex(cos(gunTrailAngle + hitTolerance) * 1000, sin(gunTrailAngle + hitTolerance) * 1000);
        vertex(0, 0);
        endShape();
    }
    
    popMatrix();
}

int timeFromNow(int time) {
    return millis() + time;
}

int timeFromNow(float time) {
    return millis() + int(time);
}

void gunFired() {
    gunTrailAngle = gunAngle;
    gunTrailTime = timeFromNow(200);
    
    if(!birdAlive) return;
    
    boolean hit = isAngleBetween(birdAngle, gunMinAngle, gunMaxAngle);
    
    if(hit) {
        sb.send("Bird hit", true);
        spawnTime = timeFromNow(random(3000, 6000));
        birdAlive = false;
    } else {
        sb.send("Bird missed", true);   
    }
}

boolean isAngleBetween(float angleRad, float minRad, float maxRad) {
    float angle = wrapNumber(degrees(angleRad), 360);
    float min = wrapNumber(degrees(minRad), 360);
    float max = wrapNumber(degrees(maxRad), 360);
    
    if(min < max) {
        return min <= angle && angle <= max;
    } else {
        return min <= angle || angle <= max;    
    }
}

float wrapNumber(float value, float wrap) {
    return (wrap + value % wrap) % wrap;
}

void spawnBird(float angle) {
    birdAngle = angle;
    birdDeathTime = timeFromNow(birdLifeSpan);
    birdAlive = true;
    
    sb.send("Bird angle", int(map(birdAngle, 0, TWO_PI, 0, 1023)));
    sb.send("Bird trigger", true);
    
    println("Spawn bird!");
}

void mouseMoved() {
    gunAngle = atan2(mouseY - width / 2, mouseX - width / 2);
}

void mousePressed() {
//    gunFired();
    gunAngleOffset = gunAngle;
}

void onRangeMessage(String name, int value) {
    if(name.equals("Gun angle")) {
        gunAngle = map(value, 0, 1023, 0, TWO_PI) + gunAngleOffset;
    }
}

void onBooleanMessage(String name, boolean value) {
    println("Got boolean message: " + name + " " + value);
    
    if(name.equals("Gun fire") && value) {
        gunFired();
    }
}
