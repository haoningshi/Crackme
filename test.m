clear;
clc;
a=100; % the number of readers or tags
b=a/5; %the detection radius
Redun_TSA=TSA(a,a,b,9,2.2) %TSA (Reader,Tag,r,n,¦Ó)
Redun_TCBA=TCBA(a,a,b)%TCBA (Reader,Tag,r)
Redun_RRE=RRE(a,a,b) %RRE (Reader,Tag,r)