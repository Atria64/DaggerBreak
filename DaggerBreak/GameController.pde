import org.gamecontrolplus.*;
import java.util.List;
import net.java.games.input.Controller;
ControlIO control;
ControlDevice device;

ControlButton Zbutton;
ControlButton Xbutton;
ControlButton Rbutton;//リトライボタン
ControlButton Sbutton;//スキップボタン
ControlHat hat;

void tryGamepadOpen() {
  try {
    // インスタンスを取得する
    control= ControlIO.getInstance(this);
    //直接指定の場合
    //拡張性に劣るため不採用
    //device = control.getDevice("Controller (Gamepad F310)");

    // デバイス一覧を取得する
    List<ControlDevice> devList = control.getDevices();
    // デバイス一覧から、最初のGamePadを取得する
    for (  ControlDevice dev : devList) {
      if ( Controller.Type.GAMEPAD.toString() == (dev.getTypeName())) {
        // GamePadを見つけた
        device = dev;
        break;
      }
    }

    if (device == null) {
      // 見つからない場合
      println("ERROR: No available devices found.");
      return;
    }

    // OPENする
    device.open();

    // ボタンを取得する
    Zbutton = device.getButton( 1 );
    Xbutton = device.getButton( 0 );
    Rbutton = device.getButton( 3 );
    Sbutton = device.getButton( 2 );
    hat = device.getHat( 10 );
  }
  catch(NullPointerException e) {
    println("null");
  }
}

//入力検知
boolean checkGamepadKeyPress() {
  try {
    if (Zbutton.pressed() || Xbutton.pressed() || Rbutton.pressed() || Sbutton.pressed() ||//Z,X,R
      hat.getValue()==2 || hat.getValue()==4 || //上右
      hat.getValue()==6|| hat.getValue()==8) {//下左
      return true;
    } else {
      return false;
    }
  }
  catch(NullPointerException e) {
    return false;
  }
}
