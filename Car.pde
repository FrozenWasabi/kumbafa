class Car extends Vehicle {
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
