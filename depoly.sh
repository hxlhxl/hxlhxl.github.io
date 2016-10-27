#!/bin/bash
#

git_dir="/search/huaxiong/hxlhxl.github.io"
hexo_dir="/search/huaxiong/hexo"

hexo clean
hexo generate
hexo deploy

sleep 1

cd $git_dir
git branch backup
git checkout backup

_config.yml  db.json  depoly.sh  node_modules  package.json  public  scaffolds  source  themes
\cp -fa ${hexo_dir}/{_config.yml,depoly.sh,package.json,scaffolds,source,themes} ${git_dir}/
\cp -fa ${hexo_dir}/.deploy_git ${git_dir}/
# cp -fa ${hexo_dir}/.gitignore ${git_dir}/

git add .
git commit -m `date +"%Y-%m-%d_%H:%M"`
git push origin backup
