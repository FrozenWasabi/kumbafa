import g4p_controls.*;
//Global Variables//

//Images//
PImage car;
PImage bus;
PImage imgSchool;
PImage imgOffice;
PImage imgSupermarket;
PImage imgCommunitycentre;
PImage imgBushub;

//color//
color red = color(255, 0, 0);
color blue = color(0, 0, 255);
color background = color(40, 200, 80);
int rValue = 0;
int bValue = 0;
int gValue = 0;

//GUI Variables//
boolean paused = false;
boolean cleared = false;
int time;
int cSpeed = 5; 

//Global Variables//
ArrayList<Car> allCars; //arraylist for all cars on the road
ArrayList<Road> allRoads =  new ArrayList<Road>(); //arraylist for all roads

int maxCars = 1;
int totalCollisions = 0;

void setup() {
  frameRate(30);
  size(1000, 700);
  setupVehicleArrays();
  car = loadImage("car.png");
  createGUI();
  spawnCar();

  setupRoads();
  imgSchool = loadImage("School.png");
  imgOffice = loadImage("Office.png");
  imgSupermarket = loadImage("Supermarket.png");
  imgCommunitycentre = loadImage("Communitycentre.png");
  imgBushub = loadImage("Bushub.png");
}

void setupVehicleArrays() {
  allCars = new ArrayList<Car>(); //arraylist for all cars on the road
}
void draw() {
  if (paused == false) {
    int brightness = getBrightness();
    colorMode(HSB);
    background(120, 100, brightness);
    colorMode(RGB);
    drawMap();
    updateCars();
    drawCars();
    dayTimeCarSpawn();
    //clearCars();
    noTint();
    image(imgSchool, 230, 200, width/7, height/6);
    image(imgOffice, 710, 450, width/2.5, height/1.8);
    image(imgSupermarket, 260, 480, width/6, height/5);
    image(imgCommunitycentre, 615, 200, width/7, height/6);
    image(imgBushub, 810, 30, width/11, height/9); 
    textAlign(CENTER);
    fill(255);
    textSize(28);
    text("Total Collisions: " + totalCollisions, 320, 350);
  }
}

void setupRoads() {
  /////////////////all roads
  allRoads.add(new Road(40, 700, 60, 100, 350, PI/2, "road", "left"));
  allRoads.add(new Road(40, 700, 60, 140, 350, 3*PI/2, "road", "right"));
  allRoads.add(new Road(1200, 40, 60, 478, 580, PI, "road", "right"));
  allRoads.add(new Road(1200, 40, 60, 478, 620, 0, "road", "left"));
  allRoads.add(new Road(1000, 40, 60, 500, 80, PI, "road", "left"));
  allRoads.add(new Road(1000, 40, 60, 500, 120, 0, "road", "right"));
  allRoads.add(new Road(40, 700, 60, 900, 350, PI/2, "road", "right"));
  allRoads.add(new Road(40, 700, 60, 940, 350, 3*PI/2, "road", "left"));
  allRoads.add(new Road(40, 1000, 60, 480, 450, PI/2, "road", "right"));
  allRoads.add(new Road(40, 1000, 60, 520, 450, 3*PI/2, "road", "left"));
  /////////////////Intersections coordinations
  allRoads.add(new Road(80, 80, 60, 500, 600, "intersection"));
  allRoads.add(new Road(80, 80, 60, 500, 100, "intersection"));
  allRoads.add(new Road(80, 80, 60, 120, 600, "intersection"));
  allRoads.add(new Road(80, 80, 60, 120, 100, "intersection"));
  allRoads.add(new Road(80, 80, 60, 920, 100, "intersection"));
  allRoads.add(new Road(80, 80, 60, 920, 600, "intersection"));

  /////////////////Road Lines
  allRoads.add(new Road(120, 140, 120, 560));
  allRoads.add(new Road(500, 140, 500, 560));
  allRoads.add(new Road(920, 140, 920, 560));
  allRoads.add(new Road(540, 600, 880, 600));
  allRoads.add(new Road(160, 600, 460, 600));
  allRoads.add(new Road(0, 600, 80, 600));
  allRoads.add(new Road(540, 100, 880, 100));
  allRoads.add(new Road(160, 100, 460, 100));
  allRoads.add(new Road(0, 100, 80, 100));
  allRoads.add(new Road(960, 100, 1000, 100));
  allRoads.add(new Road(960, 600, 1000, 600));
  allRoads.add(new Road(500, 640, 500, 700));
  allRoads.add(new Road(120, 640, 120, 700));
  allRoads.add(new Road(120, 0, 120, 60));
  allRoads.add(new Road(920, 0, 920, 60));
  allRoads.add(new Road(920, 640, 920, 700));
  allRoads.add(new Road(500, 0, 500, 60));
}

void updateCars() {
  for (int i = 0; i < allCars.size(); i++) {
    allCars.get(i).moveVehicle();
    allCars.get(i).turn();
    for (int z = 0; z < allCars.size(); z++) {
      if (i != z) { //to make sure the car is not checking itself for collision
        if (abs(allCars.get(i).getCenterLocationX() - allCars.get(z).getCenterLocationX()) <= 30 && abs(allCars.get(i).getCenterLocationY() - allCars.get(z).getCenterLocationY()) <= 30) {
          allCars.get(i).movementCooldown += 30;
          allCars.get(z).movementCooldown -= 30;
        }
        if (abs(allCars.get(i).getCenterLocationX() - allCars.get(z).getCenterLocationX()) <= 2 && abs(allCars.get(i).getCenterLocationY() - allCars.get(z).getCenterLocationY()) <= 2) {
          allCars.get(i).Color = red;
          allCars.get(z).Color = red;
          totalCollisions += 1;
        }
      }
    }
    if (allCars.get(i).despawn == true || allCars.get(i).checkOffScreen() == true) {
      allCars.remove(i);
    }
  }
}  
void drawCars() {
  for (int i = 0; i < allCars.size(); i++) {
    allCars.get(i).drawVehicle();
  }
}

void drawMap() {
  ////////////////////////// Roads
  for (int i = 0; i < allRoads.size(); i++) {
    if (allRoads.get(i).checkType() == "road") {
      allRoads.get(i).drawRoad();
    } else if (allRoads.get(i).checkType() == "intersection") {
      allRoads.get(i).drawIntersection();
    } else if (allRoads.get(i).checkType() == "curve") {
      allRoads.get(i).drawCurveLine();
    } else {
      allRoads.get(i).drawLine();
    }
  }
}

boolean trueOrFalse() {
  if (int(random(1, 100)) >= 50) {
    return true;
  } else {
    return false;
  }
}

void spawnCar() {
  int randomLocation = round(random(0,100));
  if (randomLocation <= 25) {
    if (checkNearby(0, 120) == false) {
      allCars.add(new Car(0, 120, color(random(100, 255), random(100, 255), random(0, 255)), cSpeed, 10, 10, 10, 10, 0));
    }
  } else if (randomLocation >= 25 && randomLocation < 50) {
    if (checkNearby(0, 620) == false) {
      allCars.add(new Car(0, 620, color(random(100, 255), random(100, 255), random(0, 255)), cSpeed, 10, 10, 10, 10, 0));
    }
  } else if (randomLocation >= 50 && randomLocation < 75) {
    if (checkNearby(1000, 580) == false) {
      allCars.add(new Car(1000, 580, color(random(100, 255), random(100, 255), random(0, 255)), cSpeed, 10, 10, 10, 10, PI));
    }
  } else if (randomLocation >= 75) {
    if (checkNearby(1000, 80) == false) {
      allCars.add(new Car(1000, 80, color(random(100, 255), random(100, 255), random(0, 255)), cSpeed, 10, 10, 10, 10, PI));
    }
  }
}

boolean checkNearby(int x, int y) { //checks if there is a car close enough to where we want to put another car in, if so we want to avoid that
  for (int i = 0; i < allCars.size(); i++) { //we go through the entire array of cars and check their x and y coordinates, both x and y must be close enough to determine that it is too close
    if ((int(allCars.get(i).getCenterLocationX()) - x) < 100 && (int(allCars.get(i).getCenterLocationY()) - y) < 100) {
      return true;
    }
  }
  return false; //if the entire loop has finished without returning true, we can return false to spawn in a car
}

void dayTimeCarSpawn() {
  if (time >= 0 && time <= 7) {
    maxCars = 3;
    for (int i = 0; i < 1; i++) {
      if (trueOrFalse() == true && allCars.size() < maxCars) {
        spawnCar();
      }
    }
  } else if (time >= 8 && time <= 11) {
    maxCars = 8;
    for (int i = 0; i < 10; i++) {
      if (trueOrFalse() == true && allCars.size() < maxCars) {
        spawnCar();
      }
    }
  } else if (time >= 12) {
    maxCars = 20;
    for (int i = 0; i < 10; i++) {
      if (trueOrFalse() == true && allCars.size() < maxCars) {
        spawnCar();
      }
    }
  } else if (time >= 13 && time <= 15) {
    maxCars = 7;
    for (int i = 0; i < 5; i++) {
      if (trueOrFalse() == true && allCars.size() < maxCars) {
        spawnCar();
      }
    }
  } else if (time >= 16 && time <= 19) {
    maxCars = 20;
    for (int i = 0; i < 20; i++) {
      if (trueOrFalse() == true && allCars.size() < maxCars) {
        spawnCar();
      }
    }
  } else if (time >= 19 && time <= 24) {
    maxCars = 5;
     for (int i = 0; i < 5; i++) {
      if (trueOrFalse() == true && allCars.size() < maxCars) {
        spawnCar();
      }
    }
  }
}

int getBrightness() {
  if (time >= 0 && time <= 7) {
    return int(50);
  } else if (time >= 8 && time <= 11) {
    return int(125);
  } else if (time >= 12) {
    return int(255);
  } else if (time >= 13 && time <= 15) {
    return int(150);
  } else if (time >= 16 && time <= 19) {
    return int(100);
  } else if (time >= 20) {
    return int(50);
  } else {
    return int(10);
  }
}
