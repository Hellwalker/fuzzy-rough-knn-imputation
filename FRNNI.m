
% the main program of FRNNI
% Fuzzy Rough set theory NN imputation
% refered from Amiri,R. and Jensen,R'work in Neurocomputing
%
% "Missing data imputation using fuzzy-rough methods" in 2016

% Jianglin

% input: data, flag(numeric1, nominal2, ordinal3)
% version: FRNNI 

function[Data] = FRNNI(Data, Flag, K)

flag = flagTrans(Flag);

ftMax = max(Data);
ftMin = min(Data);
lower_approx = zeros(K,1);
upper_approx = zeros(K,1);

% find missing col index
isNaNData = isnan(Data);
[~, cmis] = find(isNaNData);
cmis = unique(cmis);

for itemp = 1:size(cmis,1)
    % temperal mis col index
    py = cmis(itemp,1);
    tempIn = isnan(Data(:,py));
    tempMisColIndex = find(tempIn);
    
    for jtemp = 1:size(tempMisColIndex,1)  
        % each time select one mis row index
        px = tempMisColIndex(jtemp,1);
        nonNaN = logical(1-isnan(Data(px,:)));
        % search the nearest k+1 neighbors, since itself is still in Data
        
        [nInd, ~] = knnsearch2(Data(:,nonNaN), Data(px,nonNaN), flag(:,nonNaN), 'euclidean', K+1);
        % avoid all neighbors with the same distance
        if sum(nInd==px)~=0
            nInd(nInd==px) = [];
        else
            nInd(1,:)=[];
        end
        N = Data(nInd,:); 
        
        for i = 1:K
            z = N(i,:); t = N;
            t(i,:) = [];
            
            R_yt = min(R_(Data(px,nonNaN),t(:,nonNaN),ftMax(:,nonNaN),ftMin(:,nonNaN), flag(:,nonNaN)),[],2);
            R_tz = R_(t(:,py),z(:,py),ftMax(:,py),ftMin(:,py),flag(:,py));
            
            lower_approx(i,:) = min(max(1-R_yt, R_tz));
            upper_approx(i,:) = max(min(R_yt, R_tz));
            
        end
        mean_lower_upper_approx = mean([lower_approx,upper_approx],2);
        [~, maxVID] = max(mean_lower_upper_approx);
        
        if sum(mean_lower_upper_approx)>0
            Data(px,py) = (flag(:,py)==0)*mean_lower_upper_approx'*N(:,py)/sum(mean_lower_upper_approx)+(flag(:,py)==1)*N(maxVID,py);
        else
            Data(px,py) = (flag(:,py)==0)*mean(N(:,py))+(flag(:,py)==1)*N(maxVID,py);
        end
        
        if Flag(:,py)==3
            Data(px,py) = roundTo(Data(px,py),0.05);
        end
                
    end
end


% R_yt, fuzzy toleration relation
function[ryt] = R_(y,t, MAX, MIN, flag)
ryt = bsxfun(@minus, 1, bsxfun(@times, 1-flag, abs(bsxfun(@minus,y,t)./(MAX-MIN))) + bsxfun(@times, flag, y~=t));


