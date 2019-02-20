class Shooter extends Fish {
  int shootCount; // Counter to limit how often each fish can shoot

  Shooter(int x, int y) {
    super(x, y);
    colour = #3FFF00;
    shootCount = 0;
  }

  void move() { // Different move since shooter fish only move side to side
    ySpeed = 0;
    if (x == 0) {
      xSpeed = 2;
    } else if (x == width-40) {
      xSpeed = -2;
    }
    x += xSpeed;
    y+= ySpeed;
    shootCount++;
  }

  boolean canShoot() { // Checks if a shooter fish is able to shoot
    if (shootCount % 300 == 0 && shootCount > 0) {
      return true;
    }
    return false;
  }
}