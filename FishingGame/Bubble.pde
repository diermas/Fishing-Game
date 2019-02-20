class Bubble {
  int x;
  int y;
  int ySpeed;
  int xSpeed;
  int count; // Count ticks to give bubble slight variation on x movement

  Bubble(int x, int y) {
    this.x = x;
    this.y = y;
    ySpeed = -5;
    xSpeed = 0;
    count = 0;
  }

  void render() {
    strokeWeight(2);
    fill(#E0FEFF);
    stroke(#ADE6E8);
    ellipse(x, y, 15, 15);
    strokeWeight(1);
  }

  void move() {
    y += ySpeed;
    if (count % 20 == 0) { // Bubbles will randomly change xSpeed every so often to add unpredictable movement
      xSpeed = int(random(-3, 3));
    }
    x += xSpeed;
    count++;
  }
}