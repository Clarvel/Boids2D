class Ground extends Rectangle{
  Ground(int height_){
  	PVector pos = new PVector(width/2, height_+(height-height_)/2);
    super(pos, width, height-height_, color(0, 102, 0));
  }
}
