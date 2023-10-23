import boto3
import json
import uuid
import os

BASEURL = os.environ["BASEURL"]
TABLENAME = os.environ["TBLNAME"]

dynamo = boto3.client('dynamodb')


#def lambda_handler(event, context):
def burn_after_read(event, context):

    print(f"BASEURL: {BASEURL}; TABLENAME: {TABLENAME}")
    operation = event['requestContext']['http']['method']
    
    if operation == 'GET':
        id = event['pathParameters']['id']
        
        item = dynamo.get_item(
            Key = {
                'id': {
                    'S': id
                },
            },
            TableName = TABLENAME,
        )
        if 'Item' in item:
            msg = item['Item']['msg']['S']
            dynamo.delete_item(
                Key = {
                    'id': {
                        'S': id
                    }
                },
                TableName = TABLENAME
            )
            return {
                'statusCode': 200,
                'body': f'Die gespeicherte Nachricht lautet:\n{msg}\n\nDie Nachricht wurde gelöscht'
            }
        else:
            return {
                'statusCode': 404,
                'body' : 'Keine Nachricht mit der angegebenen Id gefunden!'
            }    
        
    
    elif operation == 'POST':
        # msg = json.loads(event['body'])
        msg = event['body']
        id = str(uuid.uuid4()).replace('-', '')

        dynamo.put_item(
            Item = {
                'id': { 'S': id },
                'msg': { 'S': msg },
            },
            ReturnConsumedCapacity='TOTAL',
            TableName = TABLENAME
        )
        
        url = f"{BASEURL}/{id}".replace(' ', '')
        body = f'Zum (einmaligen) Lesen der Nachricht bitte folgende URL verwenden: {url}'
    
        return {
            'statusCode': 201,
            'body': body
        }

    else:
        return { 'statusCode': 405, 'body': json.dumps('Falsche Methode') }
