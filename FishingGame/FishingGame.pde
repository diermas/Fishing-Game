GameInstance game;

void setup() {
  size(500, 800);
  game = new GameInstance();
}

void draw() {
  game.runGame();
}

void keyPressed() {
  if (!game.levelWon) { // Button tracking for when the current level is still being played
    if (game.gameOver) { // If the game is over, check user input for restarting or exiting
      if (key == ENTER || key == RETURN) {
        exit();
      }
      if (key == ' ') { // Resets the game to level 1 and resets all stats and game objects
        game.reset();
      }
    } else {
      if (game.gameWon) {
        if (key == ENTER || key == RETURN) {
          exit();
        }
      } else {
        if (key == CODED) {
          if (!game.paused) { // If the game is not paused, accept user inputs for main controls
            if (keyCode == LEFT) {
              if (!game.hooking) {
                game.boat.xSpeed = -3;
                game.boat.direction = -1;
              } else { // Prevent movement when hooking
                game.boat.xSpeed = 0;
              }
            }
            if (keyCode == RIGHT) {
              if (!game.hooking) {
                game.boat.xSpeed = 3;
                game.boat.direction = 1;
              } else { // Prevent movement when hooking
                game.boat.xSpeed = 0;
              }
            }
            if (keyCode == DOWN) { // Down key launches hook if it isnt already out
              if (game.hook == null) {
                if (game.boat.direction == -1) {
                  game.hook = new Hook(game.boat.x-35);
                } else {
                  game.hook = new Hook(game.boat.x+85);
                }
                game.hooking = true;
                game.boat.xSpeed = 0;
              }
            }
            if (keyCode == UP) { // Up key reels in hook faster than waiting for it to reach the bottom
              if (game.hook != null) {
                game.hook.ySpeed = -10;
              }
            }
          }
        }
      }
    }
    if (key == ' ') { // Pause the game while the current level is being played
      game.paused = !game.paused;
    }
  } else { // If the level is won, check for pressing space to begin the next level
    if (key == ' ') {
      game.level++;
      game.levelWon = false;
      game.shoal = null;
    }
  }
}

void keyReleased() {
  if (key == CODED) {
    if (keyCode == LEFT || keyCode == RIGHT) {
      game.boat.xSpeed = 0;
    }
  }
}