float decel(float x) { // as an easing function
  return 1-(x-1)*(x-1);
}

float step = 66.0f;
float wavePeriod = 4f;
PGraphics pg;
int widthOut = 0;
int heightOut = 0;



color backgr = 255;
color linesColor = 0;

void setup() {
  background(backgr);
  size(750, 750, P2D);
  PImage img = loadImage("image.png");
  widthOut = img.width;
  heightOut = img.height;
  pg = createGraphics(widthOut, heightOut);
  float lastX = 0;
  pg.beginDraw(); 
  pg.background(backgr);
  pg.stroke(linesColor);
  pg.strokeWeight(2);
  pg.noFill();
  for (float y=0.0; y<step; y++) {
    float l = 0;
    pg.beginShape(LINES);

    for (float x=lastX; x<widthOut * wavePeriod; x++) {
      float xx=x/wavePeriod;

      // using this version will generate a squished image due to using map(...) in line 26
      // color c = img.get(int(xx),int(y*height/50.0));
      color c = img.get(int(xx), int(map(y*heightOut/step, 0, heightOut, step, heightOut-step)));

      l += (255-red(c))/255/wavePeriod; // period of the wave

      // 5*decel(m) sets the amplitude of the wave
      // map(...) sets the position of the wave
      float m = (255-red(c))/255.0; // separate it from an increasing variable (l)
      if (alpha(c) == 0)
        m = 0;
      pg.vertex(xx, map((y+0.5)*heightOut/step, 0, heightOut, step, heightOut-step)+sin(l*PI/2.0)*5*decel(m));
    }
  }
  pg.endShape();
  PImage outImg = pg.get();


  outImg.save("image-edit.png");
  if (widthOut > 750 || heightOut > 750) 
    if (widthOut > heightOut)
      outImg.resize(750, 0);
    else
      outImg.resize(0, 750);

  image(outImg, 0, 0);
  thread("createGifFrames");
}


// This happens as a separate thread and can take as long as it wants
void createGifFrames() {
  pg.noStroke();
  pg.fill(backgr);
  for (int endX = widthOut - 3; endX > 0; endX -= 3)
  {
    pg.rect(endX, 0, widthOut - endX, heightOut);
    pg.get().save("gif/gif-" + nf(endX, 4) + ".png");
  }
}
