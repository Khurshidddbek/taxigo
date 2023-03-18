package com.gotaxi.taxigo.taxigo

import io.flutter.embedding.android.FlutterActivity
import com.yandex.mapkit.MapKitFactory;

public class MainActivity extends FlutterActivity {
  @Override
  public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
    MapKitFactory.setApiKey("d4d58374-c106-4454-99f2-84721a5558ec"); // Your generated API key
    super.configureFlutterEngine(flutterEngine);
  }
}
