String SAVE_PATH = "expand_#####.tif";

int NUMBER = 1000;                     // maximum number of circles to hold
int INTERVAL = 100;                    // ms, milliseconds
float TRANSP_REDUCE = 1.5;             // delta of transparency per frame
float RADIUS_EXPAND = 1.5;             // delta of radius per frame
boolean RADIUS_EXPAND_RAND = true;     // apply randomized shifting to radius
float PHASE_SHIFT = 0.4;               // phase shift per frame
float OVERLAY_BG_TRANSP = 10;          // background-fill transparency
boolean BOUNCE = true;                 // apply boucing to radius
float BG_FILLING_ALPHA = 100.0;        // switch filling mode
float BEAT_CONST = 10.0;               // bouncing const. bigger makes greater bounce

// define background color
int BG_R = 239;
int BG_G = 249;
int BG_B = 249;


Circle[] circles = new Circle[NUMBER];
int index = 0;
int lastUpdated = millis();

void setup() {
  size(600, 400);
  background(BG_R, BG_G, BG_B);

}

void draw() {
  translate(mouseX, mouseY);
  fillWithBgColor(BG_FILLING_ALPHA);
  
  if (index < NUMBER) {
    int current = millis();
    if (current - lastUpdated > INTERVAL) {
      circles[index] = new Circle(float(mouseX), float(mouseY), random(100));
      circles[index].setColor(random(255), random(255), random(255));
      index++;
      lastUpdated = current;
    }
    
    for (int i = 0; i < index; i++) {
      circles[i].move();
      circles[i].draw();
    }
  }
  
  saveFrame(SAVE_PATH);
}

void fillWithBgColor(float alpha) {
  noStroke();
  translate(-mouseX, -mouseY);
  fill(BG_R, BG_G, BG_B, alpha);
  rectMode(CORNER);
  rect(0, 0, width, height);
}

class Circle {
  float x, y;
  float radius;
  float r, g, b;
  float transp;
  float phase = 0.0;
  
  Circle(float _x, float _y, float _radius) {
    x = _x;
    y = _y;
    radius = _radius;
    transp = 100;
  }
  
  void setColor(float _r, float _g, float _b) {
    r = _r;
    g = _g;
    b = _b;
  }
  
  void move() {
    transp = max(transp - TRANSP_REDUCE, 0);
    
    if (RADIUS_EXPAND_RAND) {
      radius = radius + random(RADIUS_EXPAND * 2);
    } else {
      radius = radius + RADIUS_EXPAND;
    }
    
    if (BOUNCE) {
      phase = phase + PHASE_SHIFT;
      radius = radius + BEAT_CONST * cos(phase);
    }
  }
  
  void draw() {
    fill(r, g, b, transp);
    noStroke();
    ellipse(x, y, radius, radius);
  }
}
