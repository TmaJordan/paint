class FilterButton extends GUIButton {
  String[] filters = {"BLUR", "THRESHOLD", "GRAY", "INVERT"};
  int index = 0;
  PFont font;
  
  FilterButton(int _posX, int _posY, int _w, color _c, color _hoverColor, String _mode, boolean hasIcon) {
    super(_posX, _posY, _w, _c, _hoverColor, _mode, hasIcon);
    font = loadFont("OpenSans-14.vlw");
    textFont(font);
  }
  
  void drawButton(boolean hover) {
    super.drawButton(hover);
    
    if (selected) {
      textAlign(CENTER);
      fill(255);
      text(filters[index], posX, posY + w - 10);
    }
  }
  
  void changeFilter() {
    if (index < filters.length - 1) {
      index++;  
    }
    else {
      index = 0;  
    }
  }
  
  int getFilter() {
    String filter = filters[index];
    if (filter == "BLUR") {
      return BLUR; 
    }
    else if (filter == "THRESHOLD") {
      return THRESHOLD;  
    }
    else if (filter == "GRAY") {
      return GRAY;  
    }
    else if (filter == "INVERT") {
      return INVERT;  
    }
    else {
      //Defaults to Blur as function has to return something
      return BLUR;
    }
  }
}
