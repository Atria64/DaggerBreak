class Option {

  int Selected=0;

  //側の処理を愚直に描画します。
  void drawing() {
    stroke(255, 0, 0);
    fill( 0, 0, 0, 55 );
    rect(20, 20, width-40, height-60);
    noStroke();
    rect( 0, 0, width, height );
    fill(255);
    textSize(40);
    text("Option", width/2 -60, 150);
    stroke(255, 0, 0);
    line(120, 170, 380, 170);

    textSize(28);
    text("BGM Volume : " + BGMVol, width/2 -130, 250);
    text("SE Volume    : " + SEVol, width/2 -126, 300);
    text("BGM Kind    : " + BGMnum, width/2 -126, 350);


    textSize(28);
    text("Press [←→] to change value", 60, 440);
    text("Press [Z or X] to return...", 90, 500);

    switch(Selected) {
    case 0:
      triangle(375, 240, 395, 250, 395, 230);
      break;
    case 1:
      triangle(375, 290, 395, 300, 395, 280);
      break;
    case 2:
      triangle(375, 340, 395, 350, 395, 330);
      break;
    }
  }

  void keyPressed() {
    try {
      if (Zbutton.pressed()||Xbutton.pressed()) {
        //タイトルへ遷移
        GameModeChange(1);
      }
      if (hat.getValue()==2||hat.getValue()==4||hat.getValue()==6||hat.getValue()==8) {
        if (hat.getValue()==2) {
          if (Selected > 0)Selected--;
        }
        if (hat.getValue()==6) {
          if (Selected < 2)Selected++;
        }
        if (hat.getValue()==4) {
          switch(Selected) {
          case 0:
            if (BGMVol<100)BGMVol++;
            break;
          case 1:
            if (SEVol<100)SEVol++;
            break;
          case 2:
            if (BGMnum<2)BGMnum++;
            break;
          }
        }
        if (hat.getValue()==8) {
          switch(Selected) {
          case 0:
            if (BGMVol>0)BGMVol--;
            break;
          case 1:
            if (SEVol>0)SEVol--;
            break;
          case 2:
            if (BGMnum>0)BGMnum--;
            break;
          }
        }
      }
    }
    catch(NullPointerException e) {
      if (key == 'z'||key == 'x') {
        //タイトルへ遷移
        GameModeChange(1);
      }
      if (key == CODED) {
        if (keyCode == UP) {
          if (Selected > 0)Selected--;
        }
        if (keyCode == DOWN) {
          if (Selected < 2)Selected++;
        }
        if (keyCode == RIGHT) {
          switch(Selected) {
          case 0:
            if (BGMVol<100)BGMVol++;
            break;
          case 1:
            if (SEVol<100)SEVol++;
            break;
          case 2:
            if (BGMnum<2)BGMnum++;
            break;
          }
        }
        if (keyCode == LEFT) {
          switch(Selected) {
          case 0:
            if (BGMVol>0)BGMVol--;
            break;
          case 1:
            if (SEVol>0)SEVol--;
            break;
          case 2:
            if (BGMnum>0)BGMnum--;
            break;
          }
        }
      }
    }
  }
}
