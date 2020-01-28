function Z = ConvLayer(imgs, W)
% ���ܣ���ͼ��imgs���о������,WΪ�����
% ���룺imgs �������ͼ����������洢˳��Ϊ img_height*img_width*img_channel*batchSize,
%            ��ά���飬float,[0,1]��Χ;
%      W Ϊ�����,��СΪ kernel_height*hernel_width*kernel_channel*out_filters,
%         ��ά���飬float����,kernel_channel������img_channel��Ȳſ��Ծ��!
% �����
%      ZΪ����������ͼ��ά�ȴ�СΪ(img_height-kernel_height+1)*(img_width-hernl_width+1)*out_filters*batchSize
%        ��ά���飬float����;
% ע�⣺��Ϊͼ�����������߽�����䣬֧�ֶ�ά�������
%
%  author:cuixingxing 2020.1.25
% email:cuixingxing150@gmail.com
%

[img_height, img_width, img_channel,batchSize] = size(imgs);
[kernel_height, hernl_width, kernel_channel, out_filters] = size(W);
assert(kernel_channel==img_channel);

Z = zeros(img_height-kernel_height+1,img_width-hernl_width+1,out_filters,batchSize);
for i = 1:batchSize
    for j = 1:out_filters
        W = rot90(W,2);% ��convn�����������Ҫ�Ѿ������ת180��,ֻת��һά���ڶ�ά��
        Z(:,:,j,i) = convn(imgs(:,:,:,i),W(:,:,:,j),'valid');
    end
end
end
