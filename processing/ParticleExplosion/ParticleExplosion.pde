//Copyright Jonathan Fraser 2011
//Free to use for non-commercial purposes
//Enjoy :)

ArrayList plist = new ArrayList();
int MAX = 50;
int frame = 0;

void setup() {
  size(1000, 800);
  background(50);
  frameRate(60);
}

void draw() {

  background(50);
  if (mousePressed && mouseButton == RIGHT) {
    background(50);
    boolean clearall = true;
    while (plist.size () > 0) {
      for (int i = 0; i < plist.size(); i++) {
        plist.remove(i);
      }
    }
  }

  for (int i = 0; i < plist.size(); i++) {
    Particle p = (Particle) plist.get(i);
    //makes p a particle equivalent to ith particle in ArrayList
    p.run();
    p.update();
    p.friction();
    p.gravity();
  }
}

void mousePressed() {
  for (int i = 0; i < MAX; i ++) {
    plist.add(new Particle(mouseX+random(0.1, 0.6)*i, mouseY)); // fill ArrayList with particles

    if (plist.size() > 10*MAX) {
      plist.remove(0);
    }
  }
}

