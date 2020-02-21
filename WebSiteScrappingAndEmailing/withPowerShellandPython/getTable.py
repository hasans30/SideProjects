import re
import requests
from bs4 import BeautifulSoup
import sys


if ( len(sys.argv) != 2 ):
    print('no filename argument passed')
    exit(1)
filename=sys.argv[1]

vgm_url = 'https://www.immihelp.com/visa-bulletin-movement/eb1-india/filing'
html_text = requests.get(vgm_url).text
soup = BeautifulSoup(html_text, 'html.parser')

table = soup.find('table', {'class':'graphTable'})
strtable=str(table)
with open(filename, encoding='utf-8', mode='w') as f:
    f.write(strtable)
        