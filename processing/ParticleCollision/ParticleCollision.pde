
Particle[] particles;

int i = 1;

void setup(){
 size(1200, 800, P2D); 
 particles = new Particle[1000];
 for(int i=0; i< particles.length; i++){
   float posX = random(0, width);
   float posY = random(0, height);
   particles[i] = new Particle(posX, posY);
 }
}


void draw(){
  
  if(!mousePressed)background(0);
  
  noStroke();
  fill(50);
  rect(100, height-100, width-200, 10);
  
  for(int i=0; i < particles.length; i++){ 
   particles[i].update();
   particles[i].gravity(new PVector(mouseX, mouseY)); 
   particles[i].collide(100, height-100, width-200, 10);  
   particles[i].display();
  }
  
}

void keyPressed(){
  
 if(key == 'e'){
  saveFrame();
 } 
  
}

