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

//GUI Variables//
boolean paused = false;
boolean cleared = false;
float aggression;
float tolerance;
float capacity;

//Global Variables//
ArrayList<Car> allCars; //arraylist for all cars on the road
ArrayList<Road> allRoads =  new ArrayList<Road>(); //arraylist for all roads

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
    background(background);
    drawMap();
    updateCars();
    drawCars();
    //clearCars();
    noTint();
    image(imgSchool, 230, 200, width/7, height/6);
    image(imgOffice, 710, 450, width/2.5, height/1.8);
    image(imgSupermarket, 260, 480, width/6, height/5);
    image(imgCommunitycentre, 615, 200, width/7, height/6);
    image(imgBushub, 810, 50, width/7, height/6); 
    //rectMode(CENTER);
    //rect(100,620,20,20);
    //  updatePeople();
    //  drawPeople();
  }
}

void setupRoads() {
  /////////////////all roads
  allRoads.add(new Road(40, 580, 60, 100, 350, PI/2, "road", "left"));
  allRoads.add(new Road(40, 580, 60, 140, 350, 3*PI/2, "road", "right"));
  allRoads.add(new Road(964, 40, 60, 478, 580, PI, "road", "right"));
  allRoads.add(new Road(964, 40, 60, 478, 620, 0, "road", "left"));
  allRoads.add(new Road(1000, 40, 60, 500, 80, PI, "road", "left"));
  allRoads.add(new Road(1000, 40, 60, 500, 120, 0, "road", "right"));
  allRoads.add(new Road(40, 550, 60, 900, 350, PI/2, "road", "right"));
  allRoads.add(new Road(40, 550, 60, 940, 350, 3*PI/2, "road", "left"));
  allRoads.add(new Road(40, 650, 60, 480, 450, PI/2, "road", "right"));
  allRoads.add(new Road(40, 650, 60, 520, 450, 3*PI/2, "road", "left"));
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
  allRoads.add(new Road(920, 140, 920, 600));
  allRoads.add(new Road(540, 600, 920, 600));
  allRoads.add(new Road(160, 600, 460, 600));
  allRoads.add(new Road(0, 600, 80, 600));
  allRoads.add(new Road(540, 100, 880, 100));
  allRoads.add(new Road(160, 100, 460, 100));
  allRoads.add(new Road(0, 100, 80, 100));
  allRoads.add(new Road(960, 100, 1000, 100));
  allRoads.add(new Road(500, 640, 500, 700));
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
  if (trueOrFalse() == true) {
    if (checkNearby(0, 120) == false) {
      allCars.add(new Car(0, 120, color(random(100, 255), random(100, 255), random(0, 255)), 5, 10, 10, 10, 10, 0));
    }
  } else {
    if (checkNearby(0, 620) == false) {
      allCars.add(new Car(0, 620, color(random(100, 255), random(100, 255), random(0, 255)), 5, 10, 10, 10, 10, 0));
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
