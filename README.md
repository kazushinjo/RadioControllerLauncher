# Radio Controller Launcher

KX3 Controller、FT-817 Controller、FT-857D / FT-897D ControllerをmacOSのメニューバーから個別に起動する独立アプリです。各ControllerのソースやCAT機能は含みません。

## 機能

- メニューバーから次のいずれか1つを選んで起動
  - KX3 Controller
  - FT-817 Controller
  - FT-857D / FT-897D Controller
- 起動中のControllerをメニューに表示
- 起動済み項目を選ぶと前面へ表示
- `/Applications`を優先し、ユーザーのApplicationsおよび開発フォルダーも検索
- Dockへ常駐せずメニューバーだけに表示

「すべて起動」機能はありません。ランチャーは無線機のCATポートやWebSocketを使用しません。

## 使用方法

1. 3つのControllerをApplicationsフォルダーへ配置します。
2. Radio Controller Launcherを起動します。
3. メニューバーのアンテナアイコンを押します。
4. 使用するControllerを1つ選びます。

## ビルド

```sh
swift test
./build_app.sh
open RadioControllerLauncher.app
```

## 操作説明書

- [操作説明書（Markdown）](docs/操作説明書.md)
- [操作説明書（DOCX）](docs/RadioControllerLauncher_操作説明書.docx)
