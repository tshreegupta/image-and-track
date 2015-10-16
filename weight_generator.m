%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Part of Dynamic shape space based radio tomography tracking code.
%% Author:Tanushree Gupta(12755)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% This function generates weight matrix for the given specifications of the field and nodes.
function [W]=weight_generator(n,m,K,field_length,field_width,allxx,allyy)

%% W : weight matrix.
%% K : no. of nodes

N=n*m;         %total no. of voxels
M=K*(K-1)/2;   %no.of links where K is no. of nodes
%%%%%%%%%%%%%%%%%%%%%%%%%
%% if K=20 then below follows, otherwise change accordingly. Use field_length and field_width to update.

nodeID=(field_length/5).*[0.5,2.5
        1.5,2.5
        2.5,2.5
        2.5,1.5
        2.5,0.5
        2.5,-0.5
        2.5,-1.5
        2.5,-2.5
        1.5,-2.5
        0.5,-2.5
        -0.5,-2.5
        -1.5,-2.5
        -2.5,-2.5
        -2.5,-1.5
        -2.5,-0.5
        -2.5,0.5
        -2.5,1.5
        -2.5,2.5
        -1.5,2.5
        -0.5,2.5];

linkID=zeros(M,2);
l=1;
j=K-1;
for i=1:1:K
    if(j>0)
        for k=1:1:j
            if(l<=M)
            linkID(l,:)=[i,i+k];
            l=l+1;
            end
        end
   j=j-1;
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

W=zeros(M,N);
%%noise=zeros(M,1); %for the measurement noise.
phi=6;   %variance weighting scale(dB)
lambda=0.05; %width parameter of weighting ellipse(ft)
for i=1:1:M
    for j=1:1:N
%         voxel_x=floor((j-1)/m)+0.5;
%         voxel_y=mod(j-1,n)+0.5;
       % [x_cord,y_cord]=ind2sub([n,m],j);
        voxel_x=allxx(j);
        voxel_y=allyy(j);
        node=linkID(i,:);
        if(norm(nodeID(node(1),:)-[voxel_x,voxel_y])+norm(nodeID(node(2),:)-[voxel_x,voxel_y])<norm(nodeID(node(1),:)-nodeID(node(2),:))+lambda)
           W(i,j)=phi/sqrt(norm(nodeID(node(1),:)-nodeID(node(2),:))) ;
          % W(i,j)=phi;
        else
            W(i,j)=0;
        end
       
    end
end
% circle=imread('C:\Users\tshree\Pictures\circle.jpg');
% circle=circle(:,:,1);
% x_o((n-size(circle,1))/2 +1:(n+size(circle,1))/2,(m-size(circle,2))/2 +1:(m+size(circle,2))/2)=circle;
% x=x_o(:);
% s_hat=W*x+noise;


%%tikhonov estimation
% alpha=0.6;
% I=eye(size(W,2));
% pie=((W'*W+alpha*I)^-1)*W';
% x_tik=pie*s_hat;
% imshow(reshape(x_tik,[n,m]))
end
