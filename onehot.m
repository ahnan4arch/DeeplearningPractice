function onehotMatrix = onehot(labels,nClasses,order)
% �������ȱ�����󣬸���order˳�򷵻�onehot��������ÿ��Ϊһ��one hot��ǩ
% ���룺labels ������������ǩ�����1*nums����nums*1�����������ַ�����
%      nClasses �����������
%      order ����ΪnumLabels�ı�ǩ˳��������labels��Ԫ��������order
% �����onehotMatrix
%       ���ȱ������nClasses*nums��С��ÿ�������ҽ���һ��1������Ϊ0
% example:
%  labels = [0,3,2,8];
%  nClasses = 10;
%  order = [0,1,2,3,4,5,6,7,8,9];
%  onehotMatrix = onehot(labels,nClasses,order);
%  onehotMatrix = [1  0  0  0
%                  0  0  0  0
%                  0  0  1  0
%                  0  1  0  0
%                  0  0  0  0
%                  0  0  0  0
%                  0  0  0  0
%                  0  0  0  0
%                  0  0  0  1
%                  0  0  0  0]
%
% author:cuixingxing 2020.1.27
% cuixingxing150@gmail.com
%

assert(nClasses==length(order));
assert(all(ismember(labels,order)));
labels = categorical(labels);
order = categorical(order);

E = eye(nClasses);
nums = numel(labels);
indexs = [];
for i = 1:nums
    ind = find(labels(i)==order);
    indexs = [indexs;ind];
end
onehotMatrix = E(:,indexs);
