//FloodIt Project
color[] colors;      // 1D array of 6 colors
color[][] cArray;    // 2D array of colors
boolean[][] sArray;  // 2D array of true/false switches
                     // true/false stands for on/off
int turns;           // a variable to keep track of turns


// Color assignments
color C1 = color(255, 0, 0);
color C2 = color(0, 255, 0);
color C3 = color(0, 0, 255);
color C4 = color(255, 204, 0);
color C5 = color(255, 50, 203);
color C6 = color(128, 0, 128);

void setup() {
  size(340, 420);
  background(225);
  
  int b, i, j;
  color c;
  
  textSize(14);
  // Set the text size once for the draw loop
  
  turns = 0;   
  // initialize turns to 0 (not really necessary in Javascript)
    
  colors = {C1, C2, C3, C4, C5, C6};
  cArray = new int[12][12];
  sArray = new boolean[12][12];
  
  /* This setup loop does 3 things:
     1. assigns a random color to each block
     2. assigns the boolean value 'false' to each block
     3. draws the block at the assigned color
  */
  for(i = 0; i < cArray.length; i++) {
    for(j = 0; j < cArray[i].length; j++) {
      b = int(random(6));
      c = colors[b];
      cArray[i][j] = c;
      sArray[i][j] = false;
      noStroke();
      fill(c);
      rect(i*25+20, j*25+20, 25, 25);
    }
  }
  // set just the top left block to 'true'
  sArray[0][0] = true;
}  

void mousePressed() {
  
  color c, f;   
  
  if(((25 < mouseX) && (mouseX < 315)) && ((25 < mouseY) && (mouseY < 315))) {
    f = get(mouseX, mouseY);
  }
  else {
    f = cArray[0][0];
  }
    
  if (f != cArray[0][0]) {
    turns += 1;
  }
 
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

  for(i = 0; i < cArray.length; i++) {
    for(j = 0; j < cArray[i].length; j++) {
      n = cArray[i][j];
      c = colors[n];
      //noStroke();
      fill(n);
      rect(i*25+20, j*25+20, 25, 25);
    }
  }  
  
  /*
  A print loop to check values
  
  println(); println();
  for(i = 0; i < cArray.length; i++) {
   println(cArray[i]);
  }  
  */
  checkEndGame(turns);
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

/* This draw loop is solely for the Turn counter.
   Since board is just colored boxes that only change
   after a key press, it's not necessary to include
   them in the draw loop (you can just keep drawing
   over them).
*/

void draw() {
  fill(225);
  rect(0, 370, 120, 80);
  fill(30);
  text("Turns left: " + (23 - turns), 20, 400);  
}

void checkEndGame(int turns) {
  int t = turns; 
  if(t > 22) {
    setup();
  }
}
