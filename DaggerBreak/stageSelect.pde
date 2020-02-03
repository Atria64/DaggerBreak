//ステージの終わり記録用
int EndStage;
class StageSelect {
  Dagger dagger;
  Dagger[] previewDagger;
  StageMap stageMap;
  int SelectedStage = 0;

  void Init() {
    dagger = new Dagger(1, width/2, height-50, true);
    dagger.inta();
    previewDagger = new Dagger[10];
    stageMap = new StageMap();
    if(SelectedStage != -1)stageMap.initializeMap(SelectedStage);//特殊マップを除く
    EndStage = checkEnd();
  }

  float dx = 0;
  //ステージデータ格納用
  String stageTitle;
  int daggers;
  void drawing() {
    stageTitle = stageMap.stageTitle;
    dx += 0.1;
    //枠組み描画
    fill(255);
    //sinを使って三角形をふわふわさせてます。
    if (-1 != SelectedStage)triangle(70+sin(dx)*2, 135, 70+sin(dx)*2, 215, 20+sin(dx)*2, 175);
    if (EndStage-1 != SelectedStage)triangle(430-sin(dx)*2, 135, 430-sin(dx)*2, 215, 480-sin(dx)*2, 175);
    rect(100, 40, 300, 250);
    fill(0);

    //ステージ紹介描画関係-----------------
    textSize(28);
    //特殊ステージ処理
    if (SelectedStage == -1) {
      
      text("Random 4 Practice", 125, 80);
      textSize(18);
      text("-[Z] to Generate Map-", 150, 120);
      textSize(22);
      text("---Very Special Mode---", 115, 200);
    } else {
      text("Stage"+SelectedStage, 205, 80);
      if (stageTitle.length() %2 == 0)text("-"+stageTitle+"-", (width/2)-((stageTitle.length()+2)/2*10)-40, 120);
      if (stageTitle.length() %2 == 1)text("-"+stageTitle+"-", (width/2)-((stageTitle.length()+2)/2*10)-22, 120);
      text("TargetBlock"+stageMap.visibleGoalBlock, 160, 280);
      
      //dagger系情報描画処理
      daggers = stageMap.daggerCnt;
      textSize(18);
      text("-daggers-", 205, 150);
      for (int i = 0; i<daggers; i++) {
        previewDagger[i] = new Dagger(int(stageMap.daggerInfo[i*2]), (300/(daggers+1))*(i+1)+100, 180, false);
        previewDagger[i].drawDagger(-PI/2);
        if (int(stageMap.daggerInfo[i*2]) == 0) {
          textSize(12);
          fill(0);
          text("Penetration", (300/(daggers+1))*(i+1)+67, 230);
        }
      }

      fill(255);
    }

    dagger.draw();
    checkCollision();
    //操作説明系----------------
    if (dagger.launched == false) {
      textSize(28);
      text("Press [z] to select stage", 90, height -170);
      textSize(22);
      text("Press [x] to return title", 130, height -120);
    }
  }

  void backDrawing() {
    //残像処理
    fill( 0, 0, 0, 55 );
    rect( 0, 0, width-1, height -1);
  }

  //画面遷移処理
  private void checkCollision() {
    //衝突していない場合弾く
    if (dagger.position.y >250)return;
    dagger.disposed = true;

    //特殊マップは最優先分岐
    if(SelectedStage == -1){
      GameModeChange(6);
      return;
    }
    
    //指定したマップが存在する場合
    if (gameInit(SelectedStage)) {
      GameModeChange(5);
    } else {
      Init();
    }
  }

  //選択制限も行う
  void keyPressed() {
    if (dagger.launched)return;//ステージを決定した後、入力を受け付けないようにする
    try {
      if (Zbutton.pressed()) {
        dagger.launch();
      }
      if (Xbutton.pressed()) {
        GameModeChange(1);
      }
      if (hat.getValue()==4) {
        if (SelectedStage < EndStage-1) {
          SelectedStage++;
          stageMap = new StageMap();
          if(SelectedStage>-1)stageMap.initializeMap(SelectedStage);

          //一瞬色を変える
          fill(255, 255, 0);
          triangle(430-sin(dx)*2, 135, 430-sin(dx)*2, 215, 480-sin(dx)*2, 175);
          fill(255);

        }
      }
      if (hat.getValue()==8) {
        if (SelectedStage >-1) {
          SelectedStage--;
          stageMap = new StageMap();
          if(SelectedStage>-1)stageMap.initializeMap(SelectedStage);

          //一瞬色を変える
          fill(255, 255, 0);
          triangle(70+sin(dx)*2, 135, 70+sin(dx)*2, 215, 20+sin(dx)*2, 175);
          fill(255);

        }
      }
    }
    catch(NullPointerException e) {
      if (key == 'z') {
        dagger.launch();
      }
      if (key == 'x') {
        GameModeChange(1);
      }

      if (key == CODED) {
        if (keyCode == RIGHT) {
          if (SelectedStage < EndStage-1) {
            SelectedStage++;
            stageMap = new StageMap();
            if(SelectedStage>-1)stageMap.initializeMap(SelectedStage);

            //一瞬色を変える
            fill(255, 255, 0);
            triangle(430-sin(dx)*2, 135, 430-sin(dx)*2, 215, 480-sin(dx)*2, 175);
            fill(255);

          }
        }
        if (keyCode == LEFT) {
          if (SelectedStage >-1) {
            SelectedStage--;
            stageMap = new StageMap();
            if(SelectedStage>-1)stageMap.initializeMap(SelectedStage);

            //一瞬色を変える
            fill(255, 255, 0);
            triangle(70+sin(dx)*2, 135, 70+sin(dx)*2, 215, 20+sin(dx)*2, 175);
            fill(255);

          } 
        }
      }
    }
  }

  int checkEnd() {
    for (int i = 0; i<10000; i++) {
      if (stageMap.loadMap(i) == false) {
        return i;
      }
    }
    return 0;
  }
}
