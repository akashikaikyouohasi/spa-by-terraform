#/bin/bash
aws dynamodb put-item --table-name DynamodbForSPA --item '{ "id": { "S":"1001"}, "test_id": { "S": "TerraformBySPA"} }'