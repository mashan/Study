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



