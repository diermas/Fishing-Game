class Hook {
  int x;
  int y;
  int ySpeed;

  Hook(int x) {
    this.x = x;
    y = 50; // y=50 is the position of the top of the rod
    ySpeed = 5;
  }

  void render() {
    // Draw the rope
    stroke(255);
    strokeWeight(2);
    line(x, 50, x, y);
    // Draw the hook
    stroke(#909090);
    fill(#909090);
    line(x, y, x, y+20);
    line(x-10, y+20, x+10, y+20);
    strokeWeight(1);
  }

  void update() {
    move();
    render();
  }

  void move() {
    y += ySpeed;
  }

  // Check if the hook moves off the bottom of the screen
  boolean offScreen() {
    if (y+20>height || (y>=50 && y+ySpeed<=50)) {
      return true;
    }
    return false;
  }
}