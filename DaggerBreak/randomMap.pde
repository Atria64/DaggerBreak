
//ランダムマップ生成用
int randomX = 5;
int randomY = 7; 
int randomDaggers = 2;

int Selected=0;

void randomMapDraw() {
  stroke(255, 0, 0);
  fill( 0, 0, 0, 55 );
  rect(20, 20, width-40, height-60);
  noStroke();
  rect( 0, 0, width, height );
  fill(255);
  textSize(38);
  text("Random Map Generater", width/2 -215, 160);
  stroke(255, 0, 0);
  line(120, 170, 380, 170);

  textSize(28);
  text("Map Rows : " + randomX, width/2 -100, 250);
  text("Map Columns: " + randomY, width/2 -120, 300);
  text("Daggers   : " + randomDaggers, width/2 -90, 350);


  textSize(28);
  text("Press [←→] to change value", 60, 420);
  text("Press [Z] to Generate!", 100, 480);
  text("Press [X] to return...", 120, 530);

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

void randomMapKeyPressed() {
  try {
    if (Zbutton.pressed()) {
      StageMap stageM;
      stageM = new StageMap();
      stageM.randomMapGenerate(randomX, randomY, randomDaggers);
      if (gameInit(-1)) {
        GameModeChange(5);
      } else {
      }
    }
    if (Xbutton.pressed()) {
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
          randomX++;
          break;
        case 1:
          randomY++;
          break;
        case 2:
          randomDaggers++;
          break;
        }
      }
      if (hat.getValue()==8) {
        switch(Selected) {
        case 0:
          if (randomX >0)randomX--;
          break;
        case 1:
          if (randomY >0)randomY--;
          break;
        case 2:
          if (randomDaggers >0)randomDaggers--;
          break;
        }
      }
    }
  }
  catch(NullPointerException e) {
    if (key == 'z') {
      StageMap stageM;
      stageM = new StageMap();
      stageM.randomMapGenerate(randomX, randomY, randomDaggers);
      if (gameInit(-1)) {
        GameModeChange(5);
      } else {
      }
    }
    if (key == 'x') {
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
          randomX++;
          break;
        case 1:
          randomY++;
          break;
        case 2:
          randomDaggers++;
          break;
        }
      }
      if (keyCode == LEFT) {
        switch(Selected) {
        case 0:
          if (randomX >0)randomX--;
          break;
        case 1:
          if (randomY >0)randomY--;
          break;
        case 2:
          if (randomDaggers >0)randomDaggers--;
          break;
        }
      }
    }
  }
}
