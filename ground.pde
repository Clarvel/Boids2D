class Ground extends Rectangle{
	Ground(int height_){
		super(new PVector(width/2, height_+(height_-float(height))/2), float(width), height_-height, color(0, 102, 0));
	}
}
