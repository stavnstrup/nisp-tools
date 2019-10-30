import os, re
import _pickle as cPickle
import pandas as pd

class MultiDict(object):
	def __init__(self):
		self.data = {}

	def __eq__(self, other):
		return self.data == other.data

	def __ne__(self, other):
		return self.data != other.data

	def __repr__(self):
		return "<MultiDict %s>" % (self.data,)

	def __len__(self):
		return len(self.data)

	def __setitem__(self, key, value):
		self.data.setdefault(key, []).append(value)

	def __getitem__(self, key):
		return self.data[key][-1]

	def __delitem__(self, key):
		del self.data[key]

	def __contains__(self, key):
		return key in self.data

	def __iter__(self):
		return iter(self.data)

	def get(self, key, default = None):
		return self.data.get(key, [default])[-1]

	def getall(self, key, default = []):
		return self.data.get(key, default)

	def keys(self):
		return self.data.keys()

	def items(self):
		return [(k, v[-1]) for k, v in self.data.items()]

	def allitems(self):
		return self.data.items()

class Page(MultiDict):
	def __init__(self, name):
		super(Page, self).__init__()
		self.name = name

	def __repr__(self):
		return "<Page %s %s>" % (self.name, self.data)

pages = {}
index = {}
predicates = []

def indexDataset():
	#print ("Indexing dataset...")
	global index, predicates
	index = {}

	for page in pages.values():
		for predicate, values in page.allitems():
			i = index.setdefault(predicate, MultiDict())

			for value in values:
				i[value] = page

	predicates = index.keys()

def loadDataset(name, path="."):
	#print ("Loading dataset...")
	global pages, index, predicates
	pages.clear()
	index.clear()
	predicates[:] = []
	pages = pd.read_pickle('em.pickle')
	#f = open("em.pickle", "rb")
	#pages = cPickle.load(f)
	#f.close()
	indexDataset()
	return pages

def getAllPredicates():
	return index.keys()

def getPredicateValues(predicate):
	return index[predicate].keys()

def getAllPages():
	return pages.values()

def getAllPageNames():
	return pages.keys()

def isPage(page):
	return isinstance(page, Page) or page in pages


def createPage(page):
	if isinstance(page, Page):
		page = page.name

	if not page in pages:
		pages[page] = Page(page)

	return pages[page]

getPage = createPage

def getPagesByRegexp(regexp):
	result = []

	exclude = re.compile('#[0-9]+$')
	stmt = re.compile(regexp)

	for key in pages.iterkeys():
		if stmt.match(key):
			if not exclude.search(key):
				result.append(getPage(key))

	return result

def isPageInCategory(page, category):
	if not isinstance(page, Page):
		page = pages[page]

	return "Category:" + category in page.getall("Category")

def pagesInCategory(category):
	return pagesWherePredicateIs("Category", "Category:" + category)

def getAllInCategory(page, predicate, category):
	result = []

	for page in page.getall(predicate):
		if isPage(page) and isPageInCategory(page, category):
			result.append(page)

	return result

def filterValidPages(pages):
	return [page for page in pages if isPage(page)]

def pagesWithPredicate(predicate):
	result = []

	for value, pages in index.get(predicate, MultiDict()).allitems():
		for page in pages:
			result.append([page, value])

	return result

def pagesWherePredicateIs(predicate, value):
	if isinstance(value, Page):
		value = value.name

	return index.get(predicate, MultiDict()).getall(value)


def pagesInCategoryWherePredicateIs(category, predicate, value):
	if isinstance(value, Page):
		value = value.name

	result = []

	for page in pagesWherePredicateIs(predicate, value):
		if isPageInCategory(page, category):
			result.append(page)

	return result

def pagesWhereInternalObjectPredicateIs(internalPredicate, predicate, value):
	if isinstance(value, Page):
		value = value.name

	result = []

	for page in pagesWherePredicateIs(predicate, value):
		result += pagesWherePredicateIs(internalPredicate, page.name)

	return result

def pagesInCategoryWhereInternalObjectPredicateIs(category, internalPredicate, predicate, value):
	if isinstance(value, Page):
		value = value.name

	result = []

	for page in pagesWhereInternalObjectPredicateIs(internalPredicate, predicate, value):
		if isPageInCategory(page, category):
			result.append(page)

	return result

def pageNamesFromList(pages):
	result = []

	for page in pages:
		if isinstance(page, Page):
			result.append(page.name)
		else:
			result.append(page)

	return result

def pagesInPredicateFromList(pages, predicate):
	result = []

	for page in pages:
		result.extend(getPage(page).getall(predicate))

	return result

def pagesInInternalObjectPredicateFromList(pages, internalPredicate, predicate):
	result = []

	for page in pages:
		for internalObject in pagesWherePredicateIs(internalPredicate, page):
			result.extend(getPage(internalObject).getall(predicate))

	return result
