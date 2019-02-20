class GameInstance {
  // Variables and objects for running the game
  Boat boat;
  Shoal shoal;
  Hook hook;
  PImage water; // Custom water image for nice gradient on the water
  boolean hooking; // Boolean to prevent movement while hook is out
  int score; // Tracks how many fish the player has caught
  int bestScore; // Tracks the best score of the player (during the currently running instance of the Processing sketch)
  int level; // For tracking the current level (starts with start meu (0))
  boolean levelWon; // By default set to true, changes to false upon creation of a new level
  boolean paused; // Toggles pausing the game
  boolean gameOver; // Triggered when the fish reach the top
  PrintWriter output;
  BufferedReader input;
  String scoreString;
  boolean gameWon; // Triggered when level 3 is cleared

  GameInstance() {
    boat = new Boat();
    shoal = null;
    hook = null;
    score = 0;
    level = 0;
    levelWon = true;
    paused = false;
    gameOver = false;
    water = loadImage("water.jpg");
    input = createReader("highScore.txt");
    gameWon = false;
    try {
      scoreString = input.readLine();    
      input.close();
    } 
    catch (IOException e) {
      e.printStackTrace();
    }
    if (scoreString == null) {
      bestScore = 0;
    } else {
      bestScore = Integer.valueOf(scoreString);
    }
  }

  void runGame() {
    chooseLevel(level);
  }



  // Switch statements to tell the game which level to draw
  void chooseLevel(int level) {
    switch (level) {
    case 0: 
      drawStart();
      break;
    case 1: 
      drawLevelOne();
      break;
    case 2: 
      drawLevelTwo();
      break;
    case 3: 
      drawLevelThree();
      break;
    case 4: 
      gameWon = true;
      drawWinScreen();
      break;
    default: 
      drawStart();
      break;
    }
  }
  // Draws the start menu (level 0)
  void drawStart() {
    background(0);
    image(water, 0, 150);
    strokeWeight(1);
    fill(0);
    text("Welcome to Extreme Fishing!", 160, 300);
    text("Controls:", 220, 320);
    text("UP: Reel hook in", 195, 340);
    text("LEFT/RIGHT: Move the boat", 170, 360);
    text("DOWN: Start hooking for fish", 170, 380);
    text("Press Space to Start.", 190, 400);
  }
  // Background and level settings, and creates the main shoal for Level 1
  void drawLevelOne() {
    background(0);
    stroke(255);
    fill(255);
    ellipse(450, 70, 80, 80);
    stroke(0);
    fill(0);
    ellipse(430, 70, 80, 80);
    image(water, 0, 150);
    fill(255);
    text("Score: "+score, 30, 30);
    text("High Score: "+bestScore, 30, 50);
    if (shoal == null) {
      shoal = new Shoal(4, 5, 3, -1);
    }
    playLevel();
  }
  // Background and level settings, and creates the main shoal for Level 2
  void drawLevelTwo() {
    background(#D3FFFC);
    stroke(#FFC329);
    fill(#FFC329);
    ellipse(480, 20, 50, 50);
    image(water, 0, 150);
    fill(0);
    text("Score: "+score, 30, 30);
    text("High Score: "+bestScore, 30, 50);
    if (shoal == null) {
      shoal = new Shoal(5, 6, 4, -1);
    }
    playLevel();
  }
  // Background and level settings, and creates the main shoal for Level 3
  void drawLevelThree() {
    background(#F57336);
    stroke(#EA5E2B);
    fill(#FF0900);
    ellipse(480, 130, 50, 50);
    image(water, 0, 150);
    fill(0);
    text("Score: "+score, 30, 30);
    text("High Score: "+bestScore, 30, 50);
    if (shoal == null) {
      shoal = new Shoal(6, 7, 5, -1);
    }
    playLevel();
  }
  // Draws the Game Win screen
  void drawWinScreen() {
    background(0);
    image(water, 0, 150);
    strokeWeight(1);
    fill(0);
    text("Congratulations!", 200, 400);
    text("You beat the game!", 200, 420);
    text("Your score: "+score, 200, 440);
    if (score+100 > bestScore) {
      bestScore = score+100;
    }
    text("High score: "+bestScore, 200, 260);
    text("Press Enter to exit.", 200, 480);
    output = createWriter("highScore.txt");
    output.println(bestScore);
    output.flush();
    output.close();
  }

  // Code for playing a level, regardless of which level is being played (moving boat, checking collisions, updating shoal etc.)
  void playLevel() {
    if (!paused && !gameOver) { // Renders and updates game objects when the game is not paused and has not been lost
      if (!levelWon) {
        boat.update();
        for (int i = 0; i < 3; i++) { // Draw red circles under for empty lives
          stroke(#FF0000);
          fill(#FF0000);
          ellipse(200+(i*40), 50, 30, 30);
        }
        for (int i = 0; i < boat.lives; i++) { // Draw green circles for owned lives
          stroke(#00FF00);
          fill(#00FF00);
          ellipse(200+(i*40), 50, 30, 30);
        }
        if (shoal != null) {
          shoal.update();
        }
        if (level > 0) {
          if (int(random(2000)) <= level) { // Random chance of spawning a shooter fish (odds increase per level)
            shoal.addShooter();
          }
        }
        if (hook != null) {
          hook.update();
        }
        checkCollisions();
      } else {
        boat.render();
        fill(0);
        text("Level Cleared!", 200, 350);
        text("Press Space to advance to the next level.", 140, 370);
      }
    } else {
      if (paused) { // If the game is paused, just render objects and display Pause text
        boat.render();
        if (shoal != null) {
          shoal.render();
        }
        if (hook != null) {
          hook.render();
        }
        fill(0);
        text("Game Paused", 200, 300);
        text("Press Space to resume.", 180, 320);
      } else if (gameOver) { // If the game is over, render objects and display the Game Over screen
        boat.render();
        if (shoal != null) {
          shoal.render();
        }
        fill(0);
        text("Game Over.", 200, 300);
        text("Press Space to restart or Enter to exit.", 130, 320);
      }
    }
  }

  // Check collisions with entities and game borders
  void checkCollisions() {  
    if (shoal != null) {
      if (shoal.reachTop()) {
        shoal.deleteShoal();
        gameOver = true;
        if (score>bestScore) {
          bestScore = score;
        }
        output = createWriter("highScore.txt");
        output.println(bestScore);
        output.flush();
        output.close();
      }
    }
    if (hook != null) {
      if (hook.offScreen()) {
        hook = null;
        hooking = false;
      }
    }
    if (shoal != null) {
      if (shoal.checkHooked()) { // Check to see if any normal fish have been hooked
        hook = null;
        hooking = false;
        score++;
        if (shoal.checkEmpty()) { // If the hooked fish is the last one from the main shoal, the level is clear
          levelWon = true;
          shoal = null;
        }
      }
      if (shoal != null) {
        if (shoal.checkSpecials()) { // Check to see if any special fish have been hooked (grants extra points)
          hook = null;
          hooking = false;
          score += 5;
        }
      }
    }
    if (shoal != null) {
      if (shoal.checkBoatShot()) { // Check to see if any bubbles have hit the boat
        boat.lives--;
        if (boat.lives == 0) { // Game Over if the boat has lost 3 lives
          shoal.deleteShoal();
          gameOver = true;
          if (score>bestScore) {
            bestScore = score;
          }
          output = createWriter("highScore.txt");
          output.println(bestScore);
          output.flush();
          output.close();
        }
      }
      shoal.checkBubblesTop();
    }
  }

  void reset() { // Reset to level 1
    level = 1;
    levelWon = false;
    shoal = null;
    hook = null;
    score = 0;
    paused = false;
    gameOver = false;
    boat.lives = 3;
  }
}