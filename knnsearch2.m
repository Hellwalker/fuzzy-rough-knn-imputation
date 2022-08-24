% extend the original knnsearch by matlab
% ignore includingties feature for now
% X1 -
% X2
% flag - the categorical index, nominal 1, numeric 0
% w - feature weight of X

function[idx, dist] = knnsearch2(X1, X2, flag, DistMeasureMethod, K, w)
% only cope with euclidean dis and cityblock
trainCaseNum = size(X1,1);
K = (K>=trainCaseNum)*trainCaseNum + (K<trainCaseNum)*K;

if nargin == 5
    w = ones(1,size(X2,2));
end

% % the weight of numeric features
% wNum = w(:,logical(1-flag));
% % the weight of nominal features
% wNom = w(:,logical(flag));
% 
% % customed distance
% switch distMeasure
%     case 'euclidean'
%         eucc = @(XI, XJ, F)sqrt(bsxfun(@minus, XI(:,logical(1-F)), XJ(:,logical(1-F))).^2*wNum'+...
%             bsxfun(@ne, XI(:,logical(F)), XJ(:,logical(F)))*wNom');
%     case 'cityblock'
%         eucc = @(XI, XJ, F)(abs(bsxfun(@minus, XI(:,logical(1-F)), XJ(:,logical(1-F))))*wNum'+...
%             bsxfun(@ne, XI(:,logical(F)), XJ(:,logical(F)))*wNom');
%     case 'others'
%         % continuous implementation
% end
% 
% % distance in order
% [dist, idx] = pdist2(X1, X2, @(Xi,Xj) eucc(Xi,Xj,flag), 'Smallest', K);

[dist, idx] = calcDistance(X1, X2, DistMeasureMethod, w, flag, K);
