class Car extends Vehicle { //car doesn't have anything as it's only really here to use as the constructor as all the methods are from vehicle. This was originally supposed to make it easier for buses to take code from the vehicle class but buses ended up being scrapped as the person working on them ended up not finishing it on time. :)
  Car( float x, float y, color c, float s, float a, float d, float min, float max, float pos) {
    xPos = x;
    yPos = y;
    Color = c;
    speed = s;
    acceleration = a;
    deceleration = d;
    minSpeed = min;
    maxSpeed = max;
    roadPos = pos;
    collision = false;
    rotationStrength = PI/20;
  }
}
