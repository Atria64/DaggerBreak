class Title {
  float[] daggerInfo;

  Dagger dagger;
  StageMap stageMap;
  void Init() {
    stageMap = new StageMap();
    stageMap.initializeMap(0);
    dagger = new Dagger(int(stageMap.daggerInfo[0]), stageMap.daggerInfo[1], height-50, true);
    dagger.inta();
  }

  //表画面処理
  void Drawing() {
    //タイトル画面のみ、再配置処理を行う
    // =>進行不能を防ぐため
    if (dagger.disposed) {
      dagger = new Dagger(1, width/2, height-50, true);
      dagger.inta();
    }
    stageMap.drawBlocks(dagger.position.x, dagger.position.y);
    Block[] block = stageMap.getBlockInfo();
    for (int i = 0; i< stageMap.blockCnt; i++) {
      dagger.checkCollision(block[i].X, block[i].Y, block[i].Dx, block[i].Dy, stageMap.collision[i], block[i].Kind);
    }
    dagger.draw();


    //text系処理、面倒なので愚直実装で表現する。

    textSize(35);
    fill(255);
    text("Dagger Break", 136, 150);
    textSize(20);
    text("-GitHub Edition-", width/2 -80, 190);
    textSize(22);
    //操作説明系
    if (dagger.launched == false) {
      text("Z:Launch", 205, 500);
      text("←:Tilt Left", 110, 550);
      text("→:Tilt Right", 280, 550);
    }

    fill(255, 255, 0);
    text("Stage", 223, 250);
    text("Select", 221, 275);
    text("Option", 18, 420);
    text("Credit", 415, 420);

    //遷移用
    if (block[0].visible == false) {
      GameModeChange(2);//StageSelect
    }
    if (block[1].visible == false) {
      GameModeChange(3);//Option
    }
    if (block[2].visible == false) {
      GameModeChange(4);//Credit
    }
  }

  //背景ボール用 TODO:そのうち改善するため消す
  int r = 10;
  int x = r;
  int y = r;
  int dx = 3;
  int dy = 4;
  //裏画面処理
  void BackDrawing() {
    stroke( 0, 0, 0, 10 );

    //残像処理
    fill( 0, 0, 0, 55 );
    rect( 0, 0, width, height );

    //移動処理
    x = x + dx;
    y = y + dy;

    //衝突判定
    if ( y > height-r || y < r )  dy = -dy;
    if ( x > width-r || x < r )  dx = -dx;

    //背景で動かす物体描画
    stroke( 0, 0, 255, 100 );
    fill( 255, 255, 255, 100 );
    ellipse( x, y, r, r );
    
    
    
  }

  void keyPressed() {
    if (dagger.launched)return;
    try {
      if (Zbutton.pressed()) {
        dagger.launch();
      }
      if (hat.getValue()==4) {
        dagger.rightAddLaunchAngle();
      }
      if (hat.getValue()==8) {
        dagger.leftAddLaunchAngle();
      }
    }
    catch(NullPointerException e) {
      if (key == 'z') {
        dagger.launch();
      }
      if (key == CODED) {
        if (keyCode == RIGHT) {
          dagger.rightAddLaunchAngle();
        }
        if (keyCode == LEFT) {
          dagger.leftAddLaunchAngle();
        }
      }
      return;
    }
  }
}
