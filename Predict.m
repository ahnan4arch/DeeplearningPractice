function predict_L = Predict(W1,W2,W3,W4,X_Test)
% ���ܣ�������Լ�׼ȷ��
% ���룺W1,W2,W3,W4Ϊ����Ȩ�ؾ���
%      X_Test �������ݣ��洢˳��Ϊ img_height*img_width*img_channel*numImgs,
%            ��ά���飬float����,[0,1]��Χ;
% �����predict_L Ԥ���ǩ��onehot��ǩ��ÿ��Ϊһ����ǩ
%
%  author:cuixingxing 2020.1.27
% email:cuixingxing150@gmail.com
%

%% Ԥ����
X = X_Test; % 28*28*1*numImgs�� float���ͣ�[0,1]��Χ
[~,~,~,numImgs] = size(X);

%% forward
%% ��һ�㣺CNN���+ReLULayer+�ػ���
Z1= ConvLayer(X,W1);
Y1=ReLULayer(Z1);
A1 =PoolLayer(Y1);

%% �ڶ��㣺ȫ���Ӳ� ��ReLULayer+ dropout
y1=reshape(A1,[],numImgs);
Z2=W2*y1;
Y2=ReLULayer(Z2);
% [A2,~] = DropoutLayer(Y2, 0.01);

%% �����㣺ȫ���Ӳ� �� ReLULayer+ dropout
Z3=W3*Y2;
Y3=ReLULayer(Z3);
% [A3,~] =  DropoutLayer(Y3, 0.01);

%% ���Ĳ㣺ȫ���Ӳ�+softmax
Z4 = W4*Y3;
% ����ѵ����׼ȷ��
P = SoftmaxLayer(Z4); % 10*batchSize ��С
[~,ind] = max(P);
nClasses = 10;
order = 0:9;
predict_L = onehot(ind-1,nClasses,order);

end
