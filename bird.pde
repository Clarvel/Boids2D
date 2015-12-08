

class Bird extends Renderable{
	/*
	2 spheres as shape
	large one of size r as body
	smaller one of size r/4 at distance r from center, 
	pointing in the bird's direction

	should only be able to modify rotation and possibly speed

	*/
	PVector pos, dir;
	float radius, speed;
	float rs = 0.1; // randomness in steering
	color colorBase = color(0, 0, 255);
	color colorNose = color(0, 255, 0);
	PShape head, body;
	boolean shownear = false;


	Bird(PVector pos, PVector dir, float r, float sp){
		dir.normalize();

		this.pos = pos;
		this.dir = dir;
		this.radius = r;
		this.speed = sp;
		// experiemtnally, senseLength is a function of speed and radius

		PVector d = PVector.mult(dir, r);

		body = createShape(SPHERE, r);
		body.setFill(color(0, 0, 255));
		body.setStroke(false);

		head = createShape(SPHERE, r/3);
		head.setFill(color(0, 255, 0));
		head.translate(d.x, d.y, d.z);
		head.setStroke(false);

		body.translate(pos.x, pos.y, pos.z);
		head.translate(pos.x, pos.y, pos.z);
	}

	void render(){
		shape(this.head);
		shape(this.body);
	}

	void update(float dt){
		PVector u = PVector.mult(this.dir, this.speed);
		this.body.translate(u.x, u.y, u.z);
		this.head.translate(u.x, u.y, u.z);
		this.pos.add(u);
	}

	void steer(PVector r){
		/* r vector in the direction I want to move to
		need to set head position here:
			sub this.dir
			add r
		*/
		r = PVector.add(r, new PVector(random(-this.rs, this.rs), random(-this.rs, this.rs), random(-this.rs, this.rs)));
		r.normalize();

		PVector u = PVector.mult(this.dir, -this.radius);
		this.head.translate(u.x, u.y, u.z);

		u = PVector.mult(r, this.radius);
		this.head.translate(u.x, u.y, u.z);
		this.dir = r;
	}
}

