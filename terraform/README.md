# Terrafromの使い方
## 初期化
Terraformは個別にインストールしてくださぁ

初期化
```
$ terraform init
```

## 環境変数の各自調整
variables.tfの中身を各自の環境に合わせること

## バリデーションチェック
```
$ terraform validate
Success! The configuration is valid.
```

## コードフォーマット
```
$ terraform fmt -recursive
（フォーマットされたファイル名）
```

## 実行
確認
```
terraform plan
```

実行
```
terraform apply
```


