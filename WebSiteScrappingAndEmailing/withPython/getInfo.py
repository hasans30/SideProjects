import requests
from bs4 import BeautifulSoup
import smtplib
import ssl
import os
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText
import hashlib
import telemetry

'''
This program reads url and and notifies via email

Please set below environment variables
EMAILTO -- who to send
EMAILUSER -- username
EMAILHELP -- password

'''


def myImmiHelper(url,sub):

    filename=hashlib.sha256(url.encode('utf-8')).hexdigest()
    response = requests.get(url)
    parsedContent = BeautifulSoup(response.text, 'html.parser')
    entries = str(parsedContent.find('table', {'class':'graphTable'}))
    changed=getIfUpdated(filename,entries)
    if(changed):
        with open(filename,encoding="utf-8",mode="w") as file:
            file.write(entries)
            file.close()
        sendEmail(entries,sub)
    else:
        print('no new update')

def getIfUpdated(filename,newContent):
    oldContent=''
    try:
        with open(filename,encoding="utf-8",mode="r") as file:
            oldContent=file.read()
            file.close()
    except Exception as e:
        print('exception occured while reading file')
        print(e)
    if oldContent==newContent:
        return False
    else:
        return True


def sendEmail(entries,sub):
    sender = os.environ['EMAILUSER']
    receivers = [os.environ['EMAILTO']]
    subject =  sub

    message = MIMEMultipart('alternative')
    message['From'] = sender
    message['To'] = receivers[0]
    message['Subject'] = subject
    body = entries

    message.attach(MIMEText(body, 'html'))


    smtp = 'smtp.gmail.com'
    user = sender
    password = os.environ['EMAILHELP']
    print(sender+'-'+receivers[0])

    try:

        smtpObj = smtplib.SMTP(smtp, 587)
        smtpObj.starttls()
        smtpObj.login(user, password)

        smtpObj.sendmail(sender, receivers, message.as_string())
        print("Successfully sent email")
    except Exception as e:
        print("Error: unable to send email")
        print(e)

urls = [
        {"url":"https://www.immihelp.com/visa-bulletin-movement/eb1-india/filing","sub":"EB1 filing"},
        {"url":"https://www.immihelp.com/visa-bulletin-movement/eb1-india/final","sub":"EB1 final"},
        ]

for url in urls:
    myImmiHelper(url["url"],url["sub"])
sendSignal("immihelp")
