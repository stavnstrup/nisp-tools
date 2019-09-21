from SemanticDataset import *
from SemanticHierarchy import *

pages = loadDataset("em")
AllPageNames = list(getAllPageNames())

# encode xml escape characters
def encodeXMLText(text):
    text = text.replace("&", "&amp;")
    text = text.replace("\"", "&quot;")
    text = text.replace("'", "&apos;")
    text = text.replace("<", "&lt;")
    text = text.replace(">", "&gt;")
    return text

def printNode(name, level):
    page = getPage(name)
    uuid = 'MISSING UUID'
    uuidarray = page.getall('UUID')
    if uuidarray:
        uuid=uuidarray[0]
    descr = ''
    descrarray = page.getall('Description')
    if descrarray:
        descr = descrarray[0]
    starttag = '<node title="' + encodeXMLText(name)  + '" level="'  + str(level) + '" id="T-' + uuid
    starttag +=  '-X" description="' + encodeXMLText(descr) + '" emUUID="' + uuid + '">'
    print(starttag)
    children = getChildren(page)
    if len(children)>0:
        for child in children:
            printNode(child.name, level+1)
    print('</node>')


print('<?xml version=\'1.0\'?>')
print('<taxonomy>')
printNode('Operational Context', 1)
printNode('CIS Capabilities', 1)
print('</taxonomy>')
