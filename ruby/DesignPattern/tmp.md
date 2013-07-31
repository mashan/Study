# Rubyによるデザインパターン
## 目的
* 適切な設計が出来るようになりたい
* デザインパターンの基礎を抑え、共通言語を得る

## 序
### 疑問
* オブジェクト同士はどのように関連しあうのか？結びつくべきなのか？
* それらは互いの何を知るべきなのか？
* 頻繁に変わりそうな部分を入れ替えるにはどうすればよいのか？

### 疑問への回答要点
* 変わるものを変わらないものから分離する
    * 理想的なシステムではすべての変更は局所的になる
* インターフェースに対してプログラムし、実装に対して行わない
    * 抽象化。「可能な限り一般的な型に対してプログラミングせよ」という意味。
    * 車インスタンスを作りたい場合、「車クラス」を作るのではない。「乗り物クラス」、「稼働クラス」を作る。
* 継承より集約
    * あるクラスに機能が必要になった際、スーパークラスに安易に実装するのではなく、別のクラスとして切り出す事を検討する
    * 例::Carクラスにエンジンスタート/ストップが必要になった
        * Carクラスだけでなく、他のクラスにも欲しい機能 => Vehicleに実装する？
        * エンジンを持たない乗り物も存在するし、Carに筒抜け
        * Engineとして切り出す！
* 委譲！！
    * 他のクラスに処理を任せてしまう
    * 柔軟性に富む実装になる
* 必要になるまで作らない


### 紹介される14のパターン

| pattern          | 用途                                                                                                     |
|:----------------:|:--------------------------------------------------------------------------------------------------------:|
| Template Method  | パターンによって問題解決したいとき                                                                       |
| Strategy         | テクニックやアルゴリズムをラップ                                                                         |
| Observer         | クラスAとクラスBを通信させたい時                                                                         |
| Composite        | オブジェクトのコレクション自体が、そこに含まれる個々オブジェクトにおように見えるコレクションが必要なとき |
| Iterator         | オブジェクトのコレクションを隠し過ぎたくないとき                                                         |
| Command          | 指示をラップしたいとき                                                                                   |
| Adapter          | 目的の操作を達成できるオブジェクトが存在するが、インターフェースがふさわしくないとき                     |
| Proxy            | 目的のオブジェクトが存在するが、遠くにある場合                                                           |
| Decorator        | オブジェクトの責務を増やしたいとき                                                                       |
| Singleton        | 唯一のインスタンスであって欲しい時                                                                       |
| Factory Method   |                                                                                                          |
| Abstract Factory | 矛盾の無い一連のオブジェクトを作る                                                                       |
| Builder          | とても複雑で組み立てるのに特別なコードが要求されるオブジェクトが必要なとき。                             |
| Interpreter      | 問題を解決するにあたって間違ったPG言語を使っている感覚を持った時                                         |


## Ruby復習
* rubyではすべてがオブジェクト
* シンボルはイミュータブルな文字列に使う
* Class
    * Class名は大文字から始める。rubyにおいて大文字から始まる変数は定数であり、Classは定数
    * ゲッター/セッター
        * attr_accessor : インスタンス変数を返すメソッド、及びインスタンス変数に新しい値を代入するメソッドを作り出す
        * attr_reader : インスタンス変数の読み込みのみを許可するメソッドを用意する
    * 一つの親クラス、スーパークラスしか持てない。スーパークラスを定義しない場合、Objectクラスのサブクラスになる
    * インスタンス変数は継承ツリーの上下に公開されている
    * super => スーパークラスから自分と同じメソッド名を持ったものを見つけて、呼び出す

## デザインパターン詳細
### Template Method
* アルゴリズムの一部に変化を与えたい時に有効
* 基底クラスには不変の部分を記述、変わる部分にはサブクラスに定義するメソッドにカプセル化する
* 他のパターンでも現れる、基本的なオブジェクト思考技術
* 継承を元にTemplate Methodが成り立っている事が欠点を生む点に注意
    * スーパークラスに大きく依存
    * 一度方針を決めると、それを変えることが困難

### Strategy
* アルゴリズムのパターンごとにばらばらのオブジェクトとして実装する
* Strategyは同じ目的を持った一群のオブジェクトの事。
* Strategyの利用者はContextと呼ばれる
* 異なるストラテジオブジェクトをコンテキストに対して提供することで、アルゴリズムに多様性をもたらすことが出来る


### Observer 
* 他のコンポーネントの動きを監視するコンポーネントを作成
* オブジェクト同士の結合を弱く実装出来る
* 実装作業はサブジェクトクラスもしくはオブザーバルクラスに行われる
* Strategyと似ている。あるオブジェクト(オブザーバル/コンテキスト)が、他のオブジェクト(オブザーバ/ストラテジ)を呼び出す
    * 違い::Observerはイベントを他のオブジェクトに伝えること。Strategyは何か処理を行うためにストラテジオブジェクトを取得

<<<<<<< HEAD

### Iterator
* コレクションを操作するためのオブジェクトパターン
* 集約オブジェクトが内部表現を公開せず、その中の要素にアクセスする方法を提供する
* 外部イテレータ/内部イテレータの二種類が存在する
    * 外部イテレータ
        * イテレータが集約とは別のオブジェクトになっている
        * コレクションのメンバーを指し示すオブジェクト
    * 内部イテレータ
        * 子ブジェクトを扱うためのコードブロックを渡す

### Command
* 特定の動作を実行するオブジェクト
* これから実行する動作のリストや、実行したリストの管理をする場合に役立つ
    * migrationsはまさにいい例
* Observerに似ている
    * Observerは呼び出される対象の状態に関心がある
    * コマンドは興味が無い

### Adapter
* 必要なインターフェースと既存のオブジェクトの違いを吸収する
* active_recordで見ることが出来る
* クラスの変更で済ますパターン
    * 変更内容がシンプル
    * 変更するクラスとその使用法を
    理解している
* アダプタを利用するパターン
    * インターフェースの不整合が広範囲に及んで複雑
    * そのクラスがどのように動くか分からない

### Proxy
* 自分とは違う他のオブジェクトのふりをする
* 以下のような問題に対応することが出来る
    * 権限の無いアクセスのブロック
    * どこか別の場所にオブジェクトが存在する事実の隠蔽
    * 生成コストのかかるおｂジェクトのインスタンス化の遅延
* クライアントとサブジェクト(本物のオブジェクト)の間に処理を挟み込む機能を有する
=======
### Composite
* 概要
    * 全体が部分のように振る舞う状況を表すデザインパターン
* 適用パターン
    * 階層構造やツリー構造のオブジェクトを作りたい時
    * そのツリーを利用するコードが１つの単純なオブジェクトを扱っているのか、それてもごちゃごちゃした枝全体を扱っているのかを考えさせたくない時
* 構成要素
    * Component
        * すべてのオブジェクトの共通のインターフェースまたは基底クラス
    * Leaf
        * プロセスの単純な構成要素
    * Composite
        サブコンポーネントから作られる、より上位のオブジェクト


>>>>>>> f72bb3ff9f6834f06963237c6f2ba83ed36ffa17