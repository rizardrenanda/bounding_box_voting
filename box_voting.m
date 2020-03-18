function [boxes_final] = box_voting(boxes,boxes_temp,thresh)
% Output = boxes_final 
% Input  = boxes [x1, y1, x2, y2] left top right bottom 
%          boxes_temp : set of region proposals 
%          thresh : IoU threshold 
B_size = size(boxes,1);
boxes_final = boxes;
for i = 1 : B_size
    x1 = boxes(i,1);
    y1 = boxes(i,2);
    x2 = boxes(i,3);
    y2 = boxes(i,4);
    x1_temp = boxes_temp(:,1);
    y1_temp = boxes_temp(:,2);
    x2_temp = boxes_temp(:,3);
    y2_temp = boxes_temp(:,4);
    
    % Compute IoU
    area = (x2-x1+1) .* (y2-y1+1);
    area_temp = (x2_temp-x1_temp+1) .* (y2_temp-y1_temp+1);
    xx1 = max(x1, x1_temp);
    yy1 = max(y1, y1_temp);
    xx2 = min(x2, x2_temp);
    yy2 = min(y2, y2_temp);
    w = max(0.0, xx2-xx1+1);
    h = max(0.0, yy2-yy1+1);    
    inter = w.*h;
    o = inter ./ (area+ area_temp- inter);
    
    % only use proposals with IoU > thresh for voting
    temp1 = double(o >= thresh);    
    nomx1 = sum(boxes_temp(:,1).*temp1.*boxes_temp(:,5))+x1*boxes(i,5);
    nomy1 = sum(boxes_temp(:,2).*temp1.*boxes_temp(:,5))+y1*boxes(i,5);
    nomx2 = sum(boxes_temp(:,3).*temp1.*boxes_temp(:,5))+x2*boxes(i,5);
    nomy2 = sum(boxes_temp(:,4).*temp1.*boxes_temp(:,5))+y2*boxes(i,5);
    
    denom = sum(temp1.*boxes_temp(:,5))+ boxes(i,5);
    if size(temp1,1)>5
        boxes_final(i,1) = nomx1/denom;
        boxes_final(i,2) = nomy1/denom;
        boxes_final(i,3) = nomx2/denom;
        boxes_final(i,4) = nomy2/denom;
    end
end