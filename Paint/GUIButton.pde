/**  Author - Thomas Jordan
*    Represents a basic circular button with optional icon
*    Has getters and setters as well as methods to determine if mouse is over button.
*/

class GUIButton {
  int posX;
  int posY;
  int w;
  color c;
  color hoverColor;
  boolean selected = false;
  String mode = "";
  int strokeWeight = 10;
  int maxWeight = 20;
  boolean hasStroke = true;
  PShape icon;
 
  GUIButton(int _posX, int _posY, int _w, color _c, color _hoverColor, String _mode, boolean hasIcon) {
    posX = _posX;
    posY = _posY;
    w = _w;
    c = _c;
    hoverColor = _hoverColor;
    mode = _mode;
    //Must name svg icon same as mode
    if (hasIcon) {
      icon = loadShape(mode + ".svg");  
    }
  }

  void drawButton(boolean hover) {
    stroke(0);
    noStroke();
    //Can set up different states for hover and selected but this is good for now.
    if (hover || selected) {
      fill(hoverColor);
    } else {
      fill(c);
    }
    ellipse(posX, posY, w, w);
    
    //draw icon over/in ellipse
    if (icon != null) {
      shapeMode(CENTER);
      shape(icon, posX, posY, w-20, w-20);
    }
    
    //Draw circle under button showing stroke width of tool
    if (hasStroke && selected) {
      ellipse(posX, posY + w/2 + maxWeight/2 + 3, strokeWeight, strokeWeight);  
    }
  }

  //If extending the class for a different shape button, this should be overrode to use a different method.
  boolean inButton(int x, int y) {
    if (dist(x, y, posX, posY) > w/2) {
      return false;
    } else {
      return true;
    }
  }
  
  void setSelected(boolean _selected) {
      selected = _selected;
  }
  
  boolean isSelected() {
    return selected;  
  }
  
  String getMode() {
    return mode;  
  }
  
  void setMode(String _mode) {
    mode = _mode;  
  }
  
  int getStrokeWeight() {
    return strokeWeight;  
  }
  
  void setStrokeWeight(int weight) {
    //Ensures that stroke is set to sensible values.
    strokeWeight = constrain(weight, 1, maxWeight);
    
  }
  
  //Used to disable ellipse below button
  void setHasStroke(boolean _hasStroke) {
    hasStroke = _hasStroke;
  }
}
