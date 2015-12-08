/*
to access keys, use:
    keys.get("KEY")
which will return true or false

this lets me handle multiple key events at the same time
does this by storing all pressed keys in a hashmap
*/

HashMap<String, Boolean> keys = new HashMap<String, Boolean>();

void keyPressed(){
    if(key == CODED){
        keys.put(str(keyCode), true);
    }
    keys.put(str(key), true);
}
void keyReleased(){
    if(key == CODED){
        keys.put(str(keyCode), false);
    }
    keys.put(str(key), false);
}
boolean getKey(String val){
    try{
        return keys.get(val);
    }catch(Exception e){
        return false;
    }
}
