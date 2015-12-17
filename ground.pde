class Ground extends Rectangle{
	Ground(int height_){
		super(new PVector(0, height_+(height_-float(height))/2-10), float(width), (height-height_)*2, color(0, 102, 0));
	}
}
