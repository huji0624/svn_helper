svn_helper
==========

command tool to help use svn more convenient with the svn state infomation.

How to Install:
===============
sh install.sh

How to Use
==========
You can use sth just like svn command but use svn st info as the input source instead of certain path.

Use svn st and you can see these infomation on terminal:

M     	A  
M       B  
?       C  
?       D  
M       E  
?       F  
M       G  

Example 1,revert B:
sth revert M1 or sth revert -p 1

Example 2,revert G:
sth revert M-1 or sth revert -p -1

Example 3,revert A and B:
sth revert -p M0:1
or
sth revert -p M0,M1

Example 4,revert All M state file after B:
sth revert -p M1:

Example 5,revert All M state file before E:
sth revert -p M:-2

And More!
=========
sth can be used along with pipe when you specified --pipe

Example:
svn st | grep user | sth --pipe add -p ?2
