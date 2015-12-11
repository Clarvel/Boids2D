// ellipseMode(CENTER)

class Circle extends Renderable{
	float radius;

	Circle(PVector pos, float radius, color col){
		super(pos, col);
		this.radius = radius;
	}

	void render(){
		fill(this.col);
		noStroke();
		ellipse(this.pos.x, this.pos.y, this.radius, this.radius);
	}

	boolean intersect(PVector pos){
		return this.radius > PVector.dist(this.pos, pos);
	}

	boolean collide(Renderable r){
		if(r instanceof Circle){
			Circle c = (Circle)r;
			return c.radius+this.radius > PVector.dist(this.pos, c.pos);
		}
		return false;
	}
}