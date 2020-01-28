function out = PoolLayer(in)
% ���ܣ�2*2 ƽ���ػ���,stride = 2,pad = 0
% ���룺in ������ in_height*in_width*in_channel*batchSize,
%            ��ά���飬float;
% �����out ������ out_height/2*out_width/2*out_channel*batchSize,
%            ��ά���飬float;
%
% ע�⣺out_channel == in_channel
%
% author:cuixingxing 2020.1.26
% email:cuixingxing150@gmail.com
%
[in_height,in_width,in_channel,batchSize] = size(in);
temp = zeros(in_height-2+1,in_width-2+1,in_channel,batchSize);
W = ones(2,2,in_channel)/4;
for i = 1:batchSize
    for j = 1:in_channel
       temp(:,:,j,i) = convn(in(:,:,j,i),W(:,:,j),'valid');
    end
end
out = temp(1:2:end,1:2:end,:,:);
end
