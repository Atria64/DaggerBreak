class StageMap {
  String[] csvDataLines ;
  Block[] block;

  boolean Initialized = false;

  int gap = 8;//隙間どれくらいにするか
  int mapRangeUp = 60;//マップ範囲天井
  int mapRangeUnder = 400;//マップ範囲下辺

  //マップデータ保持用変数
  int blockMapDataRows;//行
  int blockMapDataColumns;//列
  String stageTitle;
  float dx, dy;
  //ブロックデータ保持用変数
  int blockCnt;
  int visibleBlockCnt;
  int wallBlockCnt;
  int visibleGoalBlock;
  int breakedNBlock;
  //---------------------
  //ダガーデータ保持用変数
  int daggerCnt;
  float[] daggerInfo={};
  //
  //ノルマスコアデータ保持用変数
  int[] quotaScore={};




  //初期化処理<一度のみ>
  void initializeMap(int n) {

    if (Initialized)return;

    if (loadMap(n) == false) {
      println("マップの読み込みに失敗、配置処理をスルーします。");
      EndStage = n;
      return;
    }

    /*
     配置位置の計算
     データの縦幅、横幅から自動的に大きさを調整する
     超愚直実装。
     */
    stageTitle = split(csvDataLines[0], ",")[0];
    blockMapDataRows = int(split(csvDataLines[1], ","))[0];
    blockMapDataColumns = int(split(csvDataLines[1], ","))[1];
    daggerCnt = int(split(csvDataLines[1], ","))[2];
    dx = (width - (gap * blockMapDataColumns +2))/blockMapDataColumns;
    dy = (mapRangeUnder - (gap * blockMapDataColumns +2))/blockMapDataColumns;
    loadBlocks(); //<>//
    Initialized = true; //<>//
  }


  //ランダムマップ生成用
  void randomMapGenerate(int y, int x, int dagger) {
    stageTitle = "Random 4 Practice";
    blockMapDataRows = x;
    blockMapDataColumns = y;
    daggerCnt = dagger;
    dx = (width - (gap * blockMapDataColumns +2))/blockMapDataColumns;
    dy = (mapRangeUnder - (gap * blockMapDataColumns +2))/blockMapDataColumns;

    ArrayList<String> al = new ArrayList<String>(); 
    for (int i =0; i<y; i++) {
      String Line = "";
      for (int j = 0; j < x; j++) {
        Line += int(random(4)) + ",";
      }
      StringBuilder sb = new StringBuilder(Line);
      sb.setLength(sb.length()-1);
      al.add(sb.toString());
    }
    //マップ様式に合わせるための処理
    al.add("dagger");
    String Line = "";
    for (int i = 0; i<daggerCnt*2; i++) {
      if(i%2 ==0)Line += int(random(2));
      if(i%2 ==1)Line += int(random(width));
      Line += ",";
    }
    StringBuilder sb = new StringBuilder(Line);
    sb.setLength(sb.length()-1);
    al.add(sb.toString());
    println(al);
    PrintWriter file; 
    file = createWriter(dataPath("") + "\\Stage-1.csv");
    file.println("Random Map");
    file.println( y+","+x+","+daggerCnt);
    for(int i = 0;i<al.size();i++){
      file.println(al.get(i)); 
    }
    
    file.flush();
    file.close();
  }




  boolean[] collision;
  //このクラスのメインループ
  //配列からデータを読んでブロックを配置する。
  //ブロックに関する当たり判定処理もここで行う。
  void drawBlocks(float Px, float Py) {

    //発射ライン
    stroke(0, 0, 255);
    line(0, height-45, width, height-45);

    collision = new boolean[blockCnt];
    try {
      for (int i = 0; i< blockCnt; i++) {
        block[i].update();
        collision[i] = block[i].checkCollision(Px, Py, stageMap);
      }
    }
    catch(NullPointerException e) {
      println("ぬるぽ @drawBlocks");
    }
  }



  //マップロード関数。失敗した場合はfalseを返す<一度のみ>
  private boolean loadMap(int n) {
    csvDataLines = loadStrings("Stage"+n+".csv");
    if (csvDataLines == null)return false;
    return true;
  }



  //配列にブロック情報とダガー情報を読み込ませる<一度のみ>
  void loadBlocks() {
    block = new Block[200];
    blockCnt = 0;
    //2行すっ飛ばして読む
    for (int i = 2; i<blockMapDataRows+2; i++) {
      float x = gap;
      float y = gap + dy;
      String[] csvDataLine = split(csvDataLines[i], ","); //<>//
      for (int j = 0; j < blockMapDataColumns; j++) {
        switch(int(csvDataLine[j])) { //<>//
        case 0://空白
          x += gap + dx;
          break;
        case 1://通常ブロック
          block[blockCnt] = new Block(1, x, y*(i-2) + mapRangeUp, dx, dy);
          //rectでの記述では
          //rect(x, y*i + mapRangeUp, dx, dy);
          blockCnt++;
          x += gap + dx;
          break;
        case 2://壁ブロック追加
          block[blockCnt] = new Block(2, x, y*(i-2) + mapRangeUp, dx, dy);
          blockCnt++;
          wallBlockCnt++;
          x += gap + dx;
          break;
        case 3://目標ブロック追加
          block[blockCnt] = new Block(3, x, y*(i-2) + mapRangeUp, dx, dy);
          visibleGoalBlock++;
          blockCnt++;
          x += gap + dx;
          break;
        }
      }
    }
    //ダガーデータ取り込み
    //きれいなデータにする処理
    //取り込み用一次変数、使い捨て
    String[]  tmp = split(csvDataLines[blockMapDataRows+3], ","); //<>//
    for (int i = 0; i<daggerCnt*2; i++) {
      daggerInfo =append(daggerInfo, float(tmp[i]));
    }

    visibleBlockCnt = blockCnt;
  }


  //情報渡す系
  Block[]getBlockInfo() {
    return block;
  }
}
