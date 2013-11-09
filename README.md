svn_helper
==========

command tool to help use svn more convenient with the svn state infomation.

How to Install:
===============
sh install.sh

How to Use
==========
You can use svh just like svn command but use svn st info as the input source instead of certain path.

Use svn st and you can see these infomation on terminal:

M     	A  
M       B  
?       C  
?       D  
M       E  
?       F  
M       G  

Example 1,revert B:
svh revert -p M1 or svh revert -p 1

Example 2,revert G:
svh revert -p M-1 or svh revert -p -1

Example 3,revert A and B:
svh revert -p M0:1
or
svh revert -p M0,M1

Example 4,revert All M state file after B:
svh revert -p M1:

Example 5,revert All M state file before E:
svh revert -p M:-2

And More!
=========
svh can be used along with pipe when you specified --pipe

Example:
svn st | grep user | svh --pipe add -p ?2
