function [out_features,mask] = DropoutLayer(in_features, ratio)
% ���ܣ���ratio�ı���������Ԫ
% ���룺in_features,��������
%       ratio ����������[0,1]֮��
% �����out_features���������,��С��in_featuresһ��
%       mask��������룬��С��in_featuresһ��
% �ο���https://zhuanlan.zhihu.com/p/38200980
%      https://blog.csdn.net/oBrightLamp/article/details/84105097
%
% author:cuixingxing 2020.1.27
% email:cuixingxing150@gmail.com
%

all_nums = numel(in_features);
drop_nums = round(all_nums*ratio);
idxs = randperm(all_nums,drop_nums);
mask = ones(size(in_features));
mask(idxs) = 0;

out_features = in_features.*mask./(1-ratio);
end
