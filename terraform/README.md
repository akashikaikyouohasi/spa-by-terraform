# Terrafromの使い方
## 初期化
Terraformは個別にインストールしてくださぁ

初期化
```
$ terraform init
```

## Terrformの状態変数の管理S3バケット設定
GitHub ActionsでTerraformをapplyすると、状態を表すtstateファイルがなくなってしまう。

そこで、状態ファイルをS3で管理するようにする。

適当なS3バケットは作成されていることを前提に、以下に設定すること

```main.tf
backend "s3" {
    bucket = "{Terraformの状態管理用のバケットの名前}"
    key = "{出力ディレクトリパス}/terraform.tfstate"
    region = "ap-northeast-1"
  }
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


