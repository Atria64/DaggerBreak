class Credit {
  //側の処理を愚直に描画します。
  void drawing() {
    stroke(255, 0, 0);
    fill( 0, 0, 0, 55 );
    rect(20, 20, width-40, height-60);
    noStroke();
    rect( 0, 0, width, height );
    fill(255);
    textSize(40);
    text("Credit", width/2 -60, 150);
    stroke(255,0,0);
    line(120,170,380,170);
    textSize(30);
    text("Planning : Atria", width/2 -115, 220);
    text("Cording : Atria", width/2 -110, 290);
    text("Drawing : Atria", width/2 -110, 360);
    textSize(26);
    text("The GitHub version omits audio.", width/2 -200, 430);
    textSize(20);
    text("Press any key to return...", 10, height -12);
  }
  
  void keyPressed(){
    //タイトルへ遷移
    GameModeChange(1);
  }
  
}
