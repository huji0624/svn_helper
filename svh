#!/usr/bin/python

hp="usage():\n\tsvh cmd -p patten [--pipe] [-h]\n\tgithub page:https://github.com/huji0624/svn_helper"

import sys

def getoptof(opt):
	if opt in sys.argv:
		index = sys.argv.index(opt)
		pindex = index+1
		if pindex<len(sys.argv):
			return sys.argv[pindex]
		else:
			return None
	else:
		return None

def getOpts():
	opts=list()
	isPatten=False
	needQuote=False
	for t in sys.argv:
		if isPatten:
			isPatten=False
			continue
		if needQuote:
			t="\""+t+"\""
			needQuote=False

		if t == '--pipe':
			continue
		elif t == '-m':
			needQuote=True
		elif t == '-p':
			isPatten=True
			continue
		elif t == sys.argv[0]:
			continue
		opts.append(t)
	return opts

def parseParts(state,partspatten,temp):
	parts=partspatten.split(":")
	if len(parts)==1:
		index=int(partspatten)
		pd=dict()
		pd['index']=index
		if state:
			pd['state']=state
		temp.append(pd)
	elif len(parts)==2:
		if parts[0]=='':
			parts[0]='0'
		if parts[1]=='':
			parts[1]='-1'
		findex=int(parts[0])
		sindex=int(parts[1])
		pd=dict()
		pd['from']=findex
		pd['to']=sindex
		if state:
			pd['state']=state
		temp.append(pd)
	else:
		print "Wrong Patten:"+partspatten
		exit(1)

def parsePatten(patten):
	temp=list()
	if patten[0]=="-" or patten[0].isdigit():
		parseParts(None,patten,temp)
	elif patten[0].isdigit() == False:
		commonstate=patten[0]
		parseParts(commonstate,patten[1:],temp)
	else:
		print "Wrong Patten:"+patten
		exit(1)

	return temp

def getPath(state,index,stdicts):
	if state == None:
		return stdicts[index]['path']
	else:
		sc=0
		for sd in stdicts:
			if state == sd['state']:
				if index == sc:
					return sd['path']
				else:
					sc=sc+1
		print 'index is out of bounds'
		exit(1)
	return None

def parseSvnStString(ststr):
	stdicts=list()
	stateCount=dict()
	ststrs=ststr.splitlines()
	lineC=0
	for line in ststrs:
		tokens=line.split()
		stdict=dict()
		tstate=tokens[0].strip()
		stdict['state']=tstate
		stdict['path']=tokens[1].strip()
		stdict['index']=lineC
		stdicts.append(stdict)
		if stateCount.has_key(tstate):
			count=stateCount[tstate]+1
			stateCount[tstate]=count
		else:
			stateCount[tstate]=1
		lineC=lineC+1
	return (stdicts,stateCount)

def nToP(pds,stateCount,total):
	for pd in pds:
		if pd.has_key("index") and pd.has_key("state"):
			state=pd["state"]
			index=pd["index"]
			if index<0:
				pd["index"]=index+stateCount[state]
		elif pd.has_key("from") and pd.has_key("to") and pd.has_key("state"):
			state=pd["state"]
			fromindex=pd["from"]
			toindex=pd["to"]
			if fromindex<0:
				pd["from"]=fromindex+stateCount[state]
			if toindex<0:
				pd["to"]=toindex+stateCount[state]


if len(sys.argv)<3 or ('-h' in sys.argv):
	print hp
	exit(1)

opts=getOpts()
pattens=getoptof("-p")
if pattens == None or pattens == "":
	print "No Patten Found"
	exit(1)

pathes=list()
pds=list()

pattenslist=pattens.split(",")
for tp in pattenslist:
	if tp=="":
		continue
	else:
		pdl=parsePatten(tp)
		pds.extend(pdl)

#for debug
#print pds

ststr=None
if '--pipe' in sys.argv:
#read from input pipe
	ststr=sys.stdin.read()
else:
#read from svn st pipe
	import os
	pipe=os.popen("svn st")
	ststr=pipe.read()
	pipe.close()

stdicts,stateCount=parseSvnStString(ststr)
nToP(pds,stateCount,len(stdicts))
for pd in pds:
	if pd.has_key('state') and pd.has_key('index'):
		state=pd['state']
		index=pd['index']
		pathes.append(getPath(state,index,stdicts))
	elif pd.has_key('from') and pd.has_key('to'):
		state=pd['state']if pd.has_key('state') else None
		if pd['from']>pd['to']:
			print "Wrong index:from>to"
			exit(1)
		for i in range(pd['from'],pd['to']+1):
			pathes.append(getPath(state,i,stdicts))
	elif pd.has_key('index'):
		index=pd['index']
		pathes.append(getPath(None,index,stdicts))
	else:
		print 'No Patten Found'
		exit(1)

#for debug
#print pathes
#exit(1)

import os
svncmd="svn "
for opt in opts:
	svncmd=svncmd+opt+" "
for path in pathes:
	svncmd=svncmd+path+" "
#for debug
#print svncmd
#exit(1)
os.system(svncmd)
exit(0)
