function [ point_view_matrix ,point_correspondance ] = chaining(log_)
if(nargin<1)
    log_=false;
end
number_image = 49;
max_number_points= 1000;
point_view_matrix=zeros(number_image,number_image*max_number_points);
point_view_matrix_index=1;
point_correspondance=ones(number_image,max_number_points,3)*-1;
%point_correspondance(i,j,:) = [x;y;index] where i:frame number, j:index of
%the matche point, (x,y) match point coordinate, index: index of this point
%in the point_view_matrix or -1
window_size = 1;

%memorize the descriptors
%note that the last value is the same for both matrix and is going to
%change over the frames
keypoints_frame=zeros(number_image,4,1); %f value from vl_sift
descriptor_frame=zeros(number_image,128,1); %d value from vl_sift
index_frame = zeros(number_image);%returns the true size of the last column of the above matrices for each frame
%memorize all descriptors:
for d_index=1:number_image
    img1 = myGetImage(d_index);
    [fa,da] = vl_sift(single(img1));
    %fa is of size 4 * x
    %da is of size 128 * x
    x_size = size(fa,2);
    delta_size = x_size-size(keypoints_frame,3);
    if(delta_size>0)
        keypoints_frame=extend3dMatrix(3,delta_size,keypoints_frame,0);
        descriptor_frame=extend3dMatrix(3,delta_size,descriptor_frame,0);
    end
    index_frame(d_index)=x_size;
    %pad descriptor and keypoint with 0 so that they fit in the matrix
    pad_fa=extend3dMatrix(2,-delta_size,fa,0);
    pad_da=extend3dMatrix(2,-delta_size,da,0);
    keypoints_frame(d_index,:,:)=pad_fa;
    descriptor_frame(d_index,:,:)=pad_da;
end
%j varies from 1+window_size to number_image and then to window_size
%i varies from 1 to number_image and then to window_size-1
for ind1=1:number_image
    for ind2= (ind1-window_size) : (ind1-1)
        %i and j corresponds to the image we match
        j=ind1;
        i=ind2;
        if(ind2<1)
            i=number_image+ind2;
        end
                
        %in case we want to plot in ransaac: 
        image1 = myGetImage(i);
        image2 = myGetImage(j);
        
        index_frame_i=index_frame(i);
        fa=keypoints_frame(i,:,1:index_frame_i);
        da=descriptor_frame(i,:,1:index_frame_i);

        index_frame_j=index_frame(j);
        fb=keypoints_frame(j,:,1:index_frame_j);
        db=descriptor_frame(j,:,1:index_frame_j);
        
        %flatten 3d array to 2d array 
        fa=reshape(fa,size(fa,2),size(fa,3));
        da=reshape(da,size(da,2),size(da,3));
        fb=reshape(fb,size(fb,2),size(fb,3));
        db=reshape(db,size(db,2),size(db,3));
        
        %Run Ransac, output matching pair coordinates
        [ xa_all, xb_all, ya_all, yb_all ] = RANSAC2( image1, image2, -1,false,fa,da,fb,db);

        %Calculate Fundamental matrix for un-normalized data
        [ F,inliers_index] = Fundamental( xa_all, xb_all, ya_all, yb_all,true );
        

        disp(strcat(num2str(i), '=>', num2str(j),'_',num2str(length(inliers_index))));
        %loop over all new matches
        for k=1:length(inliers_index)
            xa = xa_all(k);
            ya = ya_all(k);
            xb = xb_all(k);
            yb = yb_all(k);
            [frame_i_index,new_ind_i]=findIndexCorrespondance(point_correspondance,i, xa,ya);
            [frame_j_index,new_ind_j]=findIndexCorrespondance(point_correspondance,j, xb,yb);
            %test if the point was already added in frame i or j
            if(frame_i_index~=-1 && (frame_j_index~=-1))%check if indexes are the same (they should be!!!)
                if(frame_i_index ~= frame_j_index)
                    if(log_)
                        if(frame_i_index<frame_j_index)
                            disp(strcat('Case1.1: merge column',num2str(frame_j_index),'to',num2str(frame_i_index)));
                        else
                            disp(strcat('Case1.1: merge column',num2str(frame_i_index),'to',num2str(frame_j_index)));
                        end
                    end
                    %find the smallest and biggest index index
                    good_index = min(frame_i_index,frame_j_index);
                    bad_index = max(frame_i_index,frame_j_index);
                    %update point_view_matrix: remove the duplicated column
                    point_view_matrix=mergeColumn(point_view_matrix,good_index,bad_index,0);
                    %update point_correspondance
                    %change all bad_index to good index
                    point_correspondance(point_correspondance(:,:,3)==bad_index)=good_index;
                    %change all index >bad_index to index -1
                    point_correspondance(point_correspondance(:,:,3)>bad_index)=...
                        point_correspondance(point_correspondance(:,:,3)>bad_index)-1;
                    %update point_view_matrix_index
                    point_view_matrix_index=point_view_matrix_index-1;
                end
                
            elseif(frame_i_index~=-1 || frame_j_index~=-1)%update matrices for i or j
                if (frame_i_index==-1)
                    %disp('Case2.1');
                    frame_to_update= i;
                    new_point_index = new_ind_i;
                    new_x = xa;
                    new_y = ya;
                    new_index=frame_j_index;
                    if(log_)
                        disp(strcat('Case 2.1 add match frame_',num2str(i),' to index_',num2str(frame_j_index)));
                    end
                else
                    %disp('Case2.2');
                    frame_to_update= j;
                    new_point_index = new_ind_j;
                    new_x = xb;
                    new_y = yb;
                    new_index=frame_i_index;
                    if(log_)
                        disp(strcat('Case 2.2 add match frame_',num2str(j),' to index_',num2str(frame_i_index)));
                    end
                end
                %update point_correspondance
                point_correspondance(frame_to_update,new_point_index,1)=new_x;
                point_correspondance(frame_to_update,new_point_index,2)=new_y;
                point_correspondance(frame_to_update,new_point_index,3)=new_index;
                %update point_view_matrix
                point_view_matrix(frame_to_update,new_index)=1;
                %update point_view_matrix_index
                %do nothing
            else % find a new indexes and update matrices for i and j
                new_index=point_view_matrix_index;
                %update point_correspondance
                point_correspondance(i,new_ind_i,1)=xa;
                point_correspondance(i,new_ind_i,2)=ya;
                point_correspondance(i,new_ind_i,3)=new_index;
                
                point_correspondance(j,new_ind_j,1)=xb;
                point_correspondance(j,new_ind_j,2)=yb;
                point_correspondance(j,new_ind_j,3)=new_index;
                %update point_view_matrix
                point_view_matrix(i,new_index)=1;
                
                point_view_matrix(j,new_index)=1;
                %update point_view_matrix_index
                point_view_matrix_index=point_view_matrix_index+1;
                if(log_)
                    disp(strcat('Case3: match to index ',num2str(new_index),'_',num2str(xa),'_',num2str(ya)...
                        ,'=>',num2str(xb),'_',num2str(yb)));
                end
            end
        end
    end
end
%removed unused entries
size(point_view_matrix)
if(point_view_matrix_index>1)
    point_view_matrix(:,point_view_matrix_index:end)=[];
    point_correspondance(point_view_matrix_index:end,:)=[];
end
size(point_view_matrix)
%display result
figure();
nb_pt = min(size(point_view_matrix,2),1000);
imshow(point_view_matrix(:,1:nb_pt));

    function M = mergeColumn(Mat,i,j,val)
        %assume that Mat is a matrix of 0 and 1
        M=Mat;
        %merge the two columns
        M(:,i)=min(M(:,i)+M(:,j),1);
        %remove column j and shift the matrix to the left
        M=[M(:,1:j-1),M(:,j+1:end),ones(size(M,1),1)*val];
    end

%find the index in point_correspondance if the point (x,y) was in for frame frame,
%also return the index that can be used to add a point or -1
%return -1 otherwise
    function [ind,new_ind] = findIndexCorrespondance(point_correspondance,frame, x,y)
        ind=-1;
        new_ind=-1;
        %disp(strcat('try find ',num2str(x),'_',num2str(y)));
        %disp(point_correspondance(frame,1:30,:));
        for m=1:size(point_correspondance,2)
            val = point_correspondance(frame,m,:);
            %[x,y,val(1),val(2)]
            if(val(1)==-1 && (val(2) == -1) && (new_ind==-1))
                new_ind=m;
                break;
            end
            %dist = power(x-val(1),2) + power(y-val(2),2);
            if(x==val(1) && (y==val(2)))
                ind=val(3);
            end
        end
    end
    function M = extend3dMatrix(dim_index,number_new_extension,M0,extension_value)
        M=M0;
        if(number_new_extension>0)
            if(dim_index==1)
                B=ones(number_new_extension,size(M0,2),size(M0,3))*extension_value;
            elseif(dim_index==2)
                B=ones(size(M0,1),number_new_extension,size(M0,3))*extension_value;
            else
                B=ones(size(M0,1),size(M0,2),number_new_extension)*extension_value;
            end
            M=cat(dim_index,M0,B);
        end
    end
    function img = myGetImage(index)
        pad ='';
        if(index<10)
            pad='0';
        end
        img = strcat('House/frame000000',pad,num2str(index),'.png');
        img=imread(img);
        [img,~]=RemoveBackground( img, img );
    end
end

