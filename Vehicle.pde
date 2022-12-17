class Vehicle {
  ///Fields///
  ////////////////////////////////
  float xPos;
  float yPos;
  float vWidth;
  float vHeight;
  float objM;

  color Color;

  float speed;
  float acceleration;
  float deceleration;
  float minSpeed;
  float maxSpeed;

  float roadPos; //position of the car rotation 0 is East, 90 is North, 180 is West, 270 is South
  float angle;
  float rotationStrength;
  float turningCooldown;
  float movementCooldown;
  String sideOfRoad;
  boolean collision;
  boolean isTurning = false;
  boolean turningLeft = false;
  boolean turningRight = false;
  boolean despawn = false;

  ///Methods///
  /////////////////
  void moveVehicle() {
    if (movementCooldown <= 0) {
      if (speed > 0) {
        if ( turningCooldown > 0) {
          turningCooldown -=1;
        }
        if (this.yPos == 620 && this.xPos == 40) { //the car cannot turn here so we put a cooldown on it
          turningCooldown = 30;
        }
        if (this.yPos == 620 && this.xPos == 900 && roadPos == 0) { //the car must make a left turn here
          turningCooldown = 30;
        }
        if (this.yPos == 620 && this.xPos == 940 && roadPos == 0) { //the car must make a left turn here
          turningCooldown = 0;
          turningLeft = true;
          calculateTurn();
        }
        if (this.yPos == 620 && this.xPos == 480) {
          turningRight = true;
          calculateTurn();
        }
        if (isTurning == false && turningCooldown == 0 && wantsToTurn() == true) {
          if (trueOrFalse() == true) {
            isTurning = false;
            turningRight = true;
          } else {
            isTurning = false;
            turningLeft = true;
          }
          calculateTurn();
        } 
        if (this.yPos == 620 && this.xPos == 940 && roadPos == 0) {
          turningLeft = true;
          calculateTurn();
        }
        if (this.yPos == 580 && this.xPos == 900 && roadPos == PI/2) {
          turningRight = true;
          calculateTurn();
        }
        if (this.yPos == 580 && this.xPos == 100 && roadPos == PI/2) {
          turningRight = true;
          calculateTurn();
        } else if (this.yPos == 120 && this.xPos == 140 && roadPos == 3*PI/2) {
          turningRight = true;
          calculateTurn();
        } else if (this.yPos == 120 && this.xPos == 520 && roadPos == 3*PI/2) {
          turningRight = true;
          calculateTurn();
        }
      }

      if (isTurning == false) {
        if (roadPos == 0) {
          this.xPos += speed;
        } else if (roadPos == PI/2) {
          this.yPos += speed;
        } else if (roadPos == PI) {
          this.xPos -= speed;
        } else if (roadPos == 3*PI/2) {
          this.yPos -= speed;
        }
      }
    } else {
      movementCooldown -= 1;
    }
  }

  void calculateTurn() {
    float desiredAngle;
    if (turningRight == true) {
      desiredAngle = roadPos + PI/2;
    } else {
      desiredAngle = roadPos - PI/2;
    }
    if (desiredAngle == -PI/2) {
      desiredAngle = 3*PI/2;
    } else if (desiredAngle < PI/2 || desiredAngle > 3*PI/2) {
      desiredAngle = 0;
    }
    if (desiredAngle > PI/2 && desiredAngle <3*PI/2) { //corrects the rounding issues with processing
      desiredAngle = PI;
    }

    for ( int i = 0; i < allRoads.size(); i++) {
      if (allRoads.get(i).checkType() == "road") {
        if (this.roadPos == 0 || this.roadPos == PI) {
          if (allRoads.get(i).getAngle() == desiredAngle && this.xPos-allRoads.get(i).getCenterLocationX() == 0) {
            isTurning = true;
          }
        } else if (this.roadPos == PI/2 || this.roadPos == 3*PI/2) {
          if (allRoads.get(i).getAngle() == desiredAngle && this.yPos-allRoads.get(i).getCenterLocationY() == 0) {
            isTurning = true;
          }
        }
      }
    }
  }

  void accelerate() {
    if (speed < maxSpeed) {
      speed += acceleration;
      if (speed > maxSpeed) {
        speed = maxSpeed;
      }
    }
  }

  void decelerate() {
    if (speed > maxSpeed) {
      speed -= deceleration;
      if (speed < minSpeed) {
        speed = minSpeed;
      }
    }
  }

  void turn() {
    if (isTurning == true) {
      if (turningLeft == true) {
        angle += (rotationStrength); //rotating the opposite direction visually before we enter the lane
      } else if (turningRight == true) {
        angle -= (rotationStrength);
      }

      if (angle >= PI/2 || angle <= -PI/2) {     
        if (turningRight == true) {
          angle = (PI/2);
        } else if (turningLeft == true) {
          angle = -(PI/2);
        }

        roadPos += angle;

        if (roadPos == -(PI/2)) { //in case it becomes negative, we can set it back to positive
          roadPos = 3*PI/2;
        } else if (roadPos > PI/2 && roadPos <3*PI/2) { //corrects the rounding issues with processing
          roadPos = PI;
        } else if (roadPos == 2*PI) { //in case it does a full rotation and becomes 2PI, we can set it back to 0;
          roadPos = 0;
        }

        angle = 0;
        isTurning = false;
        turningCooldown = 10;
        turningLeft = false;
        turningRight = false;
      }
    }
  }

  void drawVehicle() {
    noStroke();
    fill(Color);
    pushMatrix();
    imageMode(CENTER);
    translate(this.xPos, this.yPos);
    rotate(roadPos+angle);
    car.resize(60, 60);
    tint(Color);
    image(car, 0, 0);
    popMatrix();
    //println("Car's y val is", this.yPos);
    //println("Car's x val is", this.xPos);
  }

  float getCenterLocationX() {
    float middleX = this.xPos;
    return middleX;
  }

  float getCenterLocationY() {
    float middleY = this.yPos;
    return middleY;
  }

  boolean wantsToTurn() {
    int turnChance = int(random(1, 100));
    if (turnChance >= 5) {
      return true;
    } else
      this.turningCooldown = 10;
    return false;
  }

  boolean checkOffScreen() {
    if ( yPos <= 0 || yPos >= 700 || xPos <= 0 || xPos >= 1000) {
      return true;
    } else {
      return false;
    }
  }
  
    boolean busTrack1(){ 
    if(this.xPos == 562 && this.yPos == 120){ //--562
      return true;
    }else if(this.xPos == 518 && this.yPos == 540){
      return true;
    }else if(this.xPos == 860 && this.yPos == 584){
      return true;
    }else if(this.xPos == 902 && this.yPos == 120){//testing
      return false;
    }else{
      return false;
    }
  }
  
    boolean busTrack2(){ //random name, need to change to bus track 2
    if(this.xPos == 180 && this.yPos == 120){//x value
      return true;
    }else if(this.xPos == 136 && this.yPos == 540){//x value
      return true;
    }else if(this.xPos == 860 && this.yPos == 584){
      return true;
    }else if(this.xPos == 902 && this.yPos == 120){//testing
      return false;
    }else{
      return false;
    }
  }
}
