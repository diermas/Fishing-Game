class Fish {
  int x;
  int y;
  int xSpeed;
  int ySpeed;
  int count; // Count ticks to animate the fish with moving tails
  color colour;

  Fish(int x, int y) {
    this.x = x;
    this.y = y;
    xSpeed = 0;
    ySpeed = 0;
    colour = #FFA40F;
  }

  void render() {
    stroke(colour);
    fill(colour);
    if (xSpeed > 0) { // Fish moving right
      ellipse(x+25, y+20, 20, 20);
      if ((count>=0 && count<20) || count==40) { // Count ticks to animate the fish tail
        if (count == 40) {
          count = 0;
        }
        triangle(x+15, y+20, x+15-count/2, y+10, x+15-count/2, y+30); // Decrease the tail size based on current count value
        count++;
      } else if (count>=20 && count<40) {
        triangle(x+15, y+20, x+15-(40-count)/2, y+10, x+15-(40-count)/2, y+30); // Increase the tail size based on count
        count++;
      }
    } else if (xSpeed < 0) { // Fish moving left
      ellipse(x+15, y+20, 20, 20);
      if ((count>=0 && count<20) || count==40) {
        if (count == 40) {
          count = 0;
        }
        triangle(x+25, y+20, x+25+count/2, y+10, x+25+count/2, y+30);
        count++;
      } else if (count>=20 && count<40) {
        triangle(x+25, y+20, x+25+(40-count)/2, y+10, x+25+(40-count)/2, y+30);
        count++;
      }
    } else { // Fish moving up
      ellipse(x+20, y+15, 20, 20);
      if ((count>=0 && count<20) || count==40) {
        if (count == 40) {
          count = 0;
        }
        triangle(x+20, y+25, x+10, y+25+count/2, x+30, y+25+count/2);
        count++;
      } else if (count>=20 && count<40) {
        triangle(x+20, y+25, x+10, y+25+(40-count)/2, x+30, y+25+(40-count)/2);
        count++;
      }
    }
  }

  void move() {
    x += xSpeed;
    y += ySpeed;
  }

  // For each pixel inside the fish's box (30x30 with a 5px space each side), check if the colour is the HOOK colour
  boolean hooked() {
    for (int i = 0; i < 30; i++) {
      for (int j = 0; j < 30; j++) {
        // Add 5 and i/j to y/x to account for the margins around each fish
        int testX = x+5+j;
        int testY = y+5+i;
        color test = get(testX, testY);
        if (test == color(#909090)) {
          return true;
        }
      }
    }
    return false;
  }
}