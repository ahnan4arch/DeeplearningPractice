function y = SoftmaxLayer(x)
%% ���ܣ�softmaxת����
% ���룺x 10*numsSamples��С����
% �����y 10*numsSamples���ʾ���ÿ��Ϊһ����������
%
  ex = exp(x);
  y  = ex ./ sum(ex,1);
end