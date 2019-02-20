class Shoal {
  Fish[][] fishes; // 2D grid to store fish, allows setting larger shoals in later levels
  int x;
  int y;
  int xSpeed;
  int ySpeed;
  int yCount;
  int maxYSpeed;
  ArrayList<Shooter> specials;
  ArrayList<Bubble> bubbles;

  Shoal(int rows, int columns, int xSpeed, int maxYSpeed) {
    fishes = new Fish[rows][columns];
    x = 0;
    y = 760;
    this.xSpeed = xSpeed;
    ySpeed = 0;
    this.maxYSpeed = maxYSpeed; // maxYSpeed is the value assigned when the shoal hits the sides, otherwise ySpeed should be 0
    // Two loops to create a grid of fish (each in a space of 40x40) based on the size passed in by constructor
    for (int i = 0; i < fishes.length; i++) {
      for (int j = 0; j < fishes[i].length; j++) {
        fishes[i][j] = new Fish(x+(j*40), y+(i*40));
      }
    }
    specials = new ArrayList<Shooter>();
    bubbles = new ArrayList<Bubble>();
  }

  void move() {
    // yCount is used so that the fish only move a certain y distance before moving in the x direction again 
    if (yCount>0) {
      ySpeed = maxYSpeed;
      y += ySpeed;
      moveFishes();
      yCount--;
    } else {
      ySpeed = 0;
      if (x == 0) {  // Move right if at the far left
        xSpeed = 2;
      } else if (x == width-(40*fishes[0].length)) { // Move left if at the far right
        xSpeed = -2;
      }
      if (x>=0 && x+xSpeed<=0) { // If the shoal would move off the left, put it at the far left and begin moving up
        x = 0;
        xSpeed = 0;
        yCount = abs(40/maxYSpeed);
      }
      if (x+(40*fishes[0].length)<=width && x+xSpeed+(40*fishes[0].length)>=width) { // If the shoal would move off the right, put it at the far right and begin moving up
        x = width-(40*fishes[0].length);
        xSpeed = 0;
        yCount = abs(40/maxYSpeed);
      }
      x += xSpeed;
      moveFishes();
    }
  }

  // Cycle through and move each fish, special fish and bubble
  void moveFishes() {
    for (int i = 0; i < fishes.length; i++) {
      for (int j = 0; j < fishes[i].length; j++) {
        if (fishes[i][j] != null) {
          fishes[i][j].xSpeed = xSpeed;
          fishes[i][j].ySpeed = ySpeed;
          fishes[i][j].move();
        }
      }
    }
    for (int i = 0; i < specials.size(); i++) {
      specials.get(i).move();
    }
    for (int i = 0; i < bubbles.size(); i++) {
      bubbles.get(i).move();
    }
  }

  // Cycle through and draw each fish, special fish and bubble
  void render() {
    for (int i = 0; i < fishes.length; i++) {
      for (int j = 0; j < fishes[i].length; j++) {
        if (fishes[i][j] != null) {
          fishes[i][j].render();
        }
      }
    }
    for (int i = 0; i < specials.size(); i++) {
      specials.get(i).render();
    }
    for (int i = 0; i < bubbles.size(); i++) {
      bubbles.get(i).render();
    }
  }

  void checkShooters() { // Check to see if any shooter fish can shoot a bubble
    for (int i = 0; i < specials.size(); i++) {
      if (specials.get(i).canShoot()) {
        bubbles.add(new Bubble(specials.get(i).x, specials.get(i).y));
      }
    }
  }

  void update() {
    move();
    render();
    checkShooters();
  }

  // Clear all the fish in the shoal
  void deleteShoal() {
    for (int i = 0; i < fishes.length; i++) {
      for (int j = 0; j < fishes[i].length; j++) {
        if (fishes[i][j] != null) {
          fishes[i][j] = null;
        }
      }
    }
    specials.clear();
    bubbles.clear();
  }

  // Check to see if any surviving fish have reached the top of the water
  boolean reachTop() {
    for (int i = 0; i < fishes.length; i++) {
      for (int j = 0; j < fishes[i].length; j++) {
        if (fishes[i][j] != null) {
          if (fishes[i][j].y <= 150) {
            return true;
          }
        }
      }
    }
    return false;
  }

  // Check to see if any surviving fish have been hooked
  boolean checkHooked() {
    for (int i = 0; i < fishes.length; i++) {
      for (int j = 0; j < fishes[i].length; j++) {
        if (fishes[i][j] != null) {
          if (fishes[i][j].hooked()) {
            // Delete the first fish to be hooked and return true (prevents multiple catches per hook)
            fishes[i][j] = null;
            return true;
          }
        }
      }
    }
    return false;
  }

  boolean checkSpecials() { // Check the arraylist of special fish
    for (int i = 0; i < specials.size(); i++) {
      if (specials.get(i).hooked()) {
        specials.remove(i);
        return true;
      }
    }
    return false;
  }

  // Check if the shoal has all been deleted (checked after successful hooks)
  boolean checkEmpty() {
    for (int i = 0; i < fishes.length; i++) {
      for (int j = 0; j < fishes[i].length; j++) {
        if (fishes[i][j] != null) {
          return false;
        }
      }
    }
    return true;
  }

  void addShooter() { // Add a new shooter fish
    specials.add(new Shooter(0, 500));
  }

  boolean checkBoatShot() { // Check if any bubble has reached the boat
    for (int i = 0; i < bubbles.size(); i++) {
      Bubble bubble = bubbles.get(i);
      for (int j = bubble.x - 10; j < bubble.x + 10; j++) {
        for (int k = bubble.y - 10; k < bubble.y + 10; k++) {
          color test = get(j, k);
          if (test == color(#9B6114)) {
            bubbles.remove(i);
            return true;
          }
        }
      }
    }
    return false;
  }

  void checkBubblesTop() {
    for (int i = 0; i < bubbles.size(); i++) {
      if (bubbles.get(i).y < 0) {
        bubbles.remove(i);
      }
    }
  }
}