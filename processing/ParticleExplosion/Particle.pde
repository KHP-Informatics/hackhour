class Particle {
  float r = 2;
  PVector pos, speed, grav;
  ArrayList tail;
  float splash = 10;
  int margin = 2;
  int taillength = 45;
  float wind = 0.01;
  int frame=0;

  Particle(float tempx, float tempy) {
    float startx = tempx + random(-splash, splash);
    float starty = tempy + random(-splash, splash);
    startx = constrain(startx, 0, width);
    starty = constrain(starty, 0, height);
    float xspeed = random(-2, 2);
    float yspeed = random(-7, 0);

    pos = new PVector(startx, starty);
    speed = new PVector(xspeed, yspeed);
    grav = new PVector(0, random(0.07, 0.09));

    tail = new ArrayList();
  }

  void run() {
    pos.add(speed);

    tail.add(new PVector(pos.x, pos.y, 0));
    if (tail.size() > taillength) {
      tail.remove(0);
    }

    float damping = random(-0.4, -0.6);
    if (pos.x > width - margin || pos.x < margin) {
      speed.x *= damping;
    }
    if (pos.y > height -margin) {
      speed.y *= damping;
    }
  }

  void gravity() {
    speed.add(grav);
  }

  void friction() {
    float rand;
    if (speed.x > 0) {
      rand =  random(-0.02, -0.03)+wind;
    } 
    else {
      rand =  random(0.02, 0.03)+wind;
    }
    PVector fric = new PVector(rand, 0);
    speed.add(fric);
  }

  void update() {
    frame+=2;
    if (frame<600) {
      int time = frame/5;
      for (int i = 0; i < tail.size(); i++) {
        PVector tempv = (PVector)tail.get(i);
        noStroke();
        fill(4*i + 50 - time, i*2.5 - time, 0);
        ellipse(tempv.x, tempv.y, r, r);
      }
    }
  }
}

