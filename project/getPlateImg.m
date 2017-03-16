function I_out = getPlateImg( Img_preproc, Img_raw )

% 2、定位裁剪车牌图像
% I_plateRaw = getPlateImg(I_Proced, I_raw)
% 负责人：戴星辰
% 
% 说明：
% 	输入:预处理后的二值化图像与原图
% 	输出：裁剪后的拆牌图像
% 	图像定位与裁剪，即给定原图与对应的已与处理的二值化图像来裁剪出正确的车牌位置。算法过程：
% 	1.将预处理后的图像表明连通区域
% 	2.合并相似的连通区域（某些时候车牌会被处理成不同的连通域）
% 	3.查找长宽比最佳的连通域
% 	4.对已查找到的连通域进一步细分四个边界（通过判断每一行列的非零像素点数）
% 	5.根据边界从原图割出车牌区域。

%%%%%%%%%%%%%% 定位裁剪车牌图像 %%%%%%%%%%%%%%%%
[row, col]=size(Img_preproc);
I7_double = double(Img_preproc);
vector=getBestArea(I7_double)
up=vector(1)
down=vector(2)
left=vector(3)
right=vector(4)

 %%%%%% ROWs: 逐行扫描 %%%%%%%%% 车牌区域逐行像素个数统计
 Plate_PixelsPerRow = zeros(row,1);
 for index_row = up:down
    for index_col = left:right
         if(I7_double(index_row,index_col,1)==1) 
            Plate_PixelsPerRow(index_row,1) = Plate_PixelsPerRow(index_row,1)+1;%蓝色像素点统计 
        end  
     end       
 end
 [~, indexOfMaxRowPixels]=max(Plate_PixelsPerRow);%车牌区域-最密集行位置确定
 
 % 自车牌像素最密集行开始，向上寻找车牌上边界
 plate_row_top = indexOfMaxRowPixels;
 while ((Plate_PixelsPerRow(plate_row_top,1)>=5)&&(plate_row_top>1))
        plate_row_top = plate_row_top-1;
 end    
 
 % 自车牌像素最密集行开始，向上寻找车牌下边界
 plate_row_bottom = indexOfMaxRowPixels;
 while ((Plate_PixelsPerRow(plate_row_bottom,1)>=5)&&(plate_row_bottom<row))
        plate_row_bottom = plate_row_bottom+1;
 end
 
 I_rowcut = Img_raw(plate_row_top:plate_row_bottom,:,:);
 
 %%%%%% COLs: 逐列扫描 %%%%%%%%% 车牌区域逐列像素个数统计
 Plate_PixelsPerCol = zeros(1,col); % 进一步确定列方向的车牌区域
 for index_col = left:right
     for index_row = plate_row_top:plate_row_bottom
        if(I7_double(index_row,index_col,1)==1)
            Plate_PixelsPerCol(1,index_col)= Plate_PixelsPerCol(1,index_col)+1;               
        end  
     end       
 end
 
% 自最左列开始，向右寻找车牌左边界
plate_col_left = 1;
while ((Plate_PixelsPerCol(1,plate_col_left)<3)&&(plate_col_left<col))
   plate_col_left = plate_col_left+1;
end    
% 自车牌像素最密集列开始，向左寻找车牌左边界
plate_col_right = col;
while ((Plate_PixelsPerCol(1,plate_col_right)<3)&&(plate_col_right>plate_col_left))
    plate_col_right = plate_col_right-1;
end

plate_col_left=plate_col_left-1;%对车牌区域的校正
plate_col_right=plate_col_right+1;

I_colcut = Img_raw(:,plate_col_left:plate_col_right,:);

up_shrink = int32((plate_row_bottom-plate_row_top)/20)
bottom_shrink = int32((plate_row_bottom-plate_row_top)/7)

I8_plate=Img_raw(plate_row_top+up_shrink:plate_row_bottom-bottom_shrink, plate_col_left:plate_col_right,:);

I_out = I8_plate;
end

