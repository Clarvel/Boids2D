class FoodEmitter extends Circle{
  float maxradius;
  
  FoodEmitter(color col, float maxradius){
    super(new PVector(random(width), random(height)), maxradius, col);
    this.maxradius = maxradius;
  }

  void update(float dt){
    if(this.radius <= 0){
      this.pos = new PVector(random(width), random(height));
      this.radius = this.maxradius;
    }
  }
}