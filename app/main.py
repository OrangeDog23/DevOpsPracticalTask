#!/usr/bin/env python3

from flask import Flask, request, render_template
import boto3
from botocore.exceptions import ClientError
import sys
import logging

logger = logging.getLogger(__name__)
handler = logging.StreamHandler(sys.stdout)
handler.setFormatter(logging.Formatter('%(message)s'))
handler.setLevel(logging.INFO)
logger.addHandler(handler)
logger.setLevel(logging.INFO)

SENDER = "glishao.d.market@gmail.com"
RECIPIENT = "glishao.d.market@gmail.com"
# CONFIGURATION_SET = "default"
AWS_REGION = "eu-west-1"
SUBJECT = "Amazon SES Test (SDK for Python)"
BODY_TEXT = "Message body: '{}'"
BODY_HTML = """<html>
<head></head>
<body>
{}
</body>
</html>
"""
CHARSET = "UTF-8"


def get_header():
    client = boto3.client('ssm', region_name=AWS_REGION)
    try:
        parameter = client.get_parameter(Name='/devops/ssm-message-header')
        return parameter['Parameter']['Value']
    except ClientError as e:
        logger.exception("failed to fetch parameter")
        return None


def send_message(message_body):
    client = boto3.client('ses',region_name=AWS_REGION)
    SUBJECT = get_header()
    result = ''
    if SUBJECT:
        try:
            #Provide the contents of the email.
            response = client.send_email(
                Destination={
                    'ToAddresses': [
                        RECIPIENT,
                    ],
                },
                Message={
                    'Body': {
                        'Html': {
                            'Charset': CHARSET,
                            'Data': BODY_HTML.format(message_body),
                        },
                        'Text': {
                            'Charset': CHARSET,
                            'Data': BODY_TEXT.format(message_body),
                        },
                    },
                    'Subject': {
                        'Charset': CHARSET,
                        'Data': SUBJECT,
                    },
                },
                Source=SENDER,
                # If you are not using a configuration set, comment or delete the
                # following line
                # ConfigurationSetName=CONFIGURATION_SET,
            )
        # Display an error if something goes wrong.	
        except ClientError as e:
            result += e.response['Error']['Message']
        else:
            result += "Email sent! Message ID:" + response['MessageId']
    else:
        print('failed to fetch header from SSM storage')
    return result


app = Flask(__name__)
@app.route('/')
def hello_world():
    return 'Hello, World!'

@app.route('/send-sns', methods=['GET', 'POST'])
def send_sns():
    if request.method == 'GET':
        return render_template('send_sns_template.html')
    elif request.method == 'POST':
        result = send_message(request.form['message_body'])
        return result
        


def main():
    print("run as a main module")
    return 0
    
    
if __name__=="__main__":
    main()
