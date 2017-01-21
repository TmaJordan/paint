class ColorButton extends GUIButton {
  
  ColorButton(int _posX, int _posY, int _w, color _c, String _mode) {
    super(_posX, _posY, _w, _c, _c, _mode, false);
  }
  
  color pickColor() {
    c = color(random(255), random(255), random(255));
    hoverColor = c;
    return c;
  }
}
