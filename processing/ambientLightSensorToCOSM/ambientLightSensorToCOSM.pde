/***************************
Ambient Light Sensor to COSM

example that sends light sensor data from a MBP to a COSM feed.
uses Ambient Light Sensor Library: http://code.google.com/p/ambientlightsensor/
and Cosm Processing Library: http://github.com/jmsaavedra/Cosm-Processing-Library

made for PICNIC 2012, Amsterdam, NL.

http://cosm.com
http://jos.ph
****************************/

import lmu.*;
import cosm.*;

int lmu_left;
int lmu_right;
float multi;

DataOut feed;

String apiKey = "YOUR_COSM_API_KEY";
String feedId = "76032";
//http://cosm.com/feeds/76032

long lastTime = 0;
int sendInterval = 1;

void setup()
{
  size(600, 600);
  // initial sensor values
  int[] lmu_start = LmuTracker.getLMUArray();
  lmu_left  = lmu_start[0];
  lmu_right = lmu_start[1];
  multi = 255.0 / (lmu_left);

  feed = new DataOut(this, apiKey, feedId);  //intantiate feed
  feed.setVerbose(false);  //optional debug info
} 

void draw() {

  if (millis() > lastTime + sendInterval*1000) { //timer
    // get current sensor values
    lastTime = millis();
    int[] vals = LmuTracker.getLMUArray();
    int l = (int)(vals[0] * multi); //left sensor
    int r = (int)(vals[1] * multi); //right sensor

    background(255);

    //use left sensor
    fill(l);
    rect(0, 0, width, height);

    feed.setStream("light", l); //send request (datastream id, new value)
    println(l); //look at number printed, then check your feed on cosm!
    fill(abs(300-l));
    text("current light value: ", 20, 20);
    text(l, 20, 40);
  }
}

