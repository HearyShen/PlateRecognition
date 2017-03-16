function I_out = preProcPlateImg( Img_plate )

% 3、车牌图像预处理
% I_plateProced = preProcPlateImg(I_plateRaw)
% 负责人：陆佳程
% 
% 说明：
% 输入为较为清楚的车牌周围的图像
% 输出为细化后的车牌二值图像
% 
% 原理：
% 首先对输入图像进行二值化处理，然后利用robert算子边缘检测，
% 检测出边缘后进行腐蚀然后平滑。处理后车牌部分是一个比较大的对象，
% 把小对象移除后就能确定出车牌的坐标。利用坐标从原图中将车牌截出，
% 然后就利用二值化、均值滤波、膨胀，就能得到预处理后的车牌图像。

%%%%%%%%%%%%%% 车牌图像预处理 %%%%%%%%%%%%%%%%
% [filename,filepath]=uigetfile('cuttedplate.jpg','选择裁剪出的车牌图像');
% url_plate=strcat(filepath,filename);
% a=imread(url_plate);
a = Img_plate;
b=rgb2gray(a);

g_max=double(max(max(b)));
g_min=double(min(min(b)));
T=round(g_max-(g_max-g_min)/3); % T 为二值化的阈值
[m,n]=size(b);
d=(double(b)>=T);  % d:二值图像

% 滤波
h=fspecial('average',3);
d=im2bw(round(filter2(h,d)));

% 某些图像进行操作
% 膨胀或腐蚀
% se=strel('square',3);  % 使用一个3X3的正方形结果元素对象对创建的图像进行膨胀
% 'line'/'diamond'/'ball'...
se=eye(2); % eye(n) returns the n-by-n identity matrix 单位矩阵
[m,n]=size(d);
if bwarea(d)/m/n>=0.365
    d=imerode(d,se);
elseif bwarea(d)/m/n<=0.235
    d=imdilate(d,se);
end

% 对预处理后的车牌文字区域再做收缩切割，即更新车牌区域
I_out = minimizeDistrict(d);

end

