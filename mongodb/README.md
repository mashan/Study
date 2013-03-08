#mongodbについて
##特徴
* ドキュメント指向
* インデックスをサポート
* レプリケーション可能
* 自動シャーディング

##用途
###向き
* カラムを固定できない場合
* スキーマの変更が頻繁に行われる場合
* shardingの強みを活かしたい場合

###不向き
* 非常にハイパフォーマンスが求められる場合
* 完全なACIDを必要とする場合
* HW利用効率を求める場合
    * レプリカは存在するものの、参照用とで利用できない。
    * 基本はshardingでパフォーマンスを高める
    * ディスク利用効率も高くない

###操作概念
* DB
    * まんまdatabase
* Collection
    * tableみたいなもん
* Object
    * Collectionに突っ込む内容

##操作
###起動
任意のパスに保存用dirを作ってから

    mongod --dbpath ~/tmp/var/db/mongo

##集計
[こちら](http://d.hatena.ne.jp/yutakikuchi/20130220/1361316293)を参考にnginx+fluentd+mongodb環境を作っている前提

    var m = function () {
     
       var getYMDH = function (d) {
      
         d.setSeconds(0);
         d.setMilliseconds(0);
         d.setMinutes(0);
    
         yy = d.getFullYear();
         mm = d.getMonth() + 1;
         dd = d.getDate();
         hh = d.getHours();
         MM = d.getMinutes();
         ss = d.getSeconds();
    
         if (mm < 10) { mm = "0" + mm; }
         if (dd < 10) { dd = "0" + dd; }
         if (hh < 10) { hh = "0" + hh; }
         return yy + '-' + mm + '-' + dd + ' ' + hh + ':' + MM + ':' + ss;
       };
     
       emit(getYMDH(this.time), 1);
    };
      
      
    var r = function(key,values) {
        return Array.sum(values);
    };
      
    var JSTDate = function (str) {  return ISODate(str + "T00+09:00");  };
    var query  = { "time" : { "$gte" : JSTDate("2013-03-01 8:00:00"), "$lt" : JSTDate("2013-03-02 8:00:59") } };
    
    db.nginx_access.mapReduce(m,r, { query : query , out : 'myresults' } );
      
    db.myresults.find();



