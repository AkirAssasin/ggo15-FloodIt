//FloodIt Project
color[] colors;      // 1D array of 6 colors
color[][] cArray;    // 2D array of colors
boolean[][] sArray;  // 2D array of true/false switches
                     // true/false stands for on/off
int hp;              // a variable to keep track of currency
int fingerPress;     // a variable to keep track of pressing animation
int fingerOffset;    // a variable to smooth things after cutscene
int cutscene;        // a variable to keep track of cutscene animations
color lastColor;     // color to display on cutscene
int[] sShake;        // screenshake on cutscene. [0] determines X direction, [1] determines X movement, [2] determines Y direction, [3] determines Y movement
int gameState;       // a variable to keep track of states. 0 = initial main menu, 1 = game, 2 = main menu
int highScore;       // we obtain this from a stored value with jStorage
int score;
int step;
int doorMode;
int waterLevel;
int fX;
int fY;

// Color assignments
color C1 = color(255);
color C2 = color(204);
color C3 = color(153);
color C4 = color(102);
color C5 = color(51);
color C6 = color(0);

color lastC2;

// Checks whether a number is between a range to simplify code
Number.prototype.between = function (min, max) {
    return this > min && this < max;
}; 

void setup() {
  size(340, 420);
  
  int b, i, j;
  color c;
  
  noCursor();
  colors = {C1, C2, C3, C4, C5, C6};
  cArray = new int[6][6];
  sArray = new boolean[6][6];
  sShake = new int[4];
}  

void mousePressed() {
  if (fingerPress <= 0) {
  if (gameState == 0 || gameState == 2) {
    switchMode();
    for(i = 0; i < cArray.length; i++) {
      for(j = 0; j < cArray[i].length; j++) {
        b = int(random(6));
        c = colors[b];
        cArray[i][j] = c;
        sArray[i][j] = false;
      }
    }
    gameState = 1;
    score = 0;
    // set just the top left block to 'true'
    sArray[0][0] = true;
  }
  
  if (gameState == 1) {
    
    fingerPress = 30;
    if (dist(fX,fY,53,395) < 40) {
        step += round(hp/2);
        hp = 0;
    }
    if (cutscene >= 0 && fX.between(95,245) && fY.between(95,245)) {
      color c, f;   
        
      f = get(fX, fY);
      
      if ((doorMode == 0 || doorMode == 1) && f != cArray[0][0]) {step -= 1;}
        
      int xpos = 0;
      int ypos = 0;
      int target = cArray[0][0];
    
      cArray[0][0] = f;      
      // always set the top left box to the new color c
      sArray[0][0] = true;
      // Boolean flag of top left box is always true
      // in other words, it's the root of the tree
      
      
      /* Here we are looping through the 2-dimensional array of color values 
         called cArray */
      for(xpos = 0; xpos < cArray.length; xpos++) {
        for(ypos = 0; ypos < cArray.length; ypos++) {
          /* If we are at cArray[0][0] (top left square, don't do anything 
             because sArray, the corresponding array of booleans, is already
             true at this index from initialization */ 
          if ((xpos == 0) && (ypos == 0)) {
          }
          /* Now check to see if the color value at the current index does NOT
             match the value of target and if so don't do anything */
          else if(cArray[xpos][ypos] != target) {
          }
          /* If color value at index DOES match target (fallthrough condition from 
             conditional above, run CheckNeighbor function below. If CheckNeighbor
             evaluates to true, update the cell to the current color f (the color
             that was clicked on) and it's boolean value to true. */
          else if(checkNeighbor(xpos, ypos) == true) {
              cArray[xpos][ypos] = f;
              sArray[xpos][ypos] = true;
          }
        }
      }
    }
  }
  }
}

void keyPressed() {
  for(i = 0; i < cArray.length; i++) {
    for(j = 0; j < cArray[i].length; j++) {
      cArray[i][j] = cArray[0][0];
      }
    }
}

/* CheckkNeighbor checks to see if any of a cell's 4 adjacent neighbors have 
   a value of true. A neighbor must have a value of true for the cell to change
   color, since the color must be connected to the tree of cells that are connected
   to the root (the upper left cell). */
boolean checkNeighbor(xpos, ypos) {
  if( (xpos > 0) && (sArray[xpos - 1][ypos]) == true) {
    return true;
  }
  if( (ypos > 0) && (sArray[xpos][ypos - 1]) == true ) {
    return true;
  }
  if( (xpos < sArray.length - 1) && (sArray[xpos + 1][ypos] == true) ) {
    return true;
  }
  if( (ypos < sArray.length - 1) && (sArray[xpos][ypos + 1] == true) ) {
    return true;
  }
}

void draw() {
  if (doorMode != 1) {
    fX = mouseX;
    fY = mouseY;
  } else {
    if (fX > mouseX) {fX -= 10 - 9*(waterLevel/420);}
    if (fX < mouseX) {fX += 10 - 9*(waterLevel/420);}
    if (fY > mouseY) {fY -= 10 - 9*(waterLevel/420);}
    if (fY < mouseY) {fY += 10 - 9*(waterLevel/420);}
  }
    
  if (gameState == 0 || gameState == 2) {
    background(225);
    strokeWeight(10);
    stroke(30);
    line(fX,fY,fX,fY);
    fill(30);
    text("Click anywhere to Start",100,210);
  }
  
  if (gameState == 2) {
    fill(30);
    text("Score: " + score,100,170);
    text("High score: " + highScore,100,190);
  }
    
  if (gameState == 1) {
    if (waterLevel < 0) {waterLevel = 0;}
    textSize(14);
    background(C2);
    stroke(30);
    strokeWeight(1);
    fill(30);
    if (cutscene > 0) {
      cutsceneAnim();
      cutscene -= 1;
    } else {
      if (doorMode == 1) {
        step -= 1/300;
        waterLevel += 1/10;  
      }
      if (doorMode == 2) {step -= 1/60;}
      if (fingerOffset > 0) {fingerOffset -= (500/60)};
      if (fingerOffset < 0) {fingerOffset = 0};
      rect(90,90,160,160);
      rect(165,0,10,400);
      rect(0,395,340,10);
      rect(100,60,140,30);  
      fill(C1);
      rect(105,65,130,20);  
      fill(30);
      text(round(step),165,82);
      for(i = 0; i < cArray.length; i++) {
        for(j = 0; j < cArray[i].length; j++) {
          n = cArray[i][j];
          c = colors[n];
          stroke(n);
          fill(n);
          rect(i*25+95, j*25+95, 25, 25);
        }
      }
    }
    fill(225);
    translate(80,430 + fingerOffset);
    strokeWeight(30);
    stroke(150);
    line(-100,-140,0,-150);
    line(0,-95,30,-100);
    stroke(0);
    strokeWeight(5);
    rotate(10/57.3);
    rect(0,0,-100,-130);
    stroke(30);
    fill(30);
    strokeWeight(1);
    beginShape();
      vertex(150,0);
      vertex(170,-20);
      vertex(170,-20);
      vertex(150,0);
    endShape();
    text("H4CK 0.95.1", -90,-110); 
    textSize(13);
    text(hp + " H4P01NTS", -90,-70); 
    fill(225);
    ellipse(-50,-25,40,40);
    textSize(13);
    fill(30);
    text("+ " + round(hp/2), -60,-22); 
    rotate(-10/57.3);
    strokeWeight(30);
    stroke(150);
    line(30,-100,30,-100);
    line(30,-70,15,-60);
    translate(-80,-430 - fingerOffset);
    strokeWeight(1);
    finger();
    if (doorMode == 1) {
      stroke(0,0,150,50);
      fill(0,0,150,50);
      rect(0,420,420, 0 - waterLevel);    
    }
    checkEndGame();
    //text(fX + "," + fY,fX,fY);
  }
  
}

void checkEndGame() {
  int allCheck = 0;
  for(i = 0; i < cArray.length; i++) {
    for(j = 0; j < cArray[i].length; j++) {
      if (cArray[i][j] == cArray[0][0]) {
        allCheck += 1;
      }
    }
  } 
  if (allCheck >= 36) {
    hp += round(step);
    lastColor = cArray[0][0];
    score += 1;
    cutscene = 300;
    sShake[0] = 0;
    sShake[1] = 0;
    sShake[2] = 0;
    sShake[3] = 0;
    switchMode();
    for(i = 0; i < cArray.length; i++) {
      for(j = 0; j < cArray[i].length; j++) {
        b = int(random(6));
        c = colors[b];
        cArray[i][j] = c;
        sArray[i][j] = false;
      }
    }
    sArray[0][0] = true; 
  }
  if(step <= 0 && allCheck < 36) {
    score += hp;
    hp = 0;
    waterLevel = 0;
    if (score > highScore) {highScore = score;}
    gameState = 2;
  }
}

void switchMode() {
  lastC2 = C2;
  doorMode = chance.pick([0,1,2]);
  switch(doorMode) {
  case 0:
    step = round(random(14,19));
    C1 = color(255);
    C2 = color(204);
    C3 = color(153);
    C4 = color(102);
    C5 = color(51);
    break;
  
  case 1:
    step = round(random(16,21));
    C1 = color(0,255,255);
    C2 = color(0,204,204);
    C3 = color(0,153,153);
    C4 = color(0,102,102);
    C5 = color(0,51,51);
    break;
  
  case 2:
    step = round(random(10,15));
    C1 = color(255,0,0);
    C2 = color(204,0,0);
    C3 = color(153,0,0);
    C4 = color(102,0,0);
    C5 = color(51,0,0);
    break;
  }
  colors = {C1, C2, C3, C4, C5, C6};
}

void finger() {
  if (fingerPress > 0) {fingerPress -= 1};
  if (fingerPress < 0) {fingerPress = 0};
  fill(150);
  stroke(150);
  ellipse(fX+30 - (fingerPress - fingerOffset),fY+30 - (fingerPress - fingerOffset),30,30);
  ellipse(fX+92- (fingerPress - fingerOffset),fY+95- (fingerPress - fingerOffset),30,30);
  ellipse(fX+112- (fingerPress - fingerOffset),fY+86- (fingerPress - fingerOffset),30,30);
  ellipse(fX+132- (fingerPress - fingerOffset),fY+85- (fingerPress - fingerOffset),30,30);
  translate(fX+39- (fingerPress - fingerOffset),fY+79- (fingerPress - fingerOffset));
  rotate(1.1);
  rect(-50,-30,100,30);
  rect(49,0,550,-100);
  fill(0);
  stroke(0);
  rect(49,5,100,-110);
  fill(150);
  stroke(150);
  // rect(49,0,50,-100);
  rotate(-1.1);
  translate(0 - (fX+57- (fingerPress - fingerOffset)),0 - (fY+79- (fingerPress - fingerOffset)));
}

void cutsceneAnim() {
   if (waterLevel > 0) {waterLevel -= 2;}
    
  if (cutscene > 200) {
    strokeWeight(1);
    fill(C2);
    stroke(30);
    fingerOffset += 5;
    
    beginShape();
      vertex(0,380);
      vertex(130,200);
      vertex(210,200);
      vertex(340,380);
      vertex(0,380);
    endShape();
    
    beginShape();
      vertex(0,0);
      vertex(130,100);
      vertex(210,100);
      vertex(340,0);
      vertex(0,0);
    endShape();
    
    line(130,200,130,100);
    line(210,200,210,100);
    line(170,200,170,100);
     
    fill(lastC2);
    stroke(lastC2);
    rect(0,381,340,100);
    stroke(30);
      
    fill(lastC2);
    rect(0,0 - (300 - cutscene)*4,340,400);
    fill(30);
    rect(90,90 - (300 - cutscene)*4,160,160);
    rect(0,395 - (300 - cutscene)*4,340,10);
    fill(lastColor);
    rect(95,95 - (300 - cutscene)*4,150,150);
    
    strokeWeight(15);
    stroke(0);
    line(138,179 - (300 - cutscene)*4,170,200 - (300 - cutscene)*4);
    line(170,200 - (300 - cutscene)*4,200,135 - (300 - cutscene)*4);
    
    strokeWeight(13);
    stroke(255);
    line(138,179 - (300 - cutscene)*4,170,200 - (300 - cutscene)*4);
    line(170,200 - (300 - cutscene)*4,200,135 - (300 - cutscene)*4);
  }
  
  if (cutscene <= 200) {
    
    if (sShake[0] == 0) {sShake[1] -= 0.9};
    if (sShake[1] < -11.1 && sShake[0] == 0) {sShake[0] = 1};
    if (sShake[0] == 1) {sShake[1] += 0.9};
    if (sShake[1] > 11.1 && sShake[0] == 1) {sShake[0] = 0};  
      
    if (sShake[2] == 0) {sShake[3] -= 1};
    if (sShake[3] <= 0 && sShake[2] == 0) {sShake[2] = 1};
    if (sShake[2] == 1) {sShake[3] += 1};
    if (sShake[3] > 11 && sShake[2] == 1) {sShake[2] = 0};  
      
    fill(C2);
    stroke(30);
    strokeWeight(10 - 9*(cutscene/200));
    
    beginShape();
      vertex(0 - (200 - cutscene) + sShake[1],380 + (200 - cutscene) + sShake[3]);
      vertex(130 - (200 - cutscene) + sShake[1],200 + (200 - cutscene) + sShake[3]);
      vertex(210 + (200 - cutscene) + sShake[1],200 + (200 - cutscene) + sShake[3]);
      vertex(340 + (200 - cutscene) + sShake[1],380 + (200 - cutscene) + sShake[3]);
      vertex(0 - (200 - cutscene) + sShake[1],380 + (200 - cutscene) + sShake[3]);
    endShape();
    
    beginShape();
      vertex(0 - (200 - cutscene) + sShake[1],0 - (200 - cutscene) + sShake[3]);
      vertex(130 - (200 - cutscene) + sShake[1],100 - (200 - cutscene) + sShake[3]);
      vertex(210 + (200 - cutscene) + sShake[1],100 - (200 - cutscene) + sShake[3]);
      vertex(340 + (200 - cutscene) + sShake[1],0 - (200 - cutscene) + sShake[3]);
      vertex(0 - (200 - cutscene) + sShake[1],0 - (200 - cutscene) + sShake[3]);
    endShape();
    
    fill(lastC2);
    stroke(lastC2);
    rect(0,381 + (200 - cutscene) + sShake[3],340,100);
    stroke(30);  
      
    line(130 - (200 - cutscene) + sShake[1],200 + (200 - cutscene) + sShake[3],130 - (200 - cutscene) + sShake[1],100 - (200 - cutscene) + sShake[3]);
    line(210 + (200 - cutscene) + sShake[1],200 + (200 - cutscene) + sShake[3],210 + (200 - cutscene) + sShake[1],100 - (200 - cutscene) + sShake[3]);
    line(170 + sShake[1],200 + (200 - cutscene) + sShake[3],170 + sShake[1],100 - (200 - cutscene) + sShake[3]);
    
    strokeWeight(1);
    fill(30);
    rect(90 + 80*(cutscene/200) + sShake[1],90 + 80*(cutscene/200) + sShake[3],160 - 160*(cutscene/200),160 - 160*(cutscene/200));
    rect(100 + 70*(cutscene/200) + sShake[1],60 + 110*(cutscene/200) + sShake[3],140 - 140*(cutscene/200),30 - 30*(cutscene/200));  
    fill(C1);
    rect(105 + 65*(cutscene/200) + sShake[1],65 + 105*(cutscene/200) + sShake[3],130 - 130*(cutscene/200),20 - 20*(cutscene/200));
    textSize(14 - 13*(cutscene/200));
    fill(30);
    text(round(step),165 + 5*(cutscene/200) + sShake[1],82 + 88*(cutscene/200) + sShake[3]);
    textSize(14);
    
    for(i = 0; i < cArray.length; i++) {
      for(j = 0; j < cArray[i].length; j++) {
        n = cArray[i][j];
        c = colors[n];
        stroke(n);
        fill(n);
        rect(i*(25 - 25*(cutscene/200))+(95 + 75*(cutscene/200)) + sShake[1], j*(25 - 25*(cutscene/200))+(95 + 75*(cutscene/200)) + sShake[3], 25 - 25*(cutscene/200), 25 - 25*(cutscene/200));
      }
    }
  }
}
