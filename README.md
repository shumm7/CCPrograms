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
引数に`side`を指定する。

## github
GitHub上の指定したレポジトリから、ファイルをダウンロードし、実行する。  
また、これらのAPIも提供する。`repository url`は`https://github.com/username/project.git` か `https://github.com/username/project`の形式。  

`github get <repository url> <branch name> <directory> <filename>`  
`github run <repository url> <branch name> <directory> <arguments>`  
`get(repository_url, branch_name, directory, filename)`  
`run(repository_url, branch_name, directory, argument1, argument2 ...)`  

## download
指定したURLからデータをダウンロードし、保存・実行する。  
自動ダウンロード用のAPIも提供する。  
`download get <url> <filename>` ファイルをダウンロードし保存（上書きしない）  
`download update <url> <filename>` ファイルをダウンロードし保存（上書きする）  
`download run <url> <arguments>...` プログラムをダウンロードし、実行  
  
`getString("url")` 文字列をURLから取得する。  
`checkExists("path")` 指定したディレクトリが存在すれば`true`、そうでなければ`false`を返す。  
`saveString("string", "path")` 文字列を`path`に保存する。  
`download("url", "filename", "mode(a/w)")` 指定したURLからデータを取得し、`filename`に保存する。`mode`は`a`（上書きしない）か`w`（上書きする）を指定。  
`run("url", <arguments>...)` 指定したURLのプログラムを実行。引数は可変長。  
