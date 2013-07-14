#fluentd+mongodb検証
##環境
* Mac OSX lion

##概要
* nginx + fluentd + mongodbの環境を構築
* nginxのログをmongodbに突っ込んでいく
* さらにmongodbのMapReduceで集計


##インストール
ruby 1.9系の準備

    brew install rbenv
    brew install ruby-build
    #gccがなかったらいれる
    rbenv install 1.9.3-p392
    rbenv rehash
    rbenv global 1.9.3-p392

fluentdとmongo用gem

    gem install fluentd
    gem install fluent-plugin-mongo

nginx

    brew install nginx
    
mongo

    brew install mongo

##検証環境起動
mongod起動

    mongod --dbpath ~/tmp/var/db/mongo

fluentd

    fluentd -c conf/fluent.conf

nginx

    sudo nginx -c $(pwd)/conf/nginx.conf


## config
### 設定項目
| ディレクティブ | 内容 |
|:--------------:|:----:|
| source | ログの入力方法。デフォルトでは、STDIN/FILE/PORT指定のHTTP 等 |
| match | ここでマッチしたログに指定した処理を適用。STDOUT / file / 他のfluentdサーバへの転送 等 |
| include | 他の設定ファイルをinclude出来る |
| tag | IDの様なものを指定可能 |


### source
* ファイル名が動的な場合、以下を使うとよさそうだ
    * http://blog.4shs.org/2013/01/02/introducing_fluent_plugin_tail_ex.html 


### フォーマット
lighttpd

    /^(?<host>\S+): (?<scheme>\S+): (?<remote>\S+) (?<server>\S+) (?<user>\S+) \[(?<date>.*)\] "(?<method>\S+) (?<path>\S+) (?<protocol>\S*)" (?<status>\S*) (?<byte>\S*) "(?<referer>\S*)" "(?<useragent>[^\"]+)"$/

format生成については、以下が参考になる

* http://d.hatena.ne.jp/tagomoris/20120715/1342368392

lighttpdの時は以下で頑張った

    #!/usr/lib64/fluent/ruby/bin/ruby
    require 'time'
    require 'fluent/log'
    require 'fluent/config'
    require 'fluent/engine'
    require 'fluent/parser'
    
    $log ||= Fluent::Log.new
    
    # debug
    log = 'web-adc01: http: 192.168.0.1 192.168.11.2 - [15/Apr/2013:16:48:30 +0900] "GET /w?serialized_params=ba5cda2ad3b65c2f8babfb55&u=20130415164727v1 HTTP/1.1" 200 43 "http://referer-test.example" "Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.5; ja-JP-mac; rv:1.9.1.5) Gecko/20091102 Firefox/3.5.5 GTB5"'
    format = /^(?<host>\S+): (?<scheme>\S+): (?<remote>\S+) (?<server>\S+) (?<user>\S+) \[(?<date>.*)\] "(?<method>\S+) (?<path>\S+) (?<protocol>\S*)" (?<status>\S*) (?<byte>\S*) "(?<referer>\S*)" "(?<useragent>[^\"]+)"$/
    
    #"(?\S+)(?: +(?[^ ]*) +\S*)?" (?[^ ]*) (?[^ ]*)(?: "(?[^\"]*)" "(?[^\"]*)" (?[^ ]*))?
    #accesslog.format = "%h %V %u %t \"%r\" %>s %b \"%{Referer}i\" \"%{User-Agent}i\""
    
    time_format = ''
    
    parser = Fluent::TextParser::RegexpParser.new(format, 'time_format' => time_format)
    puts parser.call(log)



