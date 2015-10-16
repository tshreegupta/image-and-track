%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Main file for Dynamic shape space based radio tomography tracking.
%% Author:Tanushree Gupta(12755)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Defining the setup model

field_length=16;  %(-8 to 8)in meters
field_width=16;

n=21;  %length of image (interms of pixel)
m=21;  %width of image (interms of pixel)
load 'allxx.mat'        %coordinate of voxel centers
load 'allyy.mat'

resolution= n/field_length; %resolution per pixel

nodes=20;    %no. of nodes (multiple of 4, and should be atleast sqrt(2*0.75*n*m) to get 75% coverage of the image.)
W= weight_generator(n,m,nodes,field_length,field_width,allxx,allyy);
N=n*m;
M=nodes*(nodes-1)/2;    %no. of links
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Generation of raw data 
img=imread('target.jpg');
img=im2double(img);
img=img(:,:,1);
x_o=imresize(img,[n m]);     % image discretized in 21*21 pixel grid.

x=x_o(:);
noise=zeros(M,1);
z=W*x+noise;        %RSS measurements 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Initial guess of the spline
dp=20;    %no. of control points -1
rp=6;
tt=0:2*pi/dp:2*pi;
xc= rp*cos(tt);    %control points
yc= rp*sin(tt);

[sumxx,sumyy] = closedBsplineCurve(xc,yc);
figure
plot(sumxx,sumyy,'x')
hold on
plot(allxx,allyy,'*g');
