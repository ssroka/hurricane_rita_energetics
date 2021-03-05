clear;close all;clc



T = sym('T',[3,3],'real')
ddx = sym('ddx',[1,3],'real')
u = sym('u',[3,1],'real')

divT = ddx*T'

uT = u'*divT'















