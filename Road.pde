class Road {
  //fields
  int rw;
  int rh;
  int x;
  int y;
  int x2;
  int y2;
  int speed;
  String roadType;
  String side;
  float orientation;

  Road(int w, int h, int s, int xC, int yC, float o, String rT, String side) { //consructor for roads, they need the most amount of information so it has the orientation and side of the road attached
    this.rw = w;
    this.rh = h;
    this.speed = s; 
    this.x = xC;
    this.y = yC;
    this.roadType = rT;
    this.orientation = o;
    this.side = side;
  }

  Road(int w, int h, int s, int xC, int yC, String rT) {//constructor for the intersections
    this.rw = w;
    this.rh = h;
    this.speed = s; 
    this.x = xC;
    this.y = yC;
    this.roadType = rT;
  }
  
  Road(int xCor1, int yCor1, int xCor2, int yCor2) { //constructor for road lines
    this.x = xCor1;
    this.y = yCor1;
    this.x2 = xCor2;
    this.y2 = yCor2;
    this.roadType = "Road Line";
  }
  
  void drawLine() {
    stroke(255,255,0);
    strokeWeight(3);
    line(this.x, this.y, this.x2, this.y2);
  }

  void drawRoad() { //draws the road as a rectangle
    rectMode(CENTER);
    noStroke();
    fill(55);
    rect(this.x, this.y, this.rw, this.rh);
    fill(255, 255, 0);
  }

  void drawIntersection() {
    rectMode(CENTER);
    noStroke();
    fill(55);
    rect(this.x, this.y, this.rw, this.rh);
  }

  void drawCurveLine() {
    noFill();
    stroke(255, 255, 0);
    strokeWeight(5);
    arc(this.x, this.y, 77, 81, 0, HALF_PI);
  }

  float getCenterLocationX() {
    float middleX = this.x;
    return middleX;
  }

  float getCenterLocationY() {
    float middleY = this.y;
    return middleY;
  }

  float getAngle() {
    return orientation;
  }

  String checkType() {
    return this.roadType;
  }
}
