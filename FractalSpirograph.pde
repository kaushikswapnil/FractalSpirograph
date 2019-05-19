float coreCircleRadius = 150.0f;
float radiusMultiplier = 0.33;
int numCircles = 12;

int speedConstant = -4;

boolean isDebugModeOn = false;

ArrayList<PVector> path;

DrawerCircle drawer;

int hue = 50;

int childCreationStrategy = 2; //0 for outwards, 1 for inwards, 2 for alternative

boolean slideShowActive = true;
int timeSinceLastSlide = 0;
int timeBetweenSlideChange = 5000; //in ms

void setup()
{
  size(1600, 900);
  
  isDebugModeOn = false;

  colorMode(HSB, 255);
  
  Init();
}

void draw()
{
  background(0, 0, 50);
  stroke(255);
  noFill();
  
  if (slideShowActive && ((millis() - timeSinceLastSlide) >= timeBetweenSlideChange))
  {
     Reset();
  }

  drawer.Update();
  
  if (isDebugModeOn)
  {
    drawer.Display();
  }
  
  path.add(drawer.GetLeafCenter());
  
  stroke(hue, 255, 255);
  beginShape();
  for (PVector pos : path)
  {
      //stroke(map(noise((pos.x/1000) + noiseXMove, (pos.y/1000) + noiseYMove, noiseZMove), 0, 1, 0, 255), 255, 255);
      vertex(pos.x, pos.y);
  }
  endShape();
}

void keyPressed()
{
 if(key == ' ')
 {
   isDebugModeOn = !isDebugModeOn;
 }
 else if (key == 'r' || key == 'R')
 {
   Reset();
 }
}

void Reset()
{
  if (!slideShowActive)
  {
    slideShowActive = true;
  }
    
  timeSinceLastSlide = millis();
  
  numCircles = (int)random(3, 30);
  path = new ArrayList<PVector>();
  
  coreCircleRadius = random(125,225);
  
  radiusMultiplier = random(0.3, 0.6);
  
  childCreationStrategy = (int)random(0,3);
  
  do
  {
    speedConstant = (int)random(-10, 10);
  } while (speedConstant >= -1 && speedConstant <= 1);
  
  hue = (int)random(0,256);
  
  Init();
}

void Init()
{ 
  drawer = new DrawerCircle(width/2, height/2, coreCircleRadius, 0, 0, null, null);
  
  DrawerCircle current = drawer;
  for (int iter = 0; iter < numCircles-1; ++iter)
  {
    current.CreateNewChild();
    current = current.m_Child;
  }
  
  path = new ArrayList<PVector>();
}
