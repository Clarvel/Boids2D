

class Grouping extends Renderable{
  ArrayList<Renderable> shapes = new ArrayList<Renderable>();
  
  Grouping(){
    super(new PVector(0, 0), color(0));
  }

  void render(){
    for(Renderable r : this.shapes){
      r.render();   
    }
  }

  boolean intersect(PVector pos){
    for(Renderable r : this.shapes){
      if(r.intersect(pos)){
        return true;
      }
    }
    return false;
  }
}