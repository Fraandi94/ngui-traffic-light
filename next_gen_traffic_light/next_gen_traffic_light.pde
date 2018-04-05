import java.awt.Frame;
import java.awt.BorderLayout;
import com.heroicrobot.dropbit.registry.*;
import com.heroicrobot.dropbit.devices.pixelpusher.Pixel;
import com.heroicrobot.dropbit.devices.pixelpusher.Strip;
import java.util.*;
import com.dhchoi.CountdownTimer;
import com.dhchoi.CountdownTimerService;
import controlP5.*;

ControlFrame cf;
ControlP5 cp5;
CountdownTimer timer;
DeviceRegistry registry;
TestObserver testObserver;

int col;
float runTime;
int variation;
float timeLeft;
boolean running;

void setup() {
  size(320, 320, OPENGL);
  background(0);
  frameRate(24);
  smooth();
  
  registry = new DeviceRegistry();
  testObserver = new TestObserver();
  registry.addObserver(testObserver);

  cp5 = new ControlP5(this);
  cf = new ControlFrame(this);
  col = color(255, 0, 0);
  variation = 1;
  timeLeft = -90;
  runTime = 15;
  running = false;
  timer = CountdownTimerService.getNewCountdownTimer(this).configure(100, 15000);
}

void draw() {
  background(0);
  if (running && timer.isRunning()) {
    switch(variation) {
      case 1:
        noStroke();
        fill(col);
        ellipse(width/2, height/2, width*0.9, height*0.9);
        break;
      case 2:
        noStroke();
        fill(col);
        ellipse(width/2, height/2, width, height);
        fill(0,0,0, 160);
        arc(width/2, height/2, width*0.45, height*0.45, radians(-90), radians(timeLeft));
        break;
      case 3:
        fill(col);
        noStroke();
        ellipse(width/2, width/2, width*0.7, height*0.7);
        noFill();
        stroke(col);
        strokeWeight(15);
        arc(width/2, width/2, width*0.9, height*0.9, radians(-90), 2*PI);
        stroke(0, 0, 0, 200);
        fill(col);
        arc(width/2, width/2, width*0.9, height*0.9, radians(-90), radians(timeLeft));
        break;
      case 4:
        float s_13 = map(timeLeft, 0, 360, 0, TWO_PI);
        stroke(0);
        strokeWeight(15);
        line(width/2, height/2, width/2 + cos(s_13) * width, height/2 + sin(s_13) * height);
        fill(col);
        noStroke();
        ellipse(width/2, width/2, width, height);
        noStroke();
        fill(0, 0, 0, 160);
        arc(width/2, height/2, width*0.8, height*0.8, radians(-90), radians(timeLeft));
        stroke(0);
        strokeWeight(2);
        line(width/2, height/2, width/2, height*0.1);
        break;
      case 5:
        fill(col);
        noStroke();
        ellipse(width/2, width/2, width, height);
        noStroke();
        fill(0, 0, 0, 160);
        ellipse(width/2, height/2, 90+timeLeft*0.88, 90+timeLeft*0.88);
        break;
      case 6:
        fill(col);
        noStroke();
        ellipse(width/2, width/2, width, height);
        fill(0,0,0, 160);
        noStroke();
        ellipse(width/2, width/2, width, height);
        noStroke();
        fill(col);
        ellipse(width/2, height/2, 325-(90 + timeLeft*0.88), 325-(90 + timeLeft*0.88));
        break;
    }
  }   

  if (testObserver.hasStrips) {
      registry.startPushing();
      registry.setAutoThrottle(true);
      registry.setAntiLog(true);
      int stripy = 0;
      List<Strip> strips = registry.getStrips();
      
      if (strips.size() > 0) {
        int yscale = height / strips.size();
        for(Strip strip : strips) {
          int xscale = width / strip.getLength();
          for (int stripx = 0; stripx < strip.getLength(); stripx++) {
              color c = get(stripx*xscale, stripy*yscale);
          
              strip.setPixel(c, stripx);
           }
          stripy++;
        }
      }
  }
}


// Change Color
void toggleColor(boolean theFlag) {
  if (theFlag==true) {
    col = color(255, 0, 0);
  } else {
    col = color(0, 255, 0);
  }
}

// Change FrameRate
void toggleFrameRate(boolean theFlag) {
  if (theFlag==true) {
    frameRate(10);
  } else {
    frameRate(1);
  }
}

// Start/Stop Timer
void toggleTimer(ControlEvent theEvent) {
  if (theEvent.getValue() == 1.0) {
    startTimer();
    running = true;
    timeLeft = -90;
  } else {
    stopTimer();
    running = false;
  }
}

// Set Design
void setVariation(ControlEvent theEvent) {
  variation = int(theEvent.getValue());
}

void setRunTime(ControlEvent theEvent) {
  runTime = theEvent.getValue();
  setTimer(runTime);
  ControlP5 cfcontrol = cf.control();
  cfcontrol.getController("running").setValue(0.0);
}

void setTimer(float time) {
  stopTimer();
  timer.configure(100, int(time)*1000);
}

void startTimer() {
  timer.start();
}

void stopTimer() {
  timer.stop();
  timer.reset();
}

void onTickEvent(int timerId, long timeLeftUntilFinish) {
  timeLeft = timeLeft + (360/(runTime*10));
  // println("Time: " +timeLeftUntilFinish);
}

void onFinishEvent(int timerId) {
  running = false;
  ControlP5 cfcontrol = cf.control();
  cfcontrol.getController("running").setValue(0.0);
}

void keyPressed () {
  if (key == 's') {
    save ("capture" + variation + ".png");
  }
}

