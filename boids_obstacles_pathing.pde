
//http://www.red3d.com/cwr/boids/

PVector eye;
PVector rot;
float theta = 0;
float phi = 0;

float speed;
boolean DEBUG;
int mode;
float m = 200;

ArrayList<Renderable> render = new ArrayList<Renderable>();
ArrayList<Bird> birds = new ArrayList<Bird>();
ArrayList<Object> objects = new ArrayList<Object>();

ArrayList<PVector> path;

Rpm system;

void setup() {
	size(1024, 768, P3D);
	// Writing to the depth buffer is disabled to avoid rendering
	// artifacts due to the fact that the particles are semi-transparent
	// but not z-sorted.
	//hint(DISABLE_DEPTH_MASK);

	//frameRate(30);
	sphereDetail(7);
	eye = new PVector(0, 0, -500);
	rot = new PVector(0, 0, 0.01);
	DEBUG = true;
	mode = 0;
	speed = 5;

	for(int a = 0; a < 50; ++a){
		Object o = new Object(new PVector(random(-m, m),random(-m, m),random(-m, m)), 15);
		objects.add(o);
		render.add(o);
	}

	system = new Rpm(objects);

	for(int a = 0; a < 400; ++a) {
		PVector p = new PVector(random(-m, m),random(-m, m),random(-m, m));
		PVector d = new PVector(random(-1, 1),random(-1, 1),random(-1, 1));
		Bird b = new Bird(p, d, 5, 1);
		render.add(b);
		birds.add(b);
	}

	path = new ArrayList<PVector>();
	path.add(new PVector(random(-m, m),random(-m, m),random(-m, m)));
} 

void draw () {
	lights();
	background(178);
	noStroke();

	// update camera based on keyboard input
	PVector update = new PVector();
	if(getKey("d")){
		update.x -= speed;
	}
	if(getKey("e")){
		update.y -= speed;
	}
	if(getKey("w")){
		update.z += speed;
	}
	if(getKey("a")){
		update.x += speed;
	}
	if(getKey("q")){
		update.y += speed;
	}
	if(getKey("s")){
		update.z -= speed;
	}
	// rotate our y axis with theta:
	eye.x += cos(theta)*update.x + sin(theta)*update.z;
	eye.y += update.y;
	eye.z += cos(theta)*update.z - sin(theta)*update.x;	

	camera(eye.x, eye.y, eye.z, eye.x+rot.x, eye.y+rot.y, eye.z+rot.z, 0, 1, 0);
	// draw scene here

	for(Bird b : birds) {
		// apply boid rules to all near birds
		PVector r1 = new PVector(0, 0, 0); // RULE 1: boids fly to perceived flock center
		PVector r2 = new PVector(0, 0, 0); // RULE 2: boids avoid other boids
		PVector r3 = new PVector(0, 0, 0); // RULE 3: boids match flock direction
		PVector r4 = new PVector(0, 0, 0); // RULE 4: boids want to travel to some point
		PVector r5 = new PVector(0, 0, 0); // RULE 5: object avoidance

		int nearcount = 0;
		for(Bird bb : birds){
			if(bb != b){ // TODO near is calculated 2x for each bird pair
				PVector d = PVector.sub(bb.pos, b.pos);
				float dm = d.mag();
				d.normalize();

				if(dm < 5*(b.radius + bb.radius)){
					r1.add(bb.pos); // sum all positions
					r3.add(bb.dir); // sum all directions
					nearcount = nearcount + 1;
				}

				float rr = 3*(b.radius + bb.radius); // 2x touch radius
				if(dm > rr){
					r2.add(d.mult(2*rr/(dm - rr))); // sum inverted distance to all near birds
				}else{
					r2.add(d.mult(1000));
				}
			}
		}

		for(Object o : objects){
			PVector d = PVector.sub(o.pos, b.pos);
			float dm = d.mag();
			float rr = (b.radius + o.radius); // 2x touch radius
			if(dm <= rr){
				r5.add(d.mult(1000));
			}
		}

		r1.div(nearcount);

		// make vector to next path node here
		PVector tmp = path.get(0);
		if(PVector.sub(r1, b.pos).mag() > PVector.sub(r1, tmp).mag()){
			//if the distance from center to b > distance from center to point:
			// we've gone past the point, so remove it from path
			path.remove(0);
		}
		while(path.size() < 1){ // if no path, find a path to a random valid point
			// should handle when system.solve returns 
			PVector r = new PVector(random(-m, m),random(-m, m),random(-m, m));
			path = system.solve(tmp, r);
		}

		r4 = PVector.sub(path.get(0), b.pos); // r4 is direction to the set path

		if(nearcount > 0){
			r1.sub(b.pos).normalize();
			r3.normalize();
			r1.add(r3);
		}else{ // if no external forces, steer in self's direction
			r1 = PVector.mult(b.dir, 1); //PVector.add(b.dir, PVector.div(b.pos, -1000.0));
			r1.normalize();
		}
		r2.div(birds.size()-1);
		r2.mult(2);

		r5.div(objects.size());
		r4.normalize();
		r4.div(2);
		//r5.normalize();

		b.steer(PVector.sub(r1, r2).add(r4).sub(r5));

		// then update
		b.update(0);
	}

	// draw objects
	for(Renderable r : render) {
		r.render();
	}
	// draw path here
	stroke(color(255, 0, 0));
	fill(color(255, 0, 0));
	PVector pp = path.get(0);
	translate(pp.x, pp.y, pp.z);
	sphere(2);
	translate(-pp.x, -pp.y, -pp.z);
	for(int a = 1; a < path.size(); a++){
		PVector p = path.get(a);
        line(pp.x, pp.y, pp.z, p.x, p.y, p.z);
        pp = p;
	}

	// draw the 2D GUI here
	camera(); // reset the camera for 2D text
	fill(255);
	textSize(16);
	if(DEBUG){
		text("Frame rate: " + int(frameRate) + "\n", 10, 20);
	}
}


void mouseDragged(){
	theta += float(mouseX - pmouseX)/width;
	phi -= float(mouseY - pmouseY)/height;
	rot.x = sin(theta)*cos(phi);
	rot.y = sin(phi);
	rot.z = cos(theta)*cos(phi);
}




