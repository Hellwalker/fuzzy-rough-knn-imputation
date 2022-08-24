% round to a certain accuracy level
% mostly, round to 0.5
% for median ordinal data use
% Jianglin

function[result] = roundTo(x, acc)

result = round(x/acc)*acc;

