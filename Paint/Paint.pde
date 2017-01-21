/**
*  Drawing Application
*  Thomas Jordan - tmajordan@gmail.com
*********************************************************
*  Icons by Freepik, SimpleIcon, and Vectorgraphit from www.flaticon.com are licensed by CC BY 3.0
*  Except the SHAPE.svg, that's mine but I'd license it as CC if it was any good.
*  GUI and some functions inspired by Paper for iPad
*/

GUIButton[] buttons;
GUIButton selectedButton;
GUIButton helpButton;
String helpText = "Press up and down to change tool size.\nClick color selector (far right) to change color.\nClick Filter button to change filters.\nClear will clear entire drawing!";
String[] modes = {"MARKER", "PENCIL", "PEN", "BRUSH", "SHAPE", "SPRAY", "FILTER", "ERASER", "FILL", "CLEAR", "COLOR"};
color buttonColor = color(255);
color bHoverColor = color(163, 217, 255);
color toolColor = color(0);
color bgColor = color(255);
int toolbarHeight = 100;
int buttonSize = 50;
String mode = "";
PFont font;

void setup() {
  size(700, 700);
  background(bgColor);
  frameRate(120);
  //Font used for tooltips
  font = loadFont("OpenSans-14.vlw");
  textFont(font);
  initButtons();
}

void draw() {
  drawToolbar();
  drawButtons();
  
  //Change cursor as user is in drawing area
  if (mouseY > toolbarHeight) {
    cursor(CROSS);  
  }
  //Draw based on mode
  if(mousePressed && mouseY > toolbarHeight && pmouseY > toolbarHeight) {
    //The default, draw a simple line
    if (mode == "MARKER") {
      strokeWeight(selectedButton.getStrokeWeight());
      stroke(toolColor);
      line(mouseX, mouseY, pmouseX, pmouseY);
    }
    //Simulate the broken up look of a pencil. Was considering calling it a spraycan.
    else if (mode == "PENCIL") {
      int weight = selectedButton.getStrokeWeight();
      //Need to make sure it's at least 2 wide to draw
      weight = weight > 1 ? weight : 2;
      
      stroke(toolColor);
      //Loop through and generate random points. Use a multiple of weight to ensure more points when brush is larger.
      for (int i = 0; i < weight*weight; i++) {
        float xLoc = mouseX + random(-weight/2, weight/2);
        float yLoc = mouseY + random(-weight/2, weight/2);
        //Use dist to ensure that points are within containing circle rather than forming square
        if (dist(mouseX, mouseY, xLoc, yLoc) < weight/2) {
          point(xLoc, yLoc);  
        }
      }
    }
    //Works similarly to the pencil but with a wider spead and less points
    else if (mode == "SPRAY") {
      int weight = selectedButton.getStrokeWeight();
      stroke(toolColor);
      //Loop through and generate random points. Use a multiple of weight to ensure more points when brush is larger.
      for (int i = 0; i < weight * 3; i++) {
        //Make the occasional one further out
        float xLoc;
        float yLoc;
        if (i % 3 == 0) {
          xLoc = random(-weight, weight);
          yLoc = random(-weight, weight);
          //Use dist to ensure that points are within containing circle rather than forming square
          if (dist(mouseX, mouseY, mouseX + xLoc, mouseY + yLoc) < weight) {
            point(mouseX + xLoc, mouseY + yLoc);  
          }
        }
        else {
          xLoc = mouseX + random(-weight/2, weight/2);
          yLoc = mouseY + random(-weight/2, weight/2);
          //Use dist to ensure that points are within containing circle rather than forming square
          if (dist(mouseX, mouseY, xLoc, yLoc) < weight/2) {
            point(xLoc, yLoc);  
          }
        }
        
      }
    }
    //Changes width based on speed of mouse. Idea from Processing book and Paper app. Simulates a (leaky) fountain pen.
    else if (mode == "PEN") {
      float weight = dist(mouseX, mouseY, pmouseX, pmouseY);
      strokeWeight(selectedButton.getStrokeWeight() / weight);
      stroke(toolColor);
      line(mouseX, mouseY, pmouseX, pmouseY);
    }
    //Draws ellipses of varying opacity around the mouse
    else if (mode == "BRUSH") {
      float r = red(toolColor);
      float g = green(toolColor);
      float b = blue(toolColor);
      int weight = selectedButton.getStrokeWeight();
      //Need to make sure it's at least 2 wide to draw
      weight = weight > 1 ? weight : 2;
      
      noStroke();
      //Loop through and generate circles. Divide by 2 to enhance effect.
      for (int i = 0; i < weight/2; i++) {
        color c = color(r,g,b, random(70));
        fill(c);
        float xLoc = mouseX + random(-weight/2, weight/2);
        float yLoc = mouseY + random(-weight/2, weight/2);
        //Use dist to ensure that points are within containing circle rather than forming square
        if (dist(mouseX, mouseY, xLoc, yLoc) < weight/2) {
           ellipse(xLoc, yLoc, weight, weight);
        }
      } 
    }
    else if (mode == "SHAPE") {
      int type = int(random(3));
      noStroke();
      int weight = selectedButton.getStrokeWeight();
      fill(toolColor);
      int x = mouseX;
      int y = mouseY;
      //Random shape for flower head
      switch (type) {
        case 0:
          ellipse(x,y,weight,weight);
          break;
        case 1:
          quad(x-random(weight),y-random(weight), x-random(weight),y+random(weight), x+random(weight),y+random(weight), x+random(weight),y-random(weight));
        case 2:
          triangle(x,y+weight, x-random(weight),y-random(weight), x+random(weight),y-random(weight));
      }  
    }
    //Erases drawing by working same as marker but using bg color
    else if (mode == "ERASER") {
      strokeWeight(selectedButton.getStrokeWeight());
      stroke(bgColor);
      line(mouseX, mouseY, pmouseX, pmouseY);  
    }
  }    
}


void mousePressed() {
  boolean buttonClicked = false;
  for(GUIButton button: buttons) {
    if (button.inButton(mouseX, mouseY)) {
      if (button.getMode() == "COLOR") {
        toolColor = ((ColorButton)button).pickColor();
      }
      else {
        if (button.getMode() == "FILTER" && button.isSelected()) {
            ((FilterButton)button).changeFilter();
        }
        //Change mode to clicked button mode
        button.setSelected(true);
        selectedButton = button;
        mode = button.getMode();
        buttonClicked = true;
      }
    }
    else {
      button.setSelected(false);
    }
  }
  
  //Stops buttons from being cleared while user is drawing
  if (!buttonClicked) {
    selectedButton.setSelected(true);  
  }
  
  //Functions that affect the whole screen go here to avoid flickering the toolbar when the mouse is held down
  if (mouseY > toolbarHeight) {
    if (mode == "FILL") {
      background(toolColor);  
    }
    //Clears entire drawing
    else if (mode == "CLEAR") {
      background(bgColor);
    }
    //Applies filter to drawing. Blur bleeds toolbar into drawing but I can live with that.
    else if (mode == "FILTER") {
      int f = ((FilterButton)selectedButton).getFilter();
      filter(f);
    }
  }
}

//Change weight of selected button when user hits up and down keys
void keyPressed() {
  if (key == CODED) {
    int weight = selectedButton.getStrokeWeight();
    
    if (keyCode == UP) {
      weight++;
    } 
    else if (keyCode == DOWN) {
      weight--;
    }
    
    selectedButton.setStrokeWeight(weight);
  } 
}

void initButtons() {
  //Help button will only have hover and has different size/location so no need to include in array
  helpButton = new GUIButton(20, 20, 30, buttonColor, bHoverColor, "HELP", true);
  
  //Load buttons from variables
  buttons = new GUIButton[modes.length];
  for (int i = 0; i < modes.length; i++) {
    //Calculate x positions based on index and number of buttons
    int x = width / (modes.length + 1) * (i+1);
    //Color button acts differently and is subclass of GUIButton
    if (modes[i] == "COLOR") {
      buttons[i] = new ColorButton(x, toolbarHeight/2, buttonSize, toolColor, modes[i]);
    }
    else if (modes[i] == "FILTER") {
      buttons[i] = new FilterButton(x, toolbarHeight/2, buttonSize, buttonColor, bHoverColor, modes[i], true);
    }
    else {
      buttons[i] = new GUIButton(x, toolbarHeight/2, buttonSize, buttonColor, bHoverColor, modes[i], true); 
    }
    
    if (i == 0) {
      //Default to selecting first button
      buttons[i].setSelected(true);
      selectedButton = buttons[i];
      mode = buttons[i].getMode();
    }
    
    //Some buttons have no stroke
    if (modes[i] == "COLOR" || modes[i] == "CLEAR" || modes[i] == "FILL" || modes[i] == "FILTER") {
      buttons[i].setHasStroke(false);  
    }
  }  
}

void drawToolbar() {
  //Draw toolbar along top
  fill(255);
  stroke(0);
  strokeWeight(1);
  color c1 = color(255);
  color c2 = color(28, 110, 140);
  //Draw linear gradient as toolbar background. Taken from Processing Examples.
  for (int i = 0; i <= toolbarHeight; i++) {
    float inter = map(i, 0, toolbarHeight, 0, 1);
    color c = lerpColor(c1, c2, inter);
    stroke(c);
    line(0, i, width, i);
  }
  stroke(0);
  line (0, toolbarHeight, width, toolbarHeight);  
}

void drawButtons() {
  //Check each button to see if mouse is over button
  boolean hover = false;
  String hMode = "";
  for (GUIButton button : buttons) {
    if (button.inButton(mouseX, mouseY)) {
      button.drawButton(true);
      hover = true;
      hMode = button.getMode();
    } else {
      button.drawButton(false);
    }
  }
  if (hover) {
    //Change cursor, showing user that the button is clickable and show tooltip. 
    //Done here so tooltip renders on top of other buttons.
    cursor(HAND);
    fill(255);
    rect(mouseX, mouseY-20, 60, 20);
    fill(0);
    textAlign(LEFT);
    text(hMode, mouseX + 2, mouseY -5);
    //Stil need to draw help button
    helpButton.drawButton(false);
  }
  else {
    cursor(ARROW);
    //Check Help button to see if mouse is over that
    if (helpButton.inButton(mouseX, mouseY)) {
      helpButton.drawButton(true);
      cursor(HAND);
      fill(255);
      rect(mouseX + 10, mouseY-20, 310, 80);
      fill(0);
      textAlign(LEFT);
      text(helpText, mouseX + 12, mouseY -5);
    }
    else {
      helpButton.drawButton(false);
      cursor(ARROW);
    }
  }  
}
