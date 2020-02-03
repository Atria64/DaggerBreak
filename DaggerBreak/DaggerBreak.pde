/*
GameMode(int)の仕様
 0 => 初期化画面
 1 => タイトル
 2 => ステージ選択
 3 => オプション
 4 => クレジット
 5 => ゲーム
 6 => ランダムマップ生成前
 ChangeGameModeで変更可能。(どこからでも呼べる)
 */

int GameMode = 0;
int BGMnum = int(random(3));//0~2でランダム
int BGMVol = 90;
int SEVol = 100;

Title title;
Initialize init;
StageSelect stageselect;
Option option;
Credit credit;

void setup() {
  size(500, 600);
  frameRate(60);
  init = new Initialize();
  title = new Title();
  stageselect = new StageSelect();
  option = new Option();
  credit = new Credit();
  tryGamepadOpen();
}

boolean titleInited = false;

boolean stageselectInited = false;

boolean gameInited = false;

boolean is_MessageShowing = false;

//GamePad用
boolean oldGamepadKeyPress;//一つ前のGamePad用入力検知変数
int oldGameMode;
int waitTime = 0;

void draw() {
  
  //Gamepad 一度のみの入力---------
  
  //オーバーフロー対策
  if(waitTime >1000000)waitTime = 0;
  
  /*
    1.ゲームモードが変更された場合は問答無用で連続入力をストップさせる
    2.waitTimeによって一定時間連続入力をストップさせている。
  */
  
  if(checkGamepadKeyPress() && oldGamepadKeyPress == false&&GameMode == oldGameMode){
    //ボタン押し始め
    keyPressed();
  }else if(checkGamepadKeyPress() == false && waitTime > -1){
    waitTime = 0;
  }
  waitTime++;
  oldGamepadKeyPress = checkGamepadKeyPress();
  if(waitTime > 20){
    oldGamepadKeyPress = false;
  }
  
  oldGameMode = GameMode;
  
  //画面ごとの分岐処理--------------
  switch(GameMode) {
  case 0:
    init.ShowImg();
    break;
  case 1:
    stageselectInited = false;
    if (titleInited == false) {
      title.Init();
      titleInited = true;
    }
    title.Drawing();
    title.BackDrawing();
    break;
  case 2:
    titleInited = false;
    //ステージ選択画面
    if (stageselectInited == false) {
      stageselect.Init();
      stageselectInited = true;
    }
    stageselect.drawing();
    stageselect.backDrawing();
    break;
  case 3:
    titleInited = false;
    //オプション
    option.drawing();
    break;
  case 4:
    titleInited = false;
    //クレジット
    credit.drawing();
    break;
  case 5:
    //gameの初期化処理はStageSelectで行われている
    gameDraw();
    gameBackDraw();
    break;
  case 6:
    randomMapDraw();
    break;
  }
  
}

void keyPressed() {
  switch(GameMode) {
  case 0:
    init.keyPressed();
    break;
  case 1:
    title.keyPressed();
    break;
  case 2:
    stageselect.keyPressed();
    break;
  case 3:
    option.keyPressed();
    break;
  case 4:
    credit.keyPressed();
    break;
  case 5:
    gameKeyPressed();
    break;
  case 6:
    randomMapKeyPressed();
    break;
  }
}


void GameModeChange(int n) {
  GameMode = n;
}
