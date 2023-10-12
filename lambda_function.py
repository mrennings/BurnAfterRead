import boto3
import json
import uuid

BASEURL = 'https://pzsj5pym2h.execute-api.eu-central-1.amazonaws.com/'
TABLENAME = 'ue113b2'

dynamo = boto3.client('dynamodb')


def lambda_handler(event, context):

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
        msg = json.loads(event['body'])
        id = str(uuid.uuid4()).replace('-', '')

        dynamo.put_item(
            Item = {
                'id': { 'S': id },
                'msg': { 'S': msg },
            },
            ReturnConsumedCapacity='TOTAL',
            TableName = 'ue113b2'
        )
        
        url = f"{BASEURL}{id}".replace(' ', '')
        body = f'Zum (einmaligen) Lesen der Nachricht bitte folgende URL verwenden: {BASEURL}{id}'
    
        return {
            'statusCode': 201,
            'body': f'Zum (einmaligen) Lesen der Nachricht bitte folgende URL verwenden: {BASEURL}{id}'
        }

    else:
        return { 'statusCode': 405, 'body': json.dumps('Falsche Methode') }
