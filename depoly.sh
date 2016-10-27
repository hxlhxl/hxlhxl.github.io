#!/bin/bash
#

git_dir="/search/huaxiong/github/hxlhxl.github.io"
hexo_dir="/search/huaxiong/hexo"

hexo clean
hexo generate
hexo deploy

sleep 1

cd $git_dir
git branch hexo
git checkout hexo

cp -fa ${hexo_dir}/* ${git_dir}/
cp -fa ${hexo_dir}/.deploy_git ${git_dir}/
# cp -fa ${hexo_dir}/.gitignore ${git_dir}/

git add .
git commit -m `date +"%Y-%m-%d_%H:%M"`
git push origin hexo
