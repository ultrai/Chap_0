function [Output, Label] = Segment(images, layerMaps)
Output=[];
Label=[];
Output = uint8(Output);
Label=uint8(Label);
addpath(genpath('pangyuteng-caserel-bb0865d\'))

for stack = 1:size(images,3)
           I = images(:,:,stack);
           I = mat2gray(I);
           Img = I;
            Img = imresize(Img,0.5);
            I = Img;
            try
            [retinalLayers, params] = getRetinalLayers(I);
            ilm_pathX=retinalLayers(2).pathY;
            ilm_pathY=retinalLayers(2).pathX;
            

            isos_pathX=retinalLayers(1).pathY;
            isos_pathY=retinalLayers(1).pathX;
            RPE_pathX=retinalLayers(3).pathY;
            RPE_pathY=retinalLayers(3).pathX;
            Final = 4*ones(size(I,1),size(I,2)+2);

            for temp = 1:length(RPE_pathY)
                Final(1:RPE_pathY(temp),RPE_pathX(temp))=3;
            end
            %%%%%%%%%%%%%%%%% remove for prior information based
            for temp = 1:length(RPE_pathY)
                Final(1:isos_pathY(temp),isos_pathX(temp))=2;
            end
            %%%%%%%%%%%%%%%
%             img = [zeros(size(I,1),1) I zeros(size(I,1),1)];
%             mask = zeros(size(I,1),size(I,2)+2);
%             for temp = 1:length(isos_pathX)
%                 if isos_pathY(temp)+4 < size(img,1) && isos_pathX(temp)< size(img,2)
%                     img(1:isos_pathY(temp)+4,isos_pathX(temp))=img(isos_pathY(temp)+4,isos_pathX(temp));
%                 end
%             end
%             for temp = 1:length(RPE_pathY)
%                 if RPE_pathY(temp)-2 >1 && RPE_pathY(temp)<size(img,1) && RPE_pathX(temp)<size(img,2)
%                     img(RPE_pathY(temp)-2:end,RPE_pathX(temp))=img(RPE_pathY(temp)-2,RPE_pathX(temp));
%                 end
%             end
%             I = img;%imfilter(img,fspecial('gaussian',[5 20],3));
%             [adjMatrixW, adjMatrixMW, adjMAsub, adjMBsub, adjMW, adjMmW, img] = getAdjacencyMatrix(I);
%             adjMatrixW = sparse(adjMAsub,adjMBsub,adjMmW,numel(img(:)),numel(img(:)));    
%             [ ~, path ] = graphshortestpath( adjMatrixW, 1, numel(img(:)) );
%             [pathX, pathY] = ind2sub(size(img),path);
%             
%             for temp=1:length(pathX)
%                 img(1:pathX(temp),pathY(temp))=1;
%                 Final(1:pathX(temp),pathY(temp))=2;
%             end
            for temp = 1:length(ilm_pathX)
                Final(1:ilm_pathY(temp),ilm_pathX(temp))=1;
            end
            Final = Final(:,3:end-2);
            Out = imresize(Final,2,'box');
            %Out = Final;
            I = images(:,:,50);
           
           L = squeeze(layerMaps(stack,:,:));
           L(isnan(L)) = 0 ;
           if sum(L(:)) > 0
               
                label = Index_label(I,L);
                label = label(:);
                Out = Out(:);
                Out(label==0)=0;
                label = reshape(label,size(I));
                Out = reshape(Out,size(I));
                Output = cat(3,Output,uint8(Out));
                Label = cat(3,Label,uint8(label));
 
           end
            catch
            end
end