
class Particle{
  
 PVector pos, speed;
 PVector defaultSpeed = new PVector(-1,1);
 float ACC = 0.15;
 float TERMINALSPEED = 8.5;
 float DAMPING = -1;
 
 public Particle(float posX, float posY){
    pos = new PVector(posX, posY);
    speed = new PVector();
    speed.x = random(defaultSpeed.x, defaultSpeed.y);
    speed.y = random(defaultSpeed.x, defaultSpeed.y);
 } 
 
 public void update(){
   pos.add(speed);
 }
 
 public void display(){
   stroke(255);
   strokeWeight(2);
   point(pos.x, pos.y); 
 }
 
  public void gravity(PVector gravPos){
  
  PVector gravityPos = gravPos;
  PVector direction = PVector.sub(gravityPos, pos);
  direction.normalize();
  direction.mult(ACC);
  speed.add(direction);
  speed.limit(TERMINALSPEED);
 }
 
 void collide(int x, int y, int w, int h) {
    if(pos.x > x && pos.x < x+w && pos.y > y && pos.y < y+h)speed.y *=DAMPING;
  }
 
}
