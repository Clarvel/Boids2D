class Sphere extends Renderable{
    PVector pos;
    float radius;
    color col;
    Sphere(float x, float y, float z, float r, color c){
        pos = new PVector(x, y, z);
        radius = r;
        col = c;
    }

    void render(){
        noStroke();
        pushMatrix();
        translate(pos.x, pos.y, pos.z);
        fill(col);
        sphere(radius);
        popMatrix();
    }
}