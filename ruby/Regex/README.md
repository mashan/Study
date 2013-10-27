正規表現
=======

理論
--------

### 基礎

* 正規表現は数学的な概念のもと存在している
* 「任意の文字（空文字を含む）を、以下の3つの規則を繰り返し適用して組み合わせた表現」が定義となる
    * 文字列の和集合(A or B) : A|B
    * 文字列の連結 : AB
    * 文字列の繰り返し : A*
* 言語によってサポートされている表記方法は、上記で代替可能

### 部分一致について

* 言語に正規表現よって可能な事は、長い文字列の一部分にマッチさせる事
* これは、前方一致と後方一致を併せたものと考えられる
* 前提として正規表現エンジンは以下の性質を持っている
    * 文字列を一文字ずつ受けて判定する
    * 一文字入力される毎に、「受理状態」であるか無いかを遷移する

#### 前方一致マッチング

* 正規表現の文字を受理状態で終了した場合、マッチ成功とみなす
    * 例 : 正規表現 (hoge|fuga) , 対象文字列 ( piyohogefuga )
        * piyohoge の時点で成功とみなす


#### 後方一致マッチング

* 正規表現にマッチさせる文字列一文字ずつ短くしながら検査を繰り返す
    * 例 : 正規表現 (hoge|fuga) , 対象文字列 ( piyohogefuga )
        1. piyohogefuga にヒットするか？
        1. iyohogefuga にヒットするか？
        1. yohogefuga ....
        1. .....

### NFAとDFA

* 正規表現は実際にコンピュータで表現しようとすると困難なため、別の概念を導入する
* それがNFA(Nondeterministic Finite Automation),DFA(Deterministic Finite Automation)
* FAは、有限オートマトンと呼ばれる
    * 文字列を入力すると真偽値を返す
    * 一文字入力する毎に内部状態を変化させる
    * 最終的に「受理状態」かどうかで出力を決定

#### NFA

* 非決定性なオートマトン。入力によって一意に状態が決まらない
* 実装は複雑になる

#### DFA

* 決定性があるオートマトン。入力文字による状態遷移先はただひとつ


エンジン
-------

### 鬼車
#### What?

* C++実装
* Ruby(1.9.1〜) やPHPで利用されている
* マルチバイトを処理するのに適している

#### 動作

* 正規表現を渡した時、以下のように動く
    1. tokenに分ける
    1. tree構造化(Abstract Syntax Tree(AST))
    1. Virtual Machineによって処理するためにCompile (VM Instructions)。(鬼車がVMをもって処理をしている)

#### 実例
##### 1. シンプルなマッチ

プログラム

``
str = "The quick brown fox jumps over the lazy dog."
p str.match(/brown/)
``

デバッグ(rubyコンパイル時に可能)を有効にして実行すると以下の結果が返ってくる

``
PATTERN: /brown/ (US-ASCII)
optimize: EXACT_BM
exact: [brown]: length: 5

code length: 7
0:[exact5:brown] 6:[end]

match_at: str: 140261368903056 (0x7f912511b590) etc ...
size: 44, start offset: 10
  10> "brown f..."         [exact5:brown]
  15> " fox ju..."         [end]

#<MatchData "brown">
``

* 検索対象の構造化は以下のようになる
    * [exact5:brown] : 現在の文字列のポジションから、5文字でbrownとなるかを確認
    * [end] : 検索を停止。そこまでの所で一致していたかを戻す
* マッチまでの流れ
    * brown という文字列(構造化された最初の文字列。文字ではない(!!))の開始位置を把握する
    * [exact5:brown] の検証。一致するのでOK。次の構造へ
    * [end]の検証。文字通り完了。一致していたのでOK

##### 2. 複数候補の文字列

プログラム

``
str = "The quick brown fox jumps over the lazy dog."
p str.match(/black|brown/)
``

デバッグ(rubyコンパイル時に可能)を有効にして実行すると以下の結果が返ってくる

``
PATTERN: /black|brown/ (US-ASCII)
optimize: EXACT
exact: [b]: length: 1

code length: 23
0:[push:(11)] 5:[exact5:black] 11:[jump:(6)] 16:[exact5:brown] 22:[end]

match_at: str: 140614855412048 (0x7fe37281c950), ...
size: 44, start offset: 10
  10> "brown f..."         [push:(11)]
  10> "brown f..."         [exact5:black]
  10> "brown f..."         [exact5:brown]
  15> " fox ju..."         [end]
``
 
* 構造化は以下
    * "exact: [b]: length: 1" : "b"が共通なのでexactの確認をする
    * "[push:(11)] " : "b"が現れた時に、BackTraceを設定する。BackTraceは、その後のマッチの選択肢が複数ある時、一度失敗した場合に戻ってきて他の選択肢を実行出来るようにするためのもの
    * "[exact5:black]"/"[exact5:brown]" / 完全一致するか確認
* マッチまでの流れ
    * "b"にマッチする箇所を検索
    * BackTraceの設定(PUSH)。blackとbrownのexactがStackへ
    * blackと一致するかを確認
    * 一致しなかったため、BackTraceを参照し、brownを確認
    * 一致し、endへ到達。RubyへとReturn

##### 3. anychar*の利用

プログラム

``
str = "The quick brown fox jumps over the lazy dog."
p str.match(/brown.*/)
``

デバッグ(rubyコンパイル時に可能)を有効にして実行すると以下の結果が返ってくる

``
PATTERN: /brown.*/ (US-ASCII)
optimize: EXACT_BM
exact: [brown]: length: 5

code length: 8
0:[exact5:brown] 6:[anychar*] 7:[end]

match_at: str: 140284579067040 (0x7f968c80b4a0), ...
size: 44, start offset: 10
  10> "brown f..."         [exact5:brown]
  15> " fox ju..."         [anychar*]
  44> ""                   [end]

``

* 新しい構造は以下
    * [anychar\*] .* と同等。
* マッチの流れ
    * "brown"にマッチ
    * anychar* へと制御が移る
        * 当然次の文字(ここでは" "(スペース)にマッチする
        * 自分自身のinstruction(つまりanychar\*)へとループバックし、次の文字列を確認
        * BackTraceに現在判定対象の文字、及び次のinstructionをpushしながら実施。BackTraceにはendや次のinstructionが実施されるまで延々と記録される
    * anychar* にマッチしなくなった時点で、BackTraceからendを呼び出すので、成功となる。そしてBackTraceに含まれる文字列全てをRubyに返す


パフォーマンスに関して
----------------------

