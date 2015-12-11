class Boid extends Circle{
	PVector direction;
	float speed, max_speed, sense_length;
	float thirst, hunger, tiredness;
	PShape pointer;

	Boid(PVector pos, float radius, float max_speed, float sense_length){
		super(pos, radius, color(255, 255, 255));
		this.max_speed = max_speed;
		this.speed = 0;
		this.sense_length = sense_length;
		this.direction = new PVector(random(-1, 1), random(-1, 1));
		this.direction.normalize();
		this.hunger = 128;
		this.tiredness = 128;
		this.thirst = 128;
	}

	void render(){
		super.render();
		PVector dir = PVector.add(this.pos, PVector.mult(this.direction, this.radius));
		stroke(0);
		line(this.pos.x, this.pos.y, dir.x, dir.y);
	}

	void update(float dt){
		// color is RGB, B=thirst, G=tiredness, R=hunger
		this.hunger -= 0.1;
		this.tiredness -= 0.1;
		this.thirst -= 0.1;
		this.col = color(int(this.hunger)%255, int(this.tiredness)%255, int(this.thirst)%255);
		this.pos.add(PVector.mult(this.direction, this.speed * this.max_speed));
	}

	void steer(PVector dir){
		/* 
		dir vector in the direction I want to move to
		*/
		float mag = dir.mag()+this.speed;
		dir.add(this.direction);
		dir.normalize();
		if(mag > 1){
			mag = 1;
		}

		// instantaneous update, TODO possibly set max rotation speed?
		this.direction = dir;
		this.speed = mag;
	}
}


