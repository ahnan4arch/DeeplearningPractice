function [Imgs,Labels] = processMNISTdata(imageFileName,labelFileName)
% PROCESSMNISTDATA���ܣ������ٷ��ṩ�Ķ���������ʶ��MNIST���ݼ�
%  ���룺imageFileName ��ѹ���ͼ���ļ���
%       labelFileName ��ѹ��ı�ǩ�ļ���
% �����Imgs ΪnumRows*numCols*1*numImages ��С��float����ͼ�����ݣ�[0,1]��Χ
%       LabelsΪnumImages*1��С��double��ǩ����
% �ο���https://ww2.mathworks.cn/help/stats/visualize-high-dimensional-data-using-t-sne.html
%
%  author:cuixingxing 2020.1.25
% email:cuixingxing150@gmail.com
%
[fileID,errmsg] = fopen(imageFileName,'r','b');
if fileID < 0
    error(errmsg);
end
%%
% First read the magic number. This number is 2051 for image data, and
% 2049 for label data
magicNum = fread(fileID,1,'int32',0,'b');
assert(magicNum == 2051);

%%
% Then read the number of images, number of rows, and number of columns
numImages = fread(fileID,1,'int32',0,'b');
numRows = fread(fileID,1,'int32',0,'b');
numCols = fread(fileID,1,'int32',0,'b');

%%
% Read the image data
Imgs = fread(fileID,inf,'unsigned char=>uint8');
%%
% Reshape the data to array X
Imgs = reshape(Imgs,numCols,numRows,numImages);
Imgs = permute(Imgs,[2 1 3]);
Imgs = preProcess(Imgs); % 28*28*1*numImgs�� float���ͣ�[0,1]��Χ

%%
% Close the file
fclose(fileID);
%%
% Similarly, read the label data.
[fileID,errmsg] = fopen(labelFileName,'r','b');
if fileID < 0
    error(errmsg);
end
magicNum = fread(fileID,1,'int32',0,'b');
assert(magicNum == 2049);
numItems = fread(fileID,1,'int32',0,'b');

Labels = fread(fileID,inf,'unsigned char=>double');
Labels = reshape(Labels,numItems,1);% numItem*1 
fclose(fileID);
