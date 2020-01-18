class Block { //<>//
  float X, Y;
  float Dx, Dy;//ブロックの横幅縦幅
  /*
    1 => 通常ブロック
   2 => 壁ブロック
   3 => 目標ブロック
   */
  int Kind;

  boolean visible = true;

  Block(int n, float x, float y, float dx, float dy) {
    Kind = n;
    X = x;
    Y = y;
    Dx = dx;
    Dy = dy;
  }

  //表示処理
  void update() {
    fill(200);
    switch(Kind) {
    case 1://通常ブロック
      if (visible == false)return;
      stroke(255, 0, 0);
      rect(X, Y, Dx, Dy);
      break;
    case 2://壁ブロック
      stroke(255, 255, 255);
      rect(X, Y, Dx, Dy);
      break;
    case 3://目標ブロック
      if (visible == false)return;
      fill(255);
      stroke(0, 255, 255);
      rect(X, Y, Dx, Dy);
      stroke(255);
      fill(255, 0, 0);
      ellipse(X+(Dx/2), Y+(Dy/2), 8, 8);

      break;
    }
    //関数の副作用を防ぐ処理
    stroke(0);
  }

  boolean checkCollision(float Px, float Py, StageMap s) {
    if ( (X < Px &&Px < X+Dx )&&(Y<Py && Py < Y+Dy) && visible) {
      if (Kind != 2) {
        visible = false;
        s.visibleBlockCnt--;
      }
      if (Kind == 3) {
        s.visibleGoalBlock--;
      } else if (Kind == 1) {
        s.breakedNBlock++;
      }

      return true;
    } else {
      return false;
    }
  }
}
