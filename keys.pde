void keyPressed() {
  if (key == 'a') {
    allCars.get(0).turningRight = true;
  }
  if (key == 's') {
    allCars.get(0).turningLeft = true;
  }
  if (key == 'd') {
    spawnCar();
  }
}
