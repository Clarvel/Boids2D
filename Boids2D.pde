
//http://www.red3d.com/cwr/boids/

boolean DEBUG = true;

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
		}

		b.steer(r1.add(r2).add(r3).add(r4).add(r5));
	}
	for(Boid b : rem){
		boids.remove(b);
	}
}


void setup() {
	size(1024, 768, P2D);
	ellipseMode(RADIUS);
	// Writing to the depth buffer is disabled to avoid rendering
	// artifacts due to the fact that the particles are semi-transparent
	// but not z-sorted.
	//hint(DISABLE_DEPTH_MASK);

	frameRate(30);
	sphereDetail(7);

	float max_speed = 2;
	float radius = 20;
	float sense_length = 20;

	//world.add(new Ground(height-10));

	// randomly place some number of boids
	while(boids.size() < 30){
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


