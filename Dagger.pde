class Dagger {
  PVector position;
  PVector velocitiy;
  PVector deceleration;
  /*
   Kind(int)の仕様
   0 => 貫通弾
   1 => 通常弾
   2 => hoge
   */
  int Kind;

  boolean launched = false;
  boolean disposed = false;
  boolean needLine;

  Dagger(int n, float x, float y,boolean needL) {
    Kind = n;
    position = new PVector(x, y);
    needLine = needL;
  }

  void inta() {
    velocitiy = new PVector(0.0, 0.0); 
    deceleration = new PVector(0.995, 0.995);
  }

  //角度系処理
  float launchAngle = -PI / 2; 
  void rightAddLaunchAngle() {
    launchAngle += 0.05;
    if (0<launchAngle) launchAngle = -0.04;
  }
  void leftAddLaunchAngle() {
    launchAngle -= 0.05;
    if (-PI>launchAngle) launchAngle = -PI+0.04;
  }

  //発射処理  <一度のみ>
  void launch() {
    if (launched == true)return;
    velocitiy = new PVector(20.0, 0.0);
    velocitiy.rotate(launchAngle);
    launched = true;
  }


  //移動前の位置
  float lastx;
  float lasty;

  //中心位置調整用変数
  int daggerCenterX = -4;
  int daggerCenterY = -10;

  //ダガークラスのメインループ
  //Dispose判定も行っている
  void draw() {
    if (disposed) {
      Dispose();
      return;
    }
    lastx = position.x;
    lasty = position.y;
    position.add(velocitiy);
    velocitiy.x = velocitiy.x * deceleration.x;   
    velocitiy.y = velocitiy.y * deceleration.y;

    //Dispose判定
    if (launched && abs(velocitiy.x) <0.4 &&abs(velocitiy.y) <0.4) {
      disposed = true;
    } else if (launched == false) {
      drawDagger(launchAngle);
    } else {
      drawDagger((velocitiy.heading()));
    }
  }

  //Dispose処理
  void Dispose() {
    velocitiy.x = 0;
    velocitiy.y = 0;
    //ここに破壊パーティクル
  }

  //衝突判定&減衰処理
  void checkCollision(float x, float y, float dx, float dy, boolean collision, int blockKind) {
    if (position.x < 0 || position.x > width) {
      velocitiy.x *= -0.99;
      position.x = lastx;
    }
    if (position.y < 40 || position.y > height) {
      velocitiy.y *= -0.99;
      position.y = lasty;
    }
    if (collision == false)return;
    //貫通弾は減衰が激しくなるよう調整
    if (Kind == 0 && blockKind != 2) {
      velocitiy.y *= 0.7;
      velocitiy.x *= 0.7;
      return;
    }

    //貫通弾でも壁の場合は↓までいく

    //どの方向から接触したのかをチェックする
    if (x < lastx && x+dx > lastx) {
      velocitiy.y *= -0.99;
      position.y = lasty;
      return;
    }
    if (y < lasty && y+dy > lasty) {
      velocitiy.x *= -0.99;
      position.x = lastx;
      return;
    }
    velocitiy.y *= -0.99;
    velocitiy.x *= -0.99;
  }



  //ダガー回転描画処理
  //rectを原点からずらして描画することで、直感に反しないような実装となっている。
  // →ダガーの中心を調整している
  //  →そのため当たり判定部分も調整される。
  //弾道予測線の処理もやってるよ
  private void drawDagger(float angle) {
    fill(255);
    if(Kind == 0)fill(200,255,200);
    if(Kind == 1)stroke(0);
    pushMatrix();
    translate(position.x, position.y);
    ellipse(0, 0, 5, 5);
    rotate(angle+PI/2);
    stroke(100,100,255);
    //弾道予測線
    if(!launched && needLine)line(0,0,0,-200);
    stroke(0);
    rect(daggerCenterX, -10, 8, 40);
    rect(daggerCenterX-8, daggerCenterY+25, 25, 5);
    popMatrix();
    fill(255);
  }
}
