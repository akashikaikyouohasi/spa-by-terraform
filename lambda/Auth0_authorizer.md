# Auth0のCustom Authorizer設定方法
このAuth0の[docs:Secure AWS API Gateway Endpoints Using Custom Authorizers](https://auth0.com/docs/customize/integrations/aws/aws-api-gateway-custom-authorizers)の通りに進めていく

## 手順
### Create an Auth0 API
https://auth0.com/docs/customize/integrations/aws/aws-api-gateway-custom-authorizers#create-an-auth0-api

*identifier*はAPI Gatewayに設定したカスタムドメイン名です。

### Prepare the custom authorizer
https://github.com/auth0-samples/jwt-rsa-aws-custom-authorizer　からカスタムオーソライザーのソースコードをダウンロード。

ダウンロードしたものをunzip
```
# unzip jwt-rsa-aws-custom-authorizer-master.zip
```

*npm install*
```
# cd jwt-rsa-aws-custom-authorizer-master
# npm install
```

ローカルの環境設定
```
# cp -p .env.sample .env
# vim .env
```

### Test the custom authorizer locally
Auth0のAPIのページで、*Test*タブで*Response*の箇所のaccess_tokenをメモしておきます。

event.jsonの作成
```
# cp -p event.json.sample  event.json
# vim event.json
```
**authorizationToken**は、`"Bearer {Auth0のTestタブのReaponseで確認したaccess_token}"`のフォーマットで書いてください。

**methodArn**はAPI Gatewayのコンソール⇒左のリソースタブ⇒作成したリソースパスのメソッド(ANYやGET)⇒メソッドリクエストの枠内のARN

テストして、以下のようにAPI Gatewayが許可されればOKです。
```
# npm test
(途中省略)
    Action": "execute-api:Invoke",
        "Effect": "Allow",
        "Resource": "arn:aws:execute-api:ap-northeast-1:XXXXXXXXXXXX:XXXXXXXXXX/*/GET/dynamodb"
```

### Create the Lambda function and deploy the custom authorizer
Lambda関数用にビルドして**custom-authorizer.zip**を作成します。ついでに不要なファイルも削除しておきます。

```
# rm -f .env .env.sample event.json event.json.sample
# npm run bundle
# ll custom-authorizer.zip
-rw-r--r--. 1 root root 6651992 Mar 22 00:49 custom-authorizer.zip
```

Lambda関数をTerraformで作成します。

作成したLambda関数のテストタブで*新しいイベント*を作成します。
内容は、上で作成した*event.json*です。（時間が経つと*access_token*の有効期限が切れるので、適宜更新してください。）


