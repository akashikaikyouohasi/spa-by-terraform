import json
# AWSをPythonで利用するためのSDK boto3をインポートする
import boto3

from boto3.dynamodb.conditions import Key, Attr
 
# Functionの実行ログを出力
print('Loading function')
 
# DynamoDBと接続
dynamodb = boto3.resource('dynamodb')
 
# テーブル内のIDを指定してデータを該当するitemを取得する
def lambda_handler(event, context):
    # DynamoDBの情報
    table_name = "DynamodbForSPA"
    partition_key = {"id": event['queryStringParameters']["id"]}
    dynamotable = dynamodb.Table(table_name)

    # DyanamoDBからデータ取得
    res = dynamotable.get_item(Key=partition_key)
    item = res["Item"]
    
    return {
        # CORSのために、GETメソッド実行を許可するドメイン名
        'headers': {
            "Access-Control-Allow-Headers" : "Content-Type",
            "Access-Control-Allow-Origin": "https://testwww.build-automation.de",
            "Access-Control-Allow-Methods": "GET"
        },
        'statusCode': 200,
        'body': json.dumps(item)
    }