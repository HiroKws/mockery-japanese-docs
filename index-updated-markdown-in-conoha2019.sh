#!/bin/bash

git --no-pager diff --name-status $(cat before-commit.txt) | awk -e '($1=="A" || $1 == "M" || $1=="R100") { if($1=="R100" && $3~/\.md$/) { print $3 } else if ($2 ~ /\.md$/) { print $2 }}' | awk -e 'BEGIN {FS="/"} /\/ja\// {print "cd /home/hiro/searchdouble && php artisan index:mockery", $0, $2, $3, gensub(".md", "", "1", $5)}' | bash

# 現在のコミットIDを保存する
git rev-parse HEAD > before-commit.txt
