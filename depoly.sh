#!/bin/bash
#

pwd_dir=`pwd`
post_dir=${pwd_dir}"/source/_posts/"
# 移动资源到hexo
find /search/service/nginx/html/opWeb/resourse/hexo/image/ -name "*.md" -print0 | xargs -0 -I % mv % ${post_dir}
# 或者使用下面的方式,记得要加逗号
# find /search/service/nginx/html/opWeb/resourse/hexo/image/ -name "*.md" -exec cp -fa {} ${post_dir} \;
#
git_dir="/search/huaxiong/hxlhxl.github.io"
hexo_dir="/search/huaxiong/hexo"

cd ${pwd_dir}
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
