# free5gcを利用したO-RANシステム構築について

## 1. free5gcの公式サイトについて
  [https://www.free5gc.org/](https://www.free5gc.org/)
  必要なスペックや基本的な情報などは、公式サイトに記載されている。

## 2. 準備した環境の各種情報について
- free5gc用サーバ  
  - HP Spectre x360 Convertible Model 15-eb0016TX
  -  プロセッサー: Core™ i7-10750H メモリ: 16GB ストレージ: 512GB SSD
  * VMware ESXi 8.0.0
- ローカル５G基地局
  - Compal製Integrated Small Cell “OAK”
- UE
  - USB Dongle “Tributo”
  
## 3. free5gcのディレクトリ/ファイルについて
  /home/user/free5gc(\~/free5gc)配下に下図の通り、保存している。
free5gc/
┣ bin  
┃  ┣ amf  
┃  ┗ …  
┣ config  
┃  ┣ amfcfg.yaml  
┃  ┗ …  
┣ force_kill.sh  
┣ gtp5g  
┃  ┣ main.c  
┃  ┗ …  
┣ ***install_gtp5g.sh***  
┣ LICENSE  
┣ log  
┃  ┣ yyyymmdd_hhmmss  
┃  ┗ …  
┣ Makefile  
┣ make_libgtp5gnl.sh  
┣ NFs  
┃  ┣ amf  
┃  ┃  ┗ …  
┃  ┗ …  
┣ README.md  
┣ run.pid  
┣ ***run.sh***  
┣ ***setup.sh***  
┣ test  
┃  ┣ app  
┃  ┃  ┗ …  
┃  ┗ …  
┣ test_multiUPF.sh  
┣ test.sh  
┣ test_ulcl.sh  
┗ webconsole  
   ┣ backend  
   ┃  ┣ factory  
   ┃  ┃  ┗ …  
   ┃  ┗ …  
   ┣ server.go  
   ┗ …  

## ディレクトリ、ファイル、スクリプトの説明
- bin(ディレクトリ): Network Functionのbinaryファイルが入っている
- config(ディレクトリ): Network Functionのconfigファイルが入っている
- gtp5g(ディレクトリ): Kernel moduleのgtp5gのソースコードが入っている
- NFs(ディレクトリ): それぞれのNetwork Functionのソースコードが入っている
- log(ディレクトリ): それぞれのNetwork Functionのlogファイルが入っている。
- webconsole(ディレクトリ): SIM情報登録確認のWeb UI関連のソースコードと実行ファイルが入っている
- run.sh(スクリプト): Network Functionの実行(free5gcの起動), install_gtp.shとsetup.shを実行
- run.pid(ファイル): run.sh実行中のrun.shのpidを保存したファイル
- force_kill.sh(スクリプト): run.shを強制的に終了させ、Network Functionのプロセスを停止させる
- install_gtp.sh(スクリプト): gtp5gがロードされているかを確認するスクリプト
- setup.sh(スクリプト): firewallの設定を行うスクリプト

## 4. 自動実行するように設定したスクリプトについて
次のスクリプトが起動時に自動的に起動するように設定している。  
- 起動時にsystemctlでrun.shが自動的に起動する
- 同様にsystemctlでserver.goが自動的に起動する
  ※server.goはメモリ使用量多いので必要に応じてプロセスの停止を行ってください。
## 5. systemctlの各種サービスコマンドが使用可能
  e.g.)  
- sudo systemctl status start_core.service : 現在のステータスを表示
- sudo systemctl stop start_core.service : run.shのサービスを停止
- sudo systemctl start start_core.service : run.shのサービスを起動
ユニット定義ファイルの保存ディレクトリ
- /etc/systemd/system/
ユニット定義ファイル
- start_core.service　：free5gcのコアネットワーク起動スクリプト(run.shを実行)
- start_webserver.service　：SIM情報登録用Web serverの起動(go run server.goの実行)

## 6. IPアドレス設定方法
UbuntuのIPアドレスの設定方法
  以下のディレクトリ配下に設定ファイルが存在する。
-   /etc/netplan
  初期状態では「00-installer-config.yaml」というファイルが設定ファイル。  
  このディレクトリ内にあるyamlファイルを設定ファイルと認識する。  

  設定ファイルを編集することでIPアドレスの設定を行うことができる。  


  
設定変更後、次のコマンドでの設定を適用する。
    コマンド: sudo netplan apply  
  ![](media/image3.jpg)

## 7. free5gcのconfigについて
変更することの多い設定項目  
  Free5gcに次の３つconfigファイルがあり、それぞれで変更することが多い設定項目について、解説する。
-  AMF config (amfcfg.yaml)
-   SMF config (smfcfg.yaml)
-  UPF config (upfcfg.yaml)
    
  (1)AMF config (amfcfg.yaml)  
  ngapIpListの値を127.0.0.1(default)から5GC server host IPに変更する。

-  MCC, MNCを変更する。  
    e.g.) MCC:001, MNC:01 

  
  (2)SMF config (smfcfg.yaml)  
-  MCC, MNCを変更する。  
    e.g.) MCC:001, MNC:01

  
-  5GC server host IPを変更  
    userplaneInformation &gt; upNodes &gt; UPF &gt; interfaces &gt; endpointsの値を5GC server host IPに変更する。

-  UEのIP、cidr値の変更  
  UEのIP、およびcidrの値は、10.60.0.0/16(default)から必要に応じて変更する。
  
  (3)UPF config (upfcfg.yaml)  
-   5GC server host IPを変更  
  gtpu &gt; ifList &gt; addrの値を127.0.0.8(default)から5GC server host IPに変更する。
  
-   UEのIP、cidr値の変更  
    UEのIP、およびcidrの値は、10.60.0.0/16(default)から必要に応じて変更する。
  
以上
