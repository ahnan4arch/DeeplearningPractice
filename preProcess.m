function out = preProcess(in)
% ���ܣ�Ԥ��������ͼ��
% ���룺in ΪH*W*numImgs ��С��uint8����ͼ��
% �����out ΪH*W*C*numImgs��С��float����[0,1]��Χͼ��,mnist����ͼ������C=1
%
[H,W,numImgs] = size(in);
out = im2single(in);
out = reshape(out,[H,W,1,numImgs]);
end