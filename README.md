# [wangyijie.github.io/blog/](wangyijie.github.io/blog/)


# google 

<script async src="https://pagead2.googlesyndication.com/pagead/js/adsbygoogle.js?client=ca-pub-6266541561533854"
    crossorigin="anonymous"></script>

# build:
hugo -d docs
git add docs
git add content
git commit -m "$(date)"
## 修改commit
 git commit --amend


# convert by pandoc
 pandoc.exe .\docker-overlay-networks.html -f html -t markdown -o docker-overlay-networks.md

# 新增文章
  hugo new content\posts\network\git-proxy.md

