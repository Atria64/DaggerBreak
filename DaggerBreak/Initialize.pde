class Initialize {


  PImage AtriaSoft = loadImage("AtriaSoft.png");
  PImage Processing = loadImage("processing.png");

  int Transparency = 1;//透明度
  int TransV = 10;//透明度遷移速度
  boolean Imageing = true;
  
  void ShowImg(){
    background(255);
    tint(255,Transparency);
    image(Processing, width/2 - 100, height - 500, 200, 200);
    image(AtriaSoft, -30, height-500, width+50, height);
    
    //フェード処理、600=>濃い時間を操作できるマジックナンバー
    if(Transparency >= 600){
      Imageing = false;
    }else if(0>=Transparency){
      GameModeChange(1);
    }
    
    if(Imageing){
      Transparency += TransV;
    }else{
      Transparency -= TransV;
    }
    
  }
  
  void keyPressed(){
      background(255);
      GameModeChange(1);
  }
  
}
