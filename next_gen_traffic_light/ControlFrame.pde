import java.awt.Frame;
import java.awt.BorderLayout;

public class ControlFrame extends PApplet {
  ControlP5 cp5;
  Object parent;
  Frame f;
  Numberbox n;
  Toggle r;
  int w, h;

  public void setup() {
    size(w, h);
    frameRate(10);
    background(0);
    cp5 = new ControlP5(this);
    
    cp5.addToggle("toggleColor")
       .setPosition(10, 10)
       .setSize(50,20)
       .setValue(true)
       .plugTo(parent)
       .setMode(ControlP5.SWITCH)
       .setCaptionLabel("Color")
       ;
       
    cp5.addToggle("toggleFrameRate")
       .setPosition(10, 70)
       .setSize(50,20)
       .setValue(true)
       .plugTo(parent)
       .setMode(ControlP5.SWITCH)
       .setCaptionLabel("Smooth Ani.")
       ;
    
    n = cp5.addNumberbox("variation")
       .setPosition(10, 130)
       .setRange(1,6)
       .setSize(50, 20)
       .setValue(1)
       .setScrollSensitivity(1)
       .setDirection(Controller.HORIZONTAL)
       .plugTo(parent, "setVariation")
       .setCaptionLabel("Design")
       ;
    
    r = cp5.addToggle("running")
       .plugTo(parent, "toggleTimer")
       .setPosition(100, 100)
       .setSize(50, 50)
       .setValue(false)
       ;
       
    cp5.addKnob("runTime")
       .setPosition(100, 10)
       .setValue(15)
       .setRange(10,120)
       .setRadius(25)
       .setNumberOfTickMarks(22)
       .snapToTickMarks(true)
       .plugTo(parent, "setRunTime")
       ;
  }
  
  public void keyPressed () {
    switch(key) {
      case('1'): n.setValue(1); break;
      case('2'): n.setValue(2); break;
      case('3'): n.setValue(3); break;
      case('4'): n.setValue(4); break;
      case('5'): n.setValue(5); break;
      case('6'): n.setValue(6); break;
      case(' '): r.toggle(); break;
    }
  }

  public void draw() {
    background(0);
  }

  public ControlFrame(Object theParent) {
    parent = theParent;
    w = 200;
    h = 200;
    f = new Frame("LightControl");
    f.add(this);
    this.init();
    f.setTitle("LightControl");
    f.setSize(this.w, this.h);
    f.setLocation(100, 100);
    f.setResizable(false);
    f.setVisible(true);
  }
  
  public ControlP5 control() {
    return cp5;
  }
}

