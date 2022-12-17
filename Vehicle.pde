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
    if (speed > 0) {
      if ( turningCooldown > 0) {
        turningCooldown -=1;
      }
      if (movementCooldown <= 0) {
        if (turningRight == false && turningLeft == false) {
          if (trueOrFalse() == true) {
            isTurning = false;
            turningRight = true;
          } else {
            isTurning = false;
            turningLeft = true;
          }
        }
        if (isTurning == false && turningCooldown == 0 && wantsToTurn() == true) {
          calculateTurn();
        }
      }

      if (isTurning == false) { //if we're not turning, move in the direction we're facing
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
    float desiredAngle = findDesiredAngle();
    if (desiredAngle == -PI/2) {
      desiredAngle = 3*PI/2;
    } else if (desiredAngle < PI/2 || desiredAngle > 3*PI/2) { // 2PI is the same as 0
      desiredAngle = 0;
    }
    if (desiredAngle > PI/2 && desiredAngle <3*PI/2) { //corrects the rounding issues with processing
      desiredAngle = PI;
    }

    for ( int i = 0; i < allRoads.size(); i++) { //compares all the roads's angles to what angle we need and checks if we're close enough to one of them
      if (allRoads.get(i).checkType() == "road") {
        if (this.roadPos == 0 || this.roadPos == PI) {
          if (allRoads.get(i).getAngle() == desiredAngle && this.xPos-allRoads.get(i).getCenterLocationX() == 0) {
            this.isTurning = true;
          }
        } else if (this.roadPos == PI/2 || this.roadPos == 3*PI/2) {
          if (allRoads.get(i).getAngle() == desiredAngle && this.yPos-allRoads.get(i).getCenterLocationY() == 0) {
            this.isTurning = true;
          }
        }
      }
    }
  }

  float findDesiredAngle() {
    float desiredAngle = 0;
    if (turningRight == true) {
      desiredAngle = roadPos + PI/2;
    }
    if (turningLeft == true) {
      desiredAngle = roadPos - PI/2;
    }
    return desiredAngle;
  }
  void accelerate() {
    if (speed < maxSpeed) {
      this.speed += acceleration;
    }
    if (speed > maxSpeed) {
      this.speed = maxSpeed;
    }
  }

  void decelerate() {
    if (speed > maxSpeed) {
      this.speed -= deceleration;
    }
    if (speed < minSpeed) {
      this.speed = minSpeed;
    }
  }

  void turn() {
    if (isTurning == true) {
      if (turningLeft == true) {
        this.angle -= (rotationStrength); //rotating the opposite direction visually before we enter the lane
      } else if (turningRight == true) {
        this.angle += (rotationStrength);
      }
      if (angle >= PI/2 || angle <= -PI/2) {
        if (angle >= PI/2) {
          this.angle = PI/2;
          this.roadPos += angle;
        }
        if (angle <= -(PI/2)) {
          this.angle = -PI/2;
          this.roadPos += angle;
        }
        if (roadPos >= -(PI/2) && roadPos < 0) { //in case it becomes negative, we can set it back to positive
          this.roadPos = 3*PI/2;
        } else if (roadPos > PI/2 && roadPos <3*PI/2) { //corrects the rounding issues with processing
          this.roadPos = PI;
        } else if (roadPos == 2*PI) { //in case it does a full rotation and becomes 2PI, we can set it back to 0;
          this.roadPos = 0;
        }

        this.angle = 0;
        this.isTurning = false;
        this.turningCooldown = 30;
        this.turningLeft = false;
        this.turningRight = false;
      }
    }
  }

  void drawVehicle() { //draws the vehicle
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
}
