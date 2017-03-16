function I_out = getPlateImg( Img_preproc, Img_raw )

% 2����λ�ü�����ͼ��
% I_plateRaw = getPlateImg(I_Proced, I_raw)
% �����ˣ����ǳ�
% 
% ˵����
% 	����:Ԥ�����Ķ�ֵ��ͼ����ԭͼ
% 	������ü���Ĳ���ͼ��
% 	ͼ��λ��ü���������ԭͼ���Ӧ�����봦��Ķ�ֵ��ͼ�����ü�����ȷ�ĳ���λ�á��㷨���̣�
% 	1.��Ԥ������ͼ�������ͨ����
% 	2.�ϲ����Ƶ���ͨ����ĳЩʱ���ƻᱻ����ɲ�ͬ����ͨ��
% 	3.���ҳ������ѵ���ͨ��
% 	4.���Ѳ��ҵ�����ͨ���һ��ϸ���ĸ��߽磨ͨ���ж�ÿһ���еķ������ص�����
% 	5.���ݱ߽��ԭͼ�����������

%%%%%%%%%%%%%% ��λ�ü�����ͼ�� %%%%%%%%%%%%%%%%
[row, col]=size(Img_preproc);
I7_double = double(Img_preproc);
vector=getBestArea(I7_double)
up=vector(1)
down=vector(2)
left=vector(3)
right=vector(4)

 %%%%%% ROWs: ����ɨ�� %%%%%%%%% ���������������ظ���ͳ��
 Plate_PixelsPerRow = zeros(row,1);
 for index_row = up:down
    for index_col = left:right
         if(I7_double(index_row,index_col,1)==1) 
            Plate_PixelsPerRow(index_row,1) = Plate_PixelsPerRow(index_row,1)+1;%��ɫ���ص�ͳ�� 
        end  
     end       
 end
 [~, indexOfMaxRowPixels]=max(Plate_PixelsPerRow);%��������-���ܼ���λ��ȷ��
 
 % �Գ����������ܼ��п�ʼ������Ѱ�ҳ����ϱ߽�
 plate_row_top = indexOfMaxRowPixels;
 while ((Plate_PixelsPerRow(plate_row_top,1)>=5)&&(plate_row_top>1))
        plate_row_top = plate_row_top-1;
 end    
 
 % �Գ����������ܼ��п�ʼ������Ѱ�ҳ����±߽�
 plate_row_bottom = indexOfMaxRowPixels;
 while ((Plate_PixelsPerRow(plate_row_bottom,1)>=5)&&(plate_row_bottom<row))
        plate_row_bottom = plate_row_bottom+1;
 end
 
 I_rowcut = Img_raw(plate_row_top:plate_row_bottom,:,:);
 
 %%%%%% COLs: ����ɨ�� %%%%%%%%% ���������������ظ���ͳ��
 Plate_PixelsPerCol = zeros(1,col); % ��һ��ȷ���з���ĳ�������
 for index_col = left:right
     for index_row = plate_row_top:plate_row_bottom
        if(I7_double(index_row,index_col,1)==1)
            Plate_PixelsPerCol(1,index_col)= Plate_PixelsPerCol(1,index_col)+1;               
        end  
     end       
 end
 
% �������п�ʼ������Ѱ�ҳ�����߽�
plate_col_left = 1;
while ((Plate_PixelsPerCol(1,plate_col_left)<3)&&(plate_col_left<col))
   plate_col_left = plate_col_left+1;
end    
% �Գ����������ܼ��п�ʼ������Ѱ�ҳ�����߽�
plate_col_right = col;
while ((Plate_PixelsPerCol(1,plate_col_right)<3)&&(plate_col_right>plate_col_left))
    plate_col_right = plate_col_right-1;
end

plate_col_left=plate_col_left-1;%�Գ��������У��
plate_col_right=plate_col_right+1;

I_colcut = Img_raw(:,plate_col_left:plate_col_right,:);

up_shrink = int32((plate_row_bottom-plate_row_top)/20)
bottom_shrink = int32((plate_row_bottom-plate_row_top)/7)

I8_plate=Img_raw(plate_row_top+up_shrink:plate_row_bottom-bottom_shrink, plate_col_left:plate_col_right,:);

I_out = I8_plate;
end

