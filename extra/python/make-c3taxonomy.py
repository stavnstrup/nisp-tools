# Transform the C3 Taxonomy in a Pickl file to a XML representation for use in NISP
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


def createStartTag(name, level, descr, uuid):

    starttag = '<node title="' + encodeXMLText(name)  + '" level="'  + str(level) + '" id="T-' + uuid
    starttag +=  '-X" description="' + encodeXMLText(descr) + '" emUUID="' + uuid + '">'
    return starttag

def printNode(name, level, maxlevel):
    page = getPage(name)
    descr = ''
    descrarray = page.getall('Description')
    if descrarray:
        descr = descrarray[0]
    uuid = 'MISSING UUID'
    uuidarray = page.getall('UUID')
    if uuidarray:
        uuid=uuidarray[0]
    print(createStartTag(name, level, descr, uuid))
    if (maxlevel==0) or (level < maxlevel):
        children = getChildren(page)
        if len(children)>0:
            for child in children:
                printNode(child.name, level+1, maxlevel)
    print('</node>')


print('<?xml version=\'1.0\'?>')
print('<taxonomy>')
printNode('Operational Context', 1, 4)
printNode('CIS Capabilities', 1, 4)
print('</taxonomy>')
