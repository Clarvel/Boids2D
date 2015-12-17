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
			//println("circle");
			return c.radius+this.radius > PVector.dist(this.pos, c.pos);
		}else if(r instanceof Rectangle){
			Rectangle rec = (Rectangle)r;
			float l1 = distanceToLine(rec.pos, new PVector(rec.pos.x, rec.pos.y + rec.high), this.pos);//left side
			float l2 = distanceToLine(rec.pos, new PVector(rec.pos.x + rec.wide, rec.pos.y), this.pos);//top side
			float l3 = distanceToLine(new PVector(rec.pos.x + rec.wide, rec.pos.y + rec.high), new PVector(rec.pos.x, rec.pos.y + rec.high), this.pos);//bottom side
			float l4 = distanceToLine(new PVector(rec.pos.x + rec.wide, rec.pos.y + rec.high), new PVector(rec.pos.x + rec.wide, rec.pos.y), this.pos);//right side
			float min1 = min(l1,l2,l3);
			float min2 = min(l4, min1);
			//println("rect");
			return min2 < this.radius;  
		}
		//println("other");
		return false;
	}
	
	//Find shortest distance from point to line
	float distanceToLine(PVector p1, PVector p2, PVector p) {
		PVector u = PVector.sub(p2, p1);
		PVector v = PVector.sub(p, p1);
		float t = PVector.dot(u, v)/sq(u.mag());
		if (t < 0) { return p.dist(p1); }
		if (t > 1) { return p.dist(p2); }
		return p.dist(PVector.add(p1, PVector.mult(u, t)));
	}
}
