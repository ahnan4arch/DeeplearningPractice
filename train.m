
%% 1������MNISTDataԤ����
imageFileNameTrain = 'G:\MNIST\train-images.idx3-ubyte';
labelFileNameTtrain = 'G:\MNIST\train-labels.idx1-ubyte';
nClasses = 10;
order = 0:9;

[X_Train,Label_Train] = processMNISTdata(imageFileNameTrain,labelFileNameTtrain);
Label_Train_h = onehot(Label_Train,nClasses,order);

montage(X_Train(:,:,:,1:9))
title(['Ground Truth:',num2str(Label_Train(1:9)')]);

%% 2���������趨
alpha=0.01;
beta =0.01;
ratio = 0.01;
epoch = 2;
batchSize = 10;

W1=1e-2*randn(9,9,1,20);% ��һ��ΪCNN�����9*9��С������ͨ��Ϊ1�����ͨ���趨Ϊ20
W2=(2*rand(95,2000)-1)/20;% �ڶ���ΪBP����㣬�趨��Ԫ����Ϊ95��2000Ϊ��һ�������ںϼ���ó���
W3=(2*rand(45,95)-1)/10; % ������ΪBP����㣬�趨��Ԫ����Ϊ45
W4=(2*rand(10,45)-1)/5; % ���Ĳ�ΪBP����㣬�趨��Ԫ����Ϊ10����Ϊֱ����10�����ֶ�Ӧ
mmt1 = zeros(size(W1));% ��������W1�ݶȣ��ȶ�ѵ��
mmt2 = zeros(size(W2));
mmt3 = zeros(size(W3));
mmt4 = zeros(size(W4));

%% 3�����򴫲��㷨+�ݶ��½��㷨���������²���Ѱ��
numCorrect = 0;% �ۼ�Ԥ����ȷ����������
numAll = 0;% �ۼ������������������
accuracy = 0;
for i = 1:epoch
    [~, ~, ~,numsImgs] = size(X_Train);
    for    idx= 1:batchSize:numsImgs
        %% batch data
        batchInds = idx:min(idx+batchSize-1,numsImgs);
        batchX = X_Train(:,:,:,batchInds);% 28*28*batchSize
        batchY = Label_Train_h(:,batchInds);% 10*batchSize
        [~,~,~,bs] = size(batchX);
        % show images and true labels
        % montage(batchX);
        % title(['Ground Truth:',num2str(Label_Train(batchInds)')]);
        
        %% ��һ�㣺CNN���+relu+�ػ���
        Z1= ConvLayer(batchX,W1);
        Y1=ReLULayer(Z1);
        A1 =PoolLayer(Y1);
        
        %% �ڶ��㣺BPȫ���Ӳ� ��relu+ DropoutLayer
        y1=reshape(A1,[],batchSize);
        Z2=W2*y1;
        Y2=ReLULayer(Z2);
        [A2,mask2] = DropoutLayer(Y2, ratio);
        
        %% �����㣺BPȫ���Ӳ� �� relu+ DropoutLayer
        Z3=W3*A2;
        Y3=ReLULayer(Z3);
        [A3,mask3] =  DropoutLayer(Y3, ratio);
        
        %% ���Ĳ㣺BPȫ���Ӳ�+softmax
        Z4 = W4*A3;
        P = SoftmaxLayer(Z4); % 10*batchSize ��С
        % ����ѵ������ǰ׼ȷ��
        [~,ind] = max(P);
        predict_L = onehot(ind-1,nClasses,order);
        for idx_img = 1:bs
            isEqual = predict_L(:,idx_img)==batchY(:,idx_img);
            numCorrect = numCorrect+all(isEqual);
        end
        numAll = numAll+bs;
        accuracy = numCorrect/numAll;
        fprintf('��%d epoch����%d/%d������ѵ����׼ȷ��Ϊ��%.2f\n',i,floor(idx/batchSize),floor(numsImgs/batchSize),accuracy);
        
        %% ���������
        % ����Ĳ��������һ�����
        e4 = batchY-P;
        
        % ����������
        delta4 = e4;
        e3=W4'*delta4;
        delta3=mask3.*e3;% DropoutLayer�� https://blog.csdn.net/oBrightLamp/article/details/84105097
        delta3 = (Z3>0).*delta3;% Relu��
        % ��ڶ������
        e2=W3'*delta3;
        delta2=mask2.*e2;
        delta2=(Z2>0).*delta2;
        % ���һ�����
        e1=W2'*delta2;
        e1 = reshape(e1,size(A1));
        avg_e = e1/4; % avg pool���󵼲ο� https://blog.csdn.net/qq_21190081/article/details/72871704
        E1 = repelem(avg_e,2,2);
        delta1=(Z1>0).*E1;
        
        % ��ȡ�ݶȲ�����W1,����CNN���������򴫲�ԭ��https://www.cnblogs.com/pinard/p/6494810.html
        [~,~,~,numFilters]=size(W1);
        for idx_f =1:numFilters
            dW1 = zeros(size(W1));% 9*9*1*20
            for idx_img = 1:bs
                dW1(:,:,:,idx_img)=alpha* convn(batchX(:,:,:,idx_img),rot90(delta1(:,:,idx_f,idx_img),2),'valid');
            end
            dW1 = mean(dW1,4); % batch �ݶȷ����ֵ
            S = size(W1);S(end) = 1;
            dW1= reshape(dW1,S);% ����ά��
            mmt1(:,:,:,idx_f)= dW1 + beta*mmt1(:,:,:,idx_f);
            W1(:,:,:,idx_f)=W1(:,:,:,idx_f) + mmt1(:,:,:,idx_f); % ��������ʽ��mini-batch�ݶ��½��㷨
        end
        % ��ȡ�ݶȲ�����W2,����BP���򴫲�ԭ��
        dW2=alpha*delta2*y1';% ��Ϊ��һ����CNN��������������ȫ���ӣ���y1��A1�ı任��ʽ
        mmt2 = dW2 + beta*mmt2;
        W2   = W2 + mmt2;
        % ��ȡ�ݶȲ�����W3,����BP���򴫲�ԭ��
        dW3=alpha*delta3*A2';
        mmt3 = dW3 + beta*mmt3;
        W3   = W3 + mmt3;
        % ��ȡ�ݶȲ�����W4,����BP���򴫲�ԭ��
        dW4=alpha*delta4*A3';
        mmt4 = dW4 + beta*mmt4;
        W4   = W4 + mmt4;
        
    end
    % ÿ��epoch�����б���
    save(['model_epoch',num2str(i),'.mat'], 'W1','W2','W3','W4');  
end



