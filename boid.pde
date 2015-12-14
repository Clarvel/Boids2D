class Boid extends Circle{
	PVector direction;
	float speed, max_speed, sense_length;
	float thirst, hunger, tiredness;
	float viewAngle;

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
		this.viewAngle = radians(135);
	}

	void render(){
		if(DEBUG){
			fill(color(128, 128, 128, 50));
			noStroke();
			float ang = atan2(this.direction.y, this.direction.x);
			arc(this.pos.x, this.pos.y, this.radius+this.sense_length, this.radius+this.sense_length, ang-this.viewAngle, ang+this.viewAngle);
		}
		super.render();
		PVector dir = PVector.add(this.pos, PVector.mult(this.direction, this.radius));
		stroke(0);
		line(this.pos.x, this.pos.y, dir.x, dir.y);
	}

void update(float dt){
  for (Renderable r : objects){
    if (this.collide(r)){
      if (r instanceof Water){
        this.thirst += 0.5;
      }
      if (r instanceof Ground){
        this.tiredness += 0.5;
      }
      //TODO add conditions for food
    }
  }
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
		need to add a little randomness
		*/
		//dir.add(new PVector(random(-this.random, this.random),random(-this.random, this.random),random(-this.random, this.random)).normalize(null));
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
