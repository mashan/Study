rubyでの並列処理
----------------

### 注意

* ruby 1.8系
    * グリーンスレッドという実装のためOSによるスレッドを使えない
* 並列実行数に注意
    * 単純にThreadを使うだけだと、配列の分だけ処理が走り逆に重くなる
    * Producer-Consumerパターンを使うことで同時実行数を制御

### Queue

* ワーカースレッドを容易に作ることが出来る
* ワーカースレッド
    * キューから順番にタスクを取り出して実行する
    * キューに定期的にタスクを積むスレッドがいるとそれを取り出して実行
    * タスクが無いと待ち状態
    * キューへのタスク追加と取得は別のスレッドで行われるので同期処理が必要になる
* Queueライブラリ
    * キューへのタスク追加処理側と取得側での同期処理が隠蔽される
    * Queue#popとQueue#pushなどを使う
        * Queue#popで要素を取得。queueが空の時、呼出元のスレッドは停止(ブロック)
        * Queue#pushで要素を追加します。待っているスレッドがいれば実行を再開
    * deadlockに注意
        * queueが空だと待ち状態が発生し続けるため、考慮する必要がある
        * 以下のサンプルにあるようにqueueにnilを挿入して抜けられるようにしたりする
* サンプル
    * `queue.rb` 参照


### threadの終了を待つ

* ThreadsWaitを使うと便利
    * サンプル `threads_wait.rb`

### ActiveDirectoryでの利用

* コネクションを共用する
    * ActiveRecord::Base.connection_pool.with_connection を利用
* コネクションを最後に閉じる(方が良い？)
    * ActiveRecord::Base.connection.close


セマフォとmutex
---------------

下記、環境によって異なったりするらしいが細かい話は無視

### セマフォ?

* 並列プログラミングで用いる
* 複数プログラム間で競合を防ぐのに利用される
* 実態は変数や抽象データ型
* セマフォ2種類
    * カウンティングセマフォ
        * 任意の個数の資源を扱うセマフォ
    * バイナリセマフォ
        * 値がロック/アンロック(0/1)に限定されるセマフォ
        * mutexと同等の機能を持つ
* セマフォが管理するのは、資源の総数と空いている資源の数
* 資源を利用したいプロセスはプロトコルに従わなければならない

### mutex?

* 上述の通り、値がロック/アンロック(0/1)に限定されるセマフォ
* つまりは同時にひとつのプロセスからしかリソースにアクセス出来ないようにするもの



