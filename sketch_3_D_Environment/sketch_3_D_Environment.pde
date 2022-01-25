//3-D Environment
//Tommy Porter

import java.awt.Robot;
Robot rbt;
boolean skipFrame;

//colours
color white = #FFFFFF; //empty space
color black = #000000; //oak planks
color dullBlue = #7092BE; //mossy bricks

//textures
PImage diamond;
PImage mossyStone;
PImage leaves;
PImage oakLog;


//Map variables
int gridSize;
PImage map;

boolean wkey, akey, skey, dkey;
float eyeX,eyeY, eyeZ, focusX,focusY,focusZ,tiltX,tiltY,tiltZ;
float leftRightHeadAngle, upDownHeadAngle;

void setup() {
  size(displayWidth, displayHeight, P3D);
  diamond = loadImage("DiamondBlock.png");
  mossyStone = loadImage("mossyStone.png");
  leaves = loadImage("leaves.png");
  oakLog = loadImage("oakLog.png");
  textureMode(NORMAL);
  wkey = akey = skey = dkey = false;
  eyeX = width/2;
  eyeY = 9*height/10;
  eyeZ = 0;
  focusX = width/2;
  focusY = height/2;
  focusZ = 10;
  tiltX = 0;
  tiltY = 1;
  tiltZ = 0;
  leftRightHeadAngle = radians(270);
  noCursor();
  try {
    rbt = new Robot();
  }
  catch(Exception e) {
   e.printStackTrace(); 
  }
  
  skipFrame = false;
  //initialize map
  map = loadImage("map.png");
  gridSize = 100;
}


void draw() {
  background(0);
  pointLight(255,255,255,eyeX,eyeY,eyeZ);
  camera(eyeX,eyeY,eyeZ,focusX,focusY,focusZ,tiltX,tiltY,tiltZ);
  drawFloor(-2000,2000,height,gridSize);
  drawFloor(-2000,2000,height-gridSize*4,gridSize);
  drawFocalPoint();
  controlCamera();
  drawMap();
}

void drawMap() {
  for (int x = 0; x < map.width; x++) {
    for (int y = 0; y < map.height; y++) {
      color c =map.get(x,y);
      if (c == dullBlue) {
        texturedCube(x*gridSize-2000, height-gridSize, y*gridSize-2000, mossyStone, gridSize);
        texturedCube(x*gridSize-2000, height-gridSize*2, y*gridSize-2000, mossyStone, gridSize);
        texturedCube(x*gridSize-2000, height-gridSize*3, y*gridSize-2000, mossyStone, gridSize);
      }
      if (c == black) {
        texturedCube(x*gridSize-2000, height-gridSize, y*gridSize-2000, leaves, gridSize);
        texturedCube(x*gridSize-2000, height-gridSize*2, y*gridSize-2000, leaves, gridSize);
        texturedCube(x*gridSize-2000, height-gridSize*3, y*gridSize-2000, leaves, gridSize);
      }
    }
  }
  
  
  
}
void drawFloor(int start, int end, int level, int gap) {
  stroke(255);
  int x = start;
  int z = start;
  while(z < end) {
    texturedCube(x,level,z,oakLog,gap);
    x = x + gap;
    if (x >= 2000) {
      z = z + gap;
      x = start;
    }
  }
}




void drawFocalPoint() {
  pushMatrix();
  translate(focusX,focusY,focusZ);
  sphere(5);
  popMatrix();
}

void controlCamera() {
  if (wkey) {
    eyeX = eyeX + cos(leftRightHeadAngle)*10;
    eyeZ = eyeZ + sin(leftRightHeadAngle)*10;
  }
  if (skey) {
    eyeX = eyeX - cos(leftRightHeadAngle)*10;
    eyeZ = eyeZ - sin(leftRightHeadAngle)*10;
  }
  if (akey) {
    
    eyeX = eyeX - cos(leftRightHeadAngle + PI/2)*10;
    eyeZ = eyeZ - sin(leftRightHeadAngle + PI/2)*10;
  }
  if (dkey) {
    eyeX = eyeX - cos(leftRightHeadAngle - PI/2)*10;
    eyeZ = eyeZ - sin(leftRightHeadAngle - PI/2)*10;
  }
  
  if (skipFrame == false) {
   leftRightHeadAngle = leftRightHeadAngle + (mouseX - pmouseX)*0.01;
   upDownHeadAngle = upDownHeadAngle + (mouseY - pmouseY)*0.01;
  }
  
  if (upDownHeadAngle > PI/2.5) upDownHeadAngle = PI/2.5;
  if (upDownHeadAngle > -PI/2.5) upDownHeadAngle = -PI/2.5;
  
  focusX = eyeX + cos(leftRightHeadAngle)*300;
  focusZ = eyeZ + sin(leftRightHeadAngle)*300;
  focusY = eyeY + tan(upDownHeadAngle)*300;
  
  
  if (mouseX < 2){ 
    rbt.mouseMove(width-3,mouseY);
    skipFrame = true;
  } else if (mouseX > width-2){
    rbt.mouseMove(3,mouseY);
    skipFrame = true;
  } else {
    skipFrame = false;
  }
  
  
  println(eyeX,eyeY,eyeZ);
  
}

void keyPressed() {
  if (key == 'w' || key == 'W') wkey = true;
  if (key == 'a' || key == 'A') akey = true;
  if (key == 's' || key == 'S') skey = true;
  if (key == 'd' || key == 'D') dkey = true;
}


void keyReleased() {
  if (key == 'w' || key == 'W') wkey = false;
  if (key == 'a' || key == 'A') akey = false;
  if (key == 's' || key == 'S') skey = false;
  if (key == 'd' || key == 'D') dkey = false;
}
