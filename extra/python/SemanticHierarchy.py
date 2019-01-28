from SemanticDataset import *

def getParentName(page):
	return getPage(page).get("Is child of")

def getParentsNames(page):
	parents = []

	if getPage(page).get("Is child of") != None:
		parents.append(getPage(page).get("Is child of"))

	for p in pagesWherePredicateIs("Is parent of", getPage(page).name):
		parents.append(p.name)

	return parents

def isPageInGroup(page, group):
	groups = [page.name for page in pagesWherePredicateIs("Is gathering", page)]
	return group in groups

def getAncestors(page, ancestorlevels=-1):
	ancestors = []

	for parent in getParentsNames(page):
		parent = getPage(parent)

		if ancestorlevels != 1:
			ancestors.extend(getAncestors(parent, ancestorlevels - 1))
			ancestors.append(parent)

		else:
			ancestors.append(parent)

	return ancestors

def getChildren(page):
	page = getPage(page)
	children = sorted(pagesWherePredicateIs("Is child of", page.name), key=lambda p: float(p.get("Order", 0)))

	for child in page.getall("Is parent of"):
		children.append(getPage(child))

	return children

def getSiblings(page):
	page = getPage(page)
	parent = getParentName(page)

	if parent:
		children = getChildren(parent)
		children.remove(page)
		return children

	else:
		return []

def hasNiecesOrNephews(page):
	for sibling in getSiblings(page):
		if len(getChildren(sibling)) > 0:
			return True

	return False

def getDescendants(page, childlevels=-1):
	page = getPage(page)
	result = []

	if childlevels != 0:
		for child in getChildren(page):
			result.append(child)

			if childlevels != 0:
				result.extend(getDescendants(child, childlevels - 1))

	return result

def getFamily(page, ancestorlevels=-1, childlevels=-1):
	page = getPage(page)
	result = getAncestors(page, ancestorlevels)
	result.append(page)
	result.extend(getDescendants(page, childlevels))
	return result

def getDescendantTree(page, level=0, childlevels=-1):
	page = getPage(page)

	result = {}
	result["page"] = page
	result["level"] = level
	result["parent"] = None
	result["children"] = []

	if childlevels != 0:
		for child in getChildren(page):
			childTree = getDescendantTree(child, level + 1, childlevels - 1)
			childTree["parent"] = result
			result["children"].append(childTree)

	return result

def getCategoryTree(category, level=0, childlevels=-1):
	page = getPage(category)

	result = {}
	result["page"] = page
	result["level"] = level
	result["parent"] = None
	result["children"] = []

	if childlevels != 0:
		for child in pagesInCategory(category):
			childTree = getDescendantTree(child, level + 1, childlevels - 1)
			childTree["parent"] = result
			result["children"].append(childTree)

	return result

def pruneNode(node):
	pruned = []

	for child in node["children"]:
		if pruneNode(child):
			pruned.append(child)

	if len(pruned):
		node["marked"] = True

	node["children"] = pruned
	return node["marked"]

def markNodeByPredicate(node, predicate, value):
	node["marked"] = (value in node["page"].getall(predicate))

	for child in node["children"]:
		markNodeByPredicate(child, predicate, value)

def getFilteredDescendantTreeByPredicate(page, predicate, value):
	tree = getDescendantTree(page)
	markNodeByPredicate(tree, predicate, value)
	pruneNode(tree)
	return tree

def markNodeByNames(node, names):
	node["marked"] = (node["page"].name in names)

	for child in node["children"]:
		markNodeByNames(child, names)

def getFilteredDescendantTreeByNames(page, names, level=0):
	tree = getDescendantTree(page, level)
	markNodeByNames(tree, names)
	pruneNode(tree)
	return tree

def getFamilyTree(page, ancestorlevels=-1, childlevels=-1):
	page = getPage(page)
	level = 0
	top = None
	parent = None

	for ancestor in getAncestors(page, ancestorlevels):
		result = {}
		result["page"] = ancestor
		result["level"] = level
		result["children"] = []
		level += 1

		if top:
			parent["children"].append(result)
			result["parent"] = parent

		else:
			top = result
			result["parent"] = None

		parent = result

	if parent:
		childTree = getDescendantTree(page, level, childlevels)
		parent["children"].append(childTree)
		childTree["parent"] = parent
		return top

	else:
		return getDescendantTree(page, level, childlevels)

def treeToList(tree):
	result = [tree["page"].name]

	for child in tree["children"]:
		result.extend(treeToList(child))

	return result

def treeToTreeList(tree):
	result = [(tree["page"].name, tree["level"], tree)]

	for child in tree["children"]:
		result.extend(treeToTreeList(child))

	return result

def treeToPageLevelTuppleList(tree):
	result = [(tree["page"].name, tree["level"])]

	for child in tree["children"]:
		result.extend(treeToPageLevelTuppleList(child))

	return result

def expandListToIncludeAllChildren(pages):
	result = []

	for page in pageNamesFromList(pages):
		result.append(page)
		result.extend(pageNamesFromList(getDescendants(page)))

	return unique(result)

def expandListToListTree(pages):
	result = []

	for page in pageNamesFromList(pages):
		result.append(getDescendantTree(page))

	return result

def convertListToListTree(pages):
	result = []

	for page in pageNamesFromList(pages):
		result.append(getDescendantTree(page,childlevels=0))

	return result

def listTreeToPageLevelTuppleList(list):
	result = []

	for item in  list:
		result.extend(treeToPageLevelTuppleList(item))

	return result

def pageLevelTuppleListToList(list):
	result = []

	for item in  list:
		result.append(item[0])

	return result

def indexTuppleList(list):
	result = []
	level = 0
	indicies = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]

	for item in  list:
		if item[1] > level:
			level += 1
			indicies[level] = 0

		elif item[1] < level:
			level = item[1]

		indicies[level] += 1
		index = ""

		for i in range(0, level+1):
			index += str(indicies[i]) + "."

		result.append({'name':item[0],'level':item[1],'index':index})

	return result

def hasGrandChildren(page):
	for child in getChildren(page):
		if len(getChildren(child)) > 0:
			return True

	return False
