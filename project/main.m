function [] = main(~)

% 0、主函数例程（开发调试用）
% function [] = main(~)
% 负责人：沈家赟
% 
% 说明：
% 输入	原图
% 输出	识别过程信息，识别结果
% 
% 功能
%  此主函数Matlab脚本实现系统整体调用，作为开发调试使用，
%  包含整体系统架构、顶层注释并在结尾提供逐模块的过程显示

clear
close all
clc

% 1) 读取原图
[filename, filepath] = uigetfile('*.jpg','选择图片');
url_Img = strcat(filepath, filename);
I_raw = imread(url_Img);
%%
%%%%%%%%%%%%%% 原始图像预处理 %%%%%%%%%%%%%%%%

I_Proced = preProcRawImg(I_raw);

%%
%%%%%%%%%%%%%% 定位裁剪车牌图像 %%%%%%%%%%%%%%%%

I_plateRaw = getPlateImg(I_Proced, I_raw);

%%
%%%%%%%%%%%%%% 车牌图像预处理 %%%%%%%%%%%%%%%%

I_plateProced = preProcPlateImg(I_plateRaw);

%%
%%%%%%%%%%%%%% 车牌文字裁切 %%%%%%%%%%%%%%%%
% 寻找连续有文字的块，若长度大于某阈值，则认为该块有两个字符组成，需要分割

[word1, word2, word3, word4, word5, word6, word7] = partitionWords( I_plateProced );

%%
%%%%%%%%%%%%%% 文字识别 %%%%%%%%%%%%%%%%

Code = recognizeWords( word1, word2, word3, word4, word5, word6, word7 );

%%
figure(1);
subplot(6,7,(1:7)), imshow(I_raw),title('原图');
subplot(6,7,(8:14)), imshow(I_Proced),title('原图预处理');
subplot(6,7,(15:21)), imshow(I_plateRaw),title('车牌提取');
subplot(6,7,(22:28)), imshow(I_plateProced),title('车牌预处理');
subplot(6,7,29), imshow(word1);
subplot(6,7,30), imshow(word2);
subplot(6,7,31), imshow(word3);
subplot(6,7,32), imshow(word4);
subplot(6,7,33), imshow(word5);
subplot(6,7,34), imshow(word6);
subplot(6,7,35), imshow(word7);
subplot(6,7,(36:42)), imshow([word1, word2, word3, word4, word5, word6, word7]),title (['处理及识别结果:  ', Code],'Color','red');