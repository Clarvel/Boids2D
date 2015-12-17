// base class for renderable objects
class Renderable{
	PVector pos;
	color col;

	Renderable(PVector pos, color col){
		this.pos = pos;
		this.col = col;
	}

	void render(){}
    void update(float dt){}
    void translate(PVector diff){
    	this.pos.add(diff);
    }
    void rotate(float rad){}
    void setColor(color col){
    	this.col = col;
    }
    boolean intersect(PVector pos){
    	return false;
    }
}
