
//http://www.red3d.com/cwr/boids/

boolean DEBUG = false;

ArrayList<Renderable> world = new ArrayList<Renderable>();
ArrayList<Boid> boids = new ArrayList<Boid>();
ArrayList<Renderable> objects = new ArrayList<Renderable>();
int time_start, time_end;

void applyRules(){
	ArrayList<Boid> rem = new ArrayList<Boid>();
	for(Boid b : boids) {
		if(b.thirst <= 0 || b.hunger <= 0 || b.tiredness <= 0){
			rem.add(b);
			continue;
		}
		// apply boid rules to all near birds
		PVector r1 = new PVector(0, 0); // RULE 1: boids fly to perceived flock center
		PVector r2 = new PVector(0, 0); // RULE 2: boids avoid other boids
		PVector r3 = new PVector(0, 0); // RULE 3: boids match flock direction
		PVector r4 = new PVector(0, 0); // RULE 4: boids want to travel to some mouse pos
		PVector r5 = new PVector(0, 0); // RULE 5: boids want to avoid objects

		int nearcount = 0;
		// for each boid not self, get perceived flock center and boid avoidance rules
		for(Boid bb : boids){
			if(bb != b){
				// find direction and magnitude components of direction b->bb
				PVector d = PVector.sub(bb.pos, b.pos);
				float dm = d.mag();
				d.normalize();

				float touchrad = b.radius + bb.radius;
				float sense = b.sense_length + touchrad;
				// if bb is in b's sense_length range
				if(dm < sense){
					r1.add(bb.pos); // sum all positions for rule 1, averaged later

					// use inverted distance func, ignoring when they are inside eachother:
					//https://www.google.com/search?q=graph+a%3D5%2C+b%3D10%2C+y%3D(a%2Bb)*(a%2Bb)%2F(x-a)-((a%2Bb)*(a%2Bb)%2F((a%2Bb)*(a%2Bb)-a))&oq=graph+a%3D5%2C+b%3D10%2C+y%3D(a%2Bb)*(a%2Bb)%2F(x-a)-((a%2Bb)*(a%2Bb)%2F((a%2Bb)*(a%2Bb)-a))&aqs=chrome..69i57j69i60.464j0j4&sourceid=chrome&es_sm=91&ie=UTF-8#safe=off&q=graph+y%3D(5%2B10)%2F(x-5)-(1%2B5%2F10)
					if(dm > touchrad && PVector.angleBetween(b.direction, d) < b.viewAngle){
						r2.sub(d.mult(sense/(dm-touchrad)-(1+touchrad/b.sense_length))); 
					}else{
						//r2.sub(d.mult(10000));
					}

					r3.add(bb.direction); // sum all directions for rule 3, averaged later

					nearcount = nearcount + 1;
				}
			}
		}
		// average and only normalize r1, r3
		if(nearcount > 0){
			r1.div(nearcount).sub(b.pos);
			r1.normalize();
			r1.mult(0.5);

			r2.div(nearcount);

			r3.normalize();
			r3.mult(0.5);
		}

		r4 = PVector.sub(new PVector(mouseX, mouseY), b.pos); // r4 is direction to the set path
		r4.normalize();
		r4.mult(0.15);

		for(Renderable o : objects){
			// TODO avoid objects for r5, treat each object as circle perhaps?
			//and then use code for r2
			//shouldn't be normalized
			// find direction and magnitude components of directionb->bb
            if (o instanceof Tree){
              Tree tr = (Tree)o;
              for(Renderable r : tr.shapes){
                if (r instanceof Circle){
                  Circle circ = (Circle)r;
                  if (b.pos.dist(circ.pos) < circ.radius+b.radius+100){
                    r5 = PVector.add(PVector.mult(PVector.sub(b.pos, circ.pos).normalize(), 10/(b.pos.dist(circ.pos)-b.radius-circ.radius)), r5);
                  }
                }
                if (r instanceof Rectangle){
                  Rectangle rec = (Rectangle)r;
                  PVector closest = new PVector (0,0); 
                  closest = closestPoint(rec, b);
                  if (b.pos.dist(closest) < b.radius+100){
                    r5 = PVector.add(PVector.mult(PVector.sub(b.pos, closest).normalize(), 10/(b.pos.dist(closest)-b.radius)), r5);
                  }     
                }
              }
		}

		b.steer(r1.add(r2).add(r3).add(r4).add(r5));
	}
}
  for(Boid bo : rem){
    boids.remove(bo);
    world.remove(bo);
  }
}


void setup() {
  size(1024, 700, P2D);
	ellipseMode(RADIUS);
	// Writing to the depth buffer is disabled to avoid rendering
	// artifacts due to the fact that the particles are semi-transparent
	// but not z-sorted.
	//hint(DISABLE_DEPTH_MASK);

	frameRate(30);
	sphereDetail(7);

	Ground g = new Ground(height-10);
	objects.add(g);
	world.add(g);

	Water w = new Water(new PVector(500, height-26));
	objects.add(w);
	world.add(w);

	Tree t = new Tree(new PVector(300, 550), 100, 50, 200);
	objects.add(t);
	world.add(t);

	FoodEmitter f = new FoodEmitter(color(255, 0, 0, 50), 100);
	objects.add(f);
	world.add(f);

	float max_speed = 4;
	float radius = 20;
	float sense_length = 20;

	// randomly place some number of boids
	while(boids.size() < 15){
		PVector p = new PVector(random(radius, 1024-radius),random(radius, 768-radius));
		Boid b = new Boid(p, radius, max_speed, sense_length);
		boolean blocked = false;
		for(Renderable r : world){
			if(b.collide(r)){
				blocked = true;
				break;
			}
		}
		if(!blocked){
			world.add(b);
			boids.add(b);
		}

	}
	time_start = millis();
} 

void draw () {
	applyRules();

	background(color(0, 255, 255));
	//camera();
	// draw scene here
	if(boids.size() > 0){
		for(Renderable r : world){
			r.update(0);
		}

		// draw all objects
		for(Renderable r : world) {
			r.render();
		}
		time_end = millis();
	}else{
		textAlign(CENTER);
		text("Your boids lasted " + float(time_end-time_start)/1000 + " seconds!", width/2, height/2);
  }

	

	// draw the 2D GUI here
	fill(0);
	textSize(16);
  if(DEBUG){
    textAlign(LEFT);
    text("Frame rate: " + int(frameRate) + "\n", 10, 20);
  }
}

//Find shortest distance from point to line and return point on line
  PVector distanceToLinePoint(PVector p1, PVector p2, PVector p) {
    PVector u = PVector.sub(p2, p1);
    PVector v = PVector.sub(p, p1);
    float t = PVector.dot(u, v)/sq(u.mag());
    if (t < 0) { return p1; }
    if (t > 1) { return p2; }
    return PVector.add(p1, PVector.mult(u, t));
  }
  
  PVector closestPoint(Rectangle rec, Boid b){
    PVector p1 = distanceToLinePoint(rec.pos, new PVector(rec.pos.x, rec.pos.y + rec.high), b.pos);//left side
      PVector p2 = distanceToLinePoint(rec.pos, new PVector(rec.pos.x + rec.wide, rec.pos.y), b.pos);//top side
      PVector p3 = distanceToLinePoint(new PVector(rec.pos.x + rec.wide, rec.pos.y + rec.high), new PVector(rec.pos.x, rec.pos.y + rec.high), b.pos);//bottom side
      PVector p4 = distanceToLinePoint(new PVector(rec.pos.x + rec.wide, rec.pos.y + rec.high), new PVector(rec.pos.x + rec.wide, rec.pos.y), b.pos);//right side
      float l1 = p1.dist(b.pos);
      float l2 = p2.dist(b.pos);
      float l3 = p3.dist(b.pos);
      float l4 = p4.dist(b.pos);
      float min1 = min(l1, l2, l3);
      float min2 = min(l4, min1);
      if (min2 == l4) {
        return p4;
      }
      if (min2 == l3) {
        return p3;
      }
      if (min2 == l2) {
        return p2;
      }
        return p1;
  }
