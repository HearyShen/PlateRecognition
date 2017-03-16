function [] = main(~)

% 0�����������̣����������ã�
% function [] = main(~)
% �����ˣ�����S
% 
% ˵����
% ����	ԭͼ
% ���	ʶ�������Ϣ��ʶ����
% 
% ����
%  ��������Matlab�ű�ʵ��ϵͳ������ã���Ϊ��������ʹ�ã�
%  ��������ϵͳ�ܹ�������ע�Ͳ��ڽ�β�ṩ��ģ��Ĺ�����ʾ

clear
close all
clc

% 1) ��ȡԭͼ
[filename, filepath] = uigetfile('*.jpg','ѡ��ͼƬ');
url_Img = strcat(filepath, filename);
I_raw = imread(url_Img);
%%
%%%%%%%%%%%%%% ԭʼͼ��Ԥ���� %%%%%%%%%%%%%%%%

I_Proced = preProcRawImg(I_raw);

%%
%%%%%%%%%%%%%% ��λ�ü�����ͼ�� %%%%%%%%%%%%%%%%

I_plateRaw = getPlateImg(I_Proced, I_raw);

%%
%%%%%%%%%%%%%% ����ͼ��Ԥ���� %%%%%%%%%%%%%%%%

I_plateProced = preProcPlateImg(I_plateRaw);

%%
%%%%%%%%%%%%%% �������ֲ��� %%%%%%%%%%%%%%%%
% Ѱ�����������ֵĿ飬�����ȴ���ĳ��ֵ������Ϊ�ÿ��������ַ���ɣ���Ҫ�ָ�

[word1, word2, word3, word4, word5, word6, word7] = partitionWords( I_plateProced );

%%
%%%%%%%%%%%%%% ����ʶ�� %%%%%%%%%%%%%%%%

Code = recognizeWords( word1, word2, word3, word4, word5, word6, word7 );

%%
figure(1);
subplot(6,7,(1:7)), imshow(I_raw),title('ԭͼ');
subplot(6,7,(8:14)), imshow(I_Proced),title('ԭͼԤ����');
subplot(6,7,(15:21)), imshow(I_plateRaw),title('������ȡ');
subplot(6,7,(22:28)), imshow(I_plateProced),title('����Ԥ����');
subplot(6,7,29), imshow(word1);
subplot(6,7,30), imshow(word2);
subplot(6,7,31), imshow(word3);
subplot(6,7,32), imshow(word4);
subplot(6,7,33), imshow(word5);
subplot(6,7,34), imshow(word6);
subplot(6,7,35), imshow(word7);
subplot(6,7,(36:42)), imshow([word1, word2, word3, word4, word5, word6, word7]),title (['����ʶ����:  ', Code],'Color','red');