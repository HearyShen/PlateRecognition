function I_out = preProcRawImg( Img_raw )

% 1、原始图像预处理 【技术难点】
% I_Proced = preProcRawImg(I_raw)
% 负责人：吴晓灿
% 
% 说明：
% 函数	preProcRawImg
% 输入	原图
% 输出	能够区分车牌和背景的二值图
% 
% 原理
% 首先将原图像转化为灰度图，然后选定合适的阈值，将灰度图转化为二值图。
% 用roberts算子进行边缘检测，对边缘图像进行形态学腐蚀，
% 之后进行合理地形态学闭合，
% 最后将图像中的小对象移除，得到目标车牌所处的位置二值图。


%%%%%%%%%%%%%% 原始图像预处理 %%%%%%%%%%%%%%%%
%1)原图转换灰度图
I1_rgb2gray = rgb2gray(Img_raw);

%2)灰度图转换二值图 
%===========改进=============
T=graythresh(I1_rgb2gray);
I2_binary=im2bw(I1_rgb2gray,T);

%3)边缘检测：sobel
I3_edge = edge(I2_binary,'sobel',0.15);

%4) 腐蚀图像: 形态学腐蚀
se = [1;1];
I4_erosion = imerode(I3_edge,se);

%5)平滑图像轮廓：形态学闭合
se = strel('rectangle',[24,24]);    % 形态学结构元素
%=================参数需调节！！！！！！！！！============================
%车牌处矩形面积较小时，[]内数值调大
I5_smooth = imclose(I4_erosion,se);


% 附：经验设计，上下左右边界绝大多数情况下均为杂讯（沈家赟）
I_cutmargin = I5_smooth;
[m,n,~] = size(I_cutmargin);
vertical_margin = m/10      % 清除垂直方向边界，即上下边界
horizontal_margin = n/10    % 清除水平方向边界，即左右边界（注意：n/10较为激进）
for i = 1:m
    for j = 1:n
        if (i<vertical_margin || i>m-vertical_margin || j<horizontal_margin || j>n-horizontal_margin)
            I_cutmargin(i,j) = 0;
        end
    end
end
I5_smooth = I_cutmargin;

%6)从对象中移除小对象
imLabel = bwlabel(I5_smooth);                %对各连通域进行标记
stats = regionprops(imLabel,'Area');        %求各连通域的大小
area = cat(1,stats.Area);                   %建立索引
index = find(area == max(area));            %求最大连通域的索引
I6_filter = ismember(imLabel,index);          %获取最大连通域图像

I_out = I6_filter;
end