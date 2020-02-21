import requests
from bs4 import BeautifulSoup
import smtplib
import ssl
import os
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText

'''
This program reads url and and notifies via email

Please set below environment variables
EMAILTO -- who to send
EMAILUSER -- username
EMAILHELP -- password

'''


def myImmiHelper():

    url = "https://www.immihelp.com/visa-bulletin-movement/eb1-india/filing"
    response = requests.get(url)
    parsedContent = BeautifulSoup(response.text, 'html.parser')
    entries = str(parsedContent.find('table', {'class':'graphTable'}))
    with open("_test.html",encoding="utf-8",mode="w") as file:
        file.write(entries)
        file.close()

    sender = os.environ['EMAILUSER']
    receivers = [os.environ['EMAILTO']]
    subject = 'Visa Bulletin EB1 India Filing'

    message = MIMEMultipart('alternative')
    message['From'] = sender
    message['To'] = receivers[0]
    message['Subject'] = subject
    body = entries

    message.attach(MIMEText(body, 'html'))


    smtp = 'smtp.office365.com'
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


myImmiHelper()
