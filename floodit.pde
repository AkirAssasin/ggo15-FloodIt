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
int tutLevel;

ArrayList pcles;

// Color assignments
color C1 = color(255);
color C2 = color(204);
color C3 = color(153);
color C4 = color(102);
color C5 = color(51);
color C6 = color(0);

var bgm = new Howl({
  urls: ['music/DarkMystery.mp3', 'music/DarkMystery.ogg'],
  loop: true,
});

var blip = new Howl({
  urls: ['music/sfx.mp3', 'music/sfx.ogg'],
  loop: false,
});

var door = new Howl({
  urls: ['music/door.mp3', 'music/door.ogg'],
  loop: false,
});

color lastC2;

// Checks whether a number is between a range to simplify code
Number.prototype.between = function (min, max) {
    return this > min && this < max;
}; 

void setup() {
  size(340, 420);
  bgm.play();
  pcles = new ArrayList();
    
  int b, i, j;
  color c;
  
  noCursor();
  colors = {C1, C2, C3, C4, C5, C6};
  cArray = new int[6][6];
  sArray = new boolean[6][6];
  sShake = new int[4];
}  

void mousePressed() {
  if (gameState == 0 || gameState == 2) {
    if (mouseX.between(130,205) && mouseY.between(185,215)){
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
    
    if (mouseX.between(130,205) && mouseY.between(255,285)){
      C1 = color(255);
      C2 = color(204);
      C3 = color(153);
      C4 = color(102);
      C5 = color(51);
      for(i = 0; i < cArray.length; i++) {
        for(j = 0; j < cArray[i].length; j++) {
          b = int(random(6));
          c = colors[b];
          cArray[i][j] = c;
          sArray[i][j] = false;
        }
      }
      // set just the top left block to 'true'
      sArray[0][0] = true;
      tutLevel = 0;
      gameState = 3;
    }
  }
  if (gameState == 3) {
    if (mouseX.between(130,205) && mouseY.between(375,450) && tutLevel == 1){gameState = 0;}
    fingerPress = 30;
    blip.play();
    if (tutLevel == 0 && mouseX.between(95,245) && mouseY.between(95,245)) {
      color c, f;   
        
      f = get(mouseX, mouseY);
        
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
  if (gameState == 1) {
    blip.play();
    fingerPress = 30;
    if (dist(mouseX,mouseY,53,395) < 40) {
        step += round(hp/2);
        hp = 0;
    }
    if (cutscene >= 0 && mouseX.between(95,245) && mouseY.between(95,245)) {
      color c, f;   
        
      f = get(mouseX, mouseY);
      
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
  highScore = $.jStorage.get("fgHighScore", 0);
    
  textSize(14);
    
  if (gameState == 3) {
      background(225);
      if (tutLevel == 0) {
        fill(30);
        textSize(35);
        text("Floodgate Dungeon",15,30);
        textSize(20);
        text("How To Play",115,60);
        textSize(15);
        text("Click on a block.",115,270);
        text("The top-left block with change into that color.",20,300);
        text("All blocks connected to the top-left block will",20,315);
        text("also change to that color.",85,330);
        text("Turn all blocks to the same color to proceed.",20,345);
        strokeWeight(1);
        fill(0);
        stroke(0);
        rect(90,90,160,160);
        for(i = 0; i < cArray.length; i++) {
          for(j = 0; j < cArray[i].length; j++) {
            n = cArray[i][j];
            c = colors[n];
            stroke(n);
            fill(n);
            rect(i*25+95, j*25+95, 25, 25);
          }
        }
        int helpAllCheck = 0;
        for(i = 0; i < cArray.length; i++) {
          for(j = 0; j < cArray[i].length; j++) {
            if (cArray[i][j] == cArray[0][0]) {
              helpAllCheck += 1;
            }
          }
        } 
        if (helpAllCheck >= 36) {
          tutLevel = 1;
        }
      }
      
      if (tutLevel == 1) {
        fill(30);
        textSize(35);
        text("Floodgate Dungeon",15,30);
        textSize(20);
        text("How To Play",115,60);
        textSize(15);
        text("Not bad!",145,85);
        text("Note that most doors have limited steps.",30,100);
        text("Red doors has seconds before it explodes.",20,115);
        text("Notice a device on your left hand.",55,160);
        text("When you have excess steps it is turned",30,175);
        text("into H4POINTS. H4POINTS can be used to",20,190);
        text("add steps or time to unlock the door.",40,205);
        text("press the circular button to use it.",50,220);
        text("Yellow doors give x2 H4POINTS!",50,235);
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
        textSize(14);
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
        fill(30);
        textSize(30);
        text("Done",132,400);
        fill(0,0);
        rect(130,375,75,30);
      }
      finger();
  }

  if (gameState == 0 || gameState == 2) {
    background(225);
    fill(30);
    textSize(30);
    text("Start",135,210);
    text("Help",136,280);
    textSize(35);
    text("Floodgate Dungeon",15,150);
    strokeWeight(1);
    fill(0,0);
    rect(130,185,75,30);
    rect(130,255,75,30);
    fill(30);
    textSize(20);
    text("High score: " + highScore,110,390);
    finger();
  }
  
  if (gameState == 2) {
    fill(30);
    textSize(20);
    text("Score: " + score,140,370);
  }
    
  if (gameState == 1) {
    textSize(14);
    background(C2);
    if (cutscene > 0) {
      cutsceneAnim();
      cutscene -= 1;
    } else {
      stroke(30);
      strokeWeight(1);
      fill(30);
      if (doorMode == 2) {
        step -= 1/60;
      }
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
    textSize(14);
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
    checkEndGame();
    
    for (int i=pcles.size()-1; i>=0; i--) {
      Particle p = (Pcle) pcles.get(i);
      p.update();
      if (p.fa < 0) {pcles.remove(i);}
    }
    //text(mouseX + "," + mouseY,mouseX,mouseY);
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
    if (doorMode == 1) {hp += round(step*2);} else {hp += round(step);}
    lastColor = cArray[0][0];
    score += 1;
    cutscene = 300;
    door.play();
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
    if (score > highScore) {$.jStorage.set("fgHighScore", score);}
    gameState = 2;
  }
}

void switchMode() {
  lastC2 = C2;
  doorMode = chance.pick([0,1,2]);
  C6 = color(0);
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
    C1 = color(255,255,0);
    C2 = color(204,204,0);
    C3 = color(153,153,0);
    C4 = color(102,102,0);
    C5 = color(51,51,0);
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
  ellipse(mouseX+30 - (fingerPress - fingerOffset),mouseY+30 - (fingerPress - fingerOffset),30,30);
  ellipse(mouseX+92- (fingerPress - fingerOffset),mouseY+95- (fingerPress - fingerOffset),30,30);
  ellipse(mouseX+112- (fingerPress - fingerOffset),mouseY+86- (fingerPress - fingerOffset),30,30);
  ellipse(mouseX+132- (fingerPress - fingerOffset),mouseY+85- (fingerPress - fingerOffset),30,30);
  translate(mouseX+39- (fingerPress - fingerOffset),mouseY+79- (fingerPress - fingerOffset));
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
  translate(0 - (mouseX+57- (fingerPress - fingerOffset)),0 - (mouseY+79- (fingerPress - fingerOffset)));
}

void cutsceneAnim() {
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

class Pcle {
  float x;
  float y;
  float vx;
  float vy;
  float r;
  float g;
  float b;
  float s;
  float a;
  float fa;
 
  Pcle(ox,oy,or,og,ob,oa,os) {
    x = ox;
    y = oy;
    r = or;
    g = og;
    b = ob;
    a = oa;
    s = os;
  }
  
  void update() {
    fa = a*((x - 250)/170);
    stroke(r,g,b,fa/2);
    fill(r,g,b,fa);
    rect(x - s/2,y - s/2,s,s);
    vx += random(-1,1);
    vy -= 0.1;
    x += vx;
    y += vy;
  }
}
