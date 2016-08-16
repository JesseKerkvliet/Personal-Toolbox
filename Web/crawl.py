import urllib
from BeautifulSoup import *

def main():
    lenlist = []
    IDS = open('ISIDS.txt', 'r').readlines()
    count = 1
    for ID in IDS:
        #print(ID)   
        print count
        url = "https://www-is.biotoul.fr/scripts/ficheIS.php?name=%s" %ID
        html = urllib.urlopen(url).read()
        info = scrape(html)
        lenlist.append([ID.strip("\n"), info[1], info[0]])
        count += 1
    output = open("lengths_blastx.csv", 'a')
    for length in lenlist:
        output.write("\t".join(length))
        output.write('\n')
    output.close()

def scrape(html):


    soup = BeautifulSoup(html)
    lengths = []

    divs = soup.find('div', {'id':'droite'})
    contentList = []
    for div in divs:
        contentList.append(div)
    fam = soup.find('div', {'id':'seq_ident'})
    family= fam.li.getText().strip("Family")
    #print fam
    #family = str(fam).split("</")[2].strip("span>")
    #print family
    return((str(contentList[1].strip(" bp"))),family)


main()
#url = "https://www-is.biotoul.fr/scripts/ficheIS.php?name=IS257-1"
#html = urllib.urlopen(url).read()
#print(scrape(html))
