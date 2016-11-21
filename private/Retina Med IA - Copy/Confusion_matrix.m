function [ TP,FP,TN,FN ] = Confusion_matrix(labels_pred,label,value )
%Create consufion matrix 
%[ TP,FP,TN,FN ] = Confusion_matrix(labels_pred,label,value )
TP = sum((labels_pred==value).*(label==value));
FP = sum((labels_pred==value).*(label~=value));
TN = sum((labels_pred~=value).*(label~=value));
FN = sum((labels_pred~=value).*(label==value));

end

