function [ point_view_matrix ,point_correspondance ] = chaining(number_points)
number_image = 49;
max_number_points= 800;
point_view_matrix=zeros(number_image,number_image*max_number_points);
point_view_matrix_index=1;
point_correspondance=ones(number_image,max_number_points,3)*-1;
%point_correspondance(i,j,:) = [x;y;index] where i:frame number, j:index of
%the matche point, (x,y) match point coordinate, index: index of this point
%in the point_view_matrix or -1
window_size = 3;
point_threshold = 0.01; %two points are considered as being the same if there distance is less than this theshold
%j varies from 1+window_size to number_image and then to window_size
%i varies from 1 to number_image and then to window_size-1
for ind1=1+window_size:number_image+window_size
    for ind2= (ind1-window_size) : (ind1-1)
        %i and j corresponds to the image we match
        j=ind1;
        i=ind2;
        if(ind1>number_image)
            j=ind1-number_image;
        end
        if(ind2>number_image)
            i=ind2-number_image;
        end
        disp(strcat(num2str(i), '=>', num2str(j)));
        pad1='';
        pad2='';
        if(i<10)
            pad1='0';
        end
        if(j<10)
            pad2='0';
        end
        img1 = strcat('House/frame000000',pad1,num2str(i),'.png');
        img2 = strcat('House/frame000000',pad2,num2str(j),'.png');
        %Read input
        img1 = imread(img1);
        img2 = imread(img2);
        %Remove background
        [ image1, image2 ] = RemoveBackground( img1, img2 );
        %Run Ransac, output matching pair coordinates
        [ xa_all, xb_all, ya_all, yb_all ] = RANSAC2( image1, image2, number_points,false);
        %Calculate Fundamental matrix for un-normalized data
        [ F,inliers_index] = Fundamental( xa_all, xb_all, ya_all, yb_all,true );
        
        %loop over all new matches
        for k=1:length(inliers_index)
            xa = xa_all(k);
            ya = ya_all(k);
            xb = xb_all(k);
            yb = yb_all(k);
            [frame_i_index,new_ind_i]=findIndexCorrespondance(point_correspondance,point_threshold,i, xa,ya);
            [frame_j_index,new_ind_j]=findIndexCorrespondance(point_correspondance,point_threshold,i, xb,yb);
            %test if the point was already added in frame i or j
            if(frame_i_index~=-1 && (frame_j_index~=-1))%check if indexes are the same (they should be!!!)
                if(frame_i_index ~= frame_j_index)
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
                    frame_to_update= i;
                    new_point_index = new_ind_i;
                    new_x = xa;
                    new_y = ya;
                    new_index=frame_j_index;
                else
                    frame_to_update= j;
                    new_point_index = new_ind_j;
                    new_x = xb;
                    new_y = yb;
                    new_index=frame_i_index;
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
imshow(point_view_matrix);

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
    function [ind,new_ind] = findIndexCorrespondance(point_correspondance,point_threshold,frame, x,y)
        ind=-1;
        new_ind=-1;
        for l=1:size(point_correspondance,2)
            val = point_correspondance(frame,l,:);
            if(val(1)==-1 && (val(2) == -1) && (new_ind==-1))
                new_ind=l;
                break;
            end
            dist = pow2(x-val(1)) + pow2(y-val(2));
            if(dist<point_threshold)
                ind=val(3);
                break;
            end
        end
    end
end

