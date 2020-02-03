//game関係のやつはクラス化しない。 //<>// //<>// //<>//



StageMap stageMap;
Dagger dagger;
int launchCnt;
int Score;
//スコア計算用一時保持用
int tmp;
float[] daggerInfo;
int goalBlock;

boolean retryPressed;

boolean ALLBreak;
//SE系
boolean clearSERuned;
boolean clearSERunedInGame;
boolean warningSERuned;
boolean ALLBreakSERuned;

boolean saved;//セーブしたかどうか

int StageNum;//リトライ用
int wait;//リトライ用 **これがないとリザルト画面を飛ばしてしまう**
boolean gameInit(int StageN) {
  try {
    wait = 0;
    StageNum = StageN;
    launchCnt = 0;
    Score = 0;
    ALLBreak = false;
    clearSERuned =false;
    clearSERunedInGame = false;
    warningSERuned = false;
    ALLBreakSERuned = false;
    saved = false;
    stageMap = new StageMap();
    stageMap.initializeMap(StageN);
    goalBlock =  stageMap.visibleGoalBlock;
    tmp = stageMap.visibleGoalBlock;
    daggerInfo = stageMap.daggerInfo;
    dagger = new Dagger(int(daggerInfo[0]), daggerInfo[1], height-50, true);
    dagger.inta();
    return true;
  }
  catch(ArrayIndexOutOfBoundsException a) {
    return false;
  }
}




void gameDraw() {

  //基本描画-----------------

  //ダガーが消えたときにまだ手数があるなら再配置
  //ない場合はゲームオーバー処理
  if (dagger.disposed && launchCnt < stageMap.daggerCnt) {
    dagger = new Dagger(int(daggerInfo[launchCnt*2]), daggerInfo[launchCnt*2+1], height-50, true);
    dagger.inta();
  } else if (dagger.disposed && launchCnt >= stageMap.daggerCnt) {
    gameOver();
    return;
  }

  dagger.draw();
  stageMap.drawBlocks(dagger.position.x, dagger.position.y);
  Block[] block = stageMap.getBlockInfo();
  for (int i = 0; i< stageMap.blockCnt; i++) {
    dagger.checkCollision(block[i].X, block[i].Y, block[i].Dx, block[i].Dy, stageMap.collision[i], block[i].Kind);
  }



  //UI描画処理他---------------

  textSize(22);
  text("Press [x] to return title", 20, height -12);

  //残りの手数など表示
  if (dagger.launched == false) {
    switch(stageMap.daggerCnt - launchCnt) {
    case 1:
      textSize(32);

      //まだ条件クリアしてなければ
      if (stageMap.visibleGoalBlock != 0) {
        fill(255, 100, 100);
        text("Last Chance", 170, 450);
        if (warningSERuned == false) {
          warningSERuned = true;
        }
      } else {
        fill(255);
        text("Last Chance", 170, 450);
      }

      break;
    default:
      fill(255);
      textSize(28);
      text("you have "+ (stageMap.daggerCnt - launchCnt) +" Chances", 125, 450);
      break;
    }
    textSize(28);
  }
  //リトライ案内用テキスト
  textSize(22);
  fill(200);
  if(retryPressed){
    fill(255,100,100);
    text("Are you sure? [r]",300,height -12);
  }
  if(!retryPressed)text("Retry with [r]",325,height -12);
  textSize(28);
  fill(200);
  
  //スキップ案内用テキスト
  //オールブレイク時と、ダガーの速度低下時におしらせ
  if((abs(dagger.velocitiy.x)<0.8 && abs(dagger.velocitiy.y)<0.8 &&dagger.launched)||ALLBreak)text("Skip with [S]",170, 400);
  
  
  
  //ALL Break判定処理
  //表示されてるブロック数 - 壁ブロック == 0
  if (stageMap.visibleBlockCnt - stageMap.wallBlockCnt == 0) {
    ALLBreak = true;
  }

  //スコア計算式
  //通常ブロックは100点加算。
  //目標ブロックは200点加算。
  Score = (stageMap.breakedNBlock*100) + (abs(stageMap.visibleGoalBlock - tmp)*200);


  //天井スコア表示フィールド
  stroke(0, 0, 255);
  fill(10);
  rect(-10, 0, width+20, 40);
  fill(255);
  textSize(28);
  text("Score:"+Score+ "pt", 310, 30);
  if (stageMap.visibleGoalBlock == 0) {
    fill(255, 255, 0);
    text("Cleared!", 20, 30);
    fill(255);
    clearSERunedInGame = true;
  } else {
    text("To Clear " +stageMap.visibleGoalBlock+" Break!", 20, 30);
  }


  if (ALLBreak) {
    if (ALLBreakSERuned == false) {
      ALLBreakSERuned = true;
    }
    textSize(50);
    fill(255, 255, 0);
    text("ALL Break!", 125, 240);
    textSize(28);
    text("Nice playing.", 165, 280);
    fill(255);
  }
}



void gameBackDraw() {
  //残像処理
  fill( 0, 0, 0, 55 );
  rect( 0, 0, width-1, height -1);
}



//ゲーム終了処理
void gameOver() {
  wait++;
  textSize(32);
  stroke(255);
  fill(255);
  if (stageMap.visibleGoalBlock == 0) {
    text("GameClear!", 160, 200);
    if (clearSERuned == false);
  } else {
    text("Try again!", 170, 200);
    if (clearSERuned == false);
  }
  clearSERuned = true;

  if (ALLBreak) {
    textSize(50);
    fill(255, 255, 0);
    text("ALL Break!", 125, 340);
    textSize(32);
    fill(255);
  }


  stroke(255, 0, 0);
  line(120, 220, 380, 220);

  text("Score : " + Score + "pt", 140, 280);

  text("Press any key to return...", 70, 430);
  //一秒経たないと移動できないようにした
  if ((keyPressed||checkGamepadKeyPress()) && wait>60) {
    GameModeChange(1);
  }
  if(wait >100000)wait = 61;//オーバーフロー対策
  
}




void gameKeyPressed() {
  try {
    //button系---------
    if (Zbutton.pressed()&&dagger.launched == false) {
      launchCnt++;
      dagger.launch();
    }
    if (Xbutton.pressed()) {
      GameModeChange(1);
    }
    if(Rbutton.pressed()){
      if(retryPressed == false){
        retryPressed = true;
      }else{
        retryPressed = false;
        gameInit(StageNum);
      }
    }else{
      retryPressed = false;
    }
    if (Sbutton.pressed()) {
      dagger.disposed = true;
    }
    //hat系--------
    if (hat.getValue()==4) {
      dagger.rightAddLaunchAngle();
    }
    if (hat.getValue()==8) {
      dagger.leftAddLaunchAngle();
    }
  }
  catch(NullPointerException e) {
    if (key == 'z'&&dagger.launched == false) {
      launchCnt++;
      dagger.launch();
    }
    if (key == 'x') {
      GameModeChange(1);
    }
    if(key == 'r'){
      if(retryPressed == false){
        retryPressed = true;
      }else{
        retryPressed = false;
        gameInit(StageNum);
      }
    }else{
      retryPressed = false;
    }
    if (key == 's') {
      dagger.disposed = true;
    }
    
    if (key == CODED) {
      if (keyCode == RIGHT) {
        dagger.rightAddLaunchAngle();
      }
      if (keyCode == LEFT) {
        dagger.leftAddLaunchAngle();
      }
    }
  }
}
