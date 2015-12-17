
class Tree extends Grouping{
	Tree(PVector pos, float rad, float wid, float hei){
		PVector p2 = new PVector(pos.x-wid/2, pos.y);
		this.shapes.add(new Rectangle(p2, wid, hei, color(178, 93, 37)));
		this.shapes.add(new Circle(pos, rad, color(0, 255, 0)));
	}
}