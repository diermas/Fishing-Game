class Boat {
  int x;
  int y;
  int xSpeed;
  int direction = -1; // Initial direction set to left for drawing stick man
  int lives = 3;

  Boat() {
    x = 200;
    y = 130;
    xSpeed = 0;
  }

  void render() {
    // Draw the boat
    fill(#9B6114);
    stroke(#9B6114);
    rect(x, y, 50, 30);
    triangle(x, y, x, y+30, x-30, y);
    triangle(x+50, y, x+50, y+30, x+80, y);
    if (direction == -1) { // Check facing left
      // Draw the fisher
      fill(255, 255, 0);
      stroke(255, 255, 0);
      ellipse(x-10, y-50, 20, 20);
      line(x-10, y-50, x, y);
      line(x-25, y-20, x-5, y-20);
      // Draw the rod
      stroke(255, 0, 0);
      strokeWeight(2);
      line(x-20, y-5, x-35, y-80);
      strokeWeight(1);
    } else { // Draw facing right
      // Draw the fisher
      fill(255, 255, 0);
      stroke(255, 255, 0);
      ellipse(x+60, y-50, 20, 20);
      line(x+60, y-50, x+50, y);
      line(x+75, y-20, x+55, y-20);
      // Draw the rod
      stroke(255, 0, 0);
      strokeWeight(2);
      line(x+70, y-5, x+85, y-80);
      strokeWeight(1);
    }
  }

  void move() {
    if (x-35>=0 && x-35+xSpeed<=0) { // Limit movement on the left of the screen
      x = 35;
      xSpeed = 0;
    }
    if (x+85<=width && x+85+xSpeed>=width) { // Limit movement on the right of the screen
      x = width-85;
      xSpeed = 0;
    }
    x += xSpeed;
  }

  void update() {
    move();
    render();
  }
}