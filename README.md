# AppMonitor
Windowsアプリケーション用の軽量な自動監視・復旧ツールです。指定したアプリケーションが実行されているかを継続的に確認し、クラッシュや予期せぬ終了が発生した場合には自動的に再起動します。

## ファイル構成
* `setup.ps1` : ツールを展開し、自動起動を設定するためのインストーラースクリプト
* `monitor.bat` : アプリケーションの監視を実行するバッチファイルのテンプレート
* `launcher.ps1`: バッチファイルをバックグラウンドで実行するためのPowerShellスクリプトのテンプレート

## インストール方法
1. このリポジトリをクローンまたはダウンロードする。
2. PowerShellを**「管理者として実行」**する。
3. ダウンロードしたディレクトリに移動し、監視対象のアプリケーションの名前とフルパスを引数に指定して `setup.ps1` を実行する。

実行例:
```powershell
.\setup.ps1 -AppName "notepad.exe" -AppPath "C:\Windows\System32\notepad.exe"
```

Powershellでスクリプト実行を禁止している場合には制限を一時的に解除する。
```powershell
powershell -ExecutionPolicy Bypass -File .\setup.ps1 -AppName "notepad.exe" -AppPath "C:\Windows\System32\notepad.exe"
```
