# CCPrograms
実際にプレイで使用したものですが、バグがあるかもしれません。

## turtle.tunnel
引数で指定した距離、幅、高さで採掘を行う。

## turtle.smelting
自動的に精錬を行う。

## turtle.smeltery
Tinkers' ConstructのSmelteryから金属を自動で型に流し、回収する。

## turtle.quarry
引数で指定した範囲を露天掘りする。

## turtle.hopper
上面からアイテムを回収、下面からアイテムを挿入する。

## trutle.compresscraft
圧縮系のクラフトを自動で行う

## turtle.autocompress
圧縮系のクラフトを自動で行う。アイテム回収機能付き。

## computer.othello
隣接するAdvanced Monitorにオセロを表示する。

## github
GitHub上の指定したレポジトリから、ファイルをダウンロードし、実行する。  
また、これらのAPIも提供する。`repository url`は`https://github.com/username/project.git` か `https://github.com/username/project`の形式。  

`github get <repository url> <branch name> <directory> <filename>`  
`github run <repository url> <branch name> <directory> <arguments>`  
`get(repository_url, branch_name, directory, filename)`  
`run(repository_url, branch_name, directory, argument1, argument2 ...)`  
