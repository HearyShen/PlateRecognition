function [word,result]=getword(d)

% 6、提取车牌文字区域
% [word, result] = getword(d)
% 负责人：封琳
% 
% 说明：
% 在汽车牌照自动识别过程中，字符分割有承前启后的作用。它在前期牌照定位的基础上进行字符的分割，然后再利用分割的结果进行字符识别。函数function [word,result]=getword(d)用来对预处理后的车牌文字区域做提取，从车牌中分割出第n个字符。
% （1）	开始的d为已经预处理过的车牌图像
% （2）	imcrop是一个函数，在MATLAB中，该函数用于返回图像的一个裁剪区域。
% [A,rect] = imcrop(...)格式指定了要裁剪的区域。imcrop(d,[1 1 wide m])为从坐标（1,1）处开始，裁剪出大小为（wide,m）的区域
% （3）	size() 函数：获取矩阵的行数和列数
% [r,c]=size(A)当有两个输出参数时，size函数将矩阵的行数返回到第一个输出变量r，将矩阵的列数返回到第二个输出变量c。
% （4）	sum(A; 列求和，以矩阵A的每一列为对象，对一列内的数字求和。
% sum(A,2); 行求和，以矩阵A的每一行为对象，对一行内的数字求和。
% sum(A(:)); 对矩阵进行全矩阵数值求和
% （5）	如果切除的字符块 大于y1,且宽高比为1:2 ，就认为是有效字符 ，进行切割。


word=[];flag=0;y1=8;y2=0.5;
    while flag==0
        [m,n]=size(d);
        wide=0;
        while sum(d(:,wide+1))~=0 && wide<=n-2
            wide=wide+1;
        end
        temp=minimizeDistrict(imcrop(d,[1 1 wide m]));
        [m1,n1]=size(temp);
        if wide<y1 && n1/m1>y2
            d(:,[1:wide])=0;
            if sum(sum(d))~=0
                d=minimizeDistrict(d);  % 切割出最小范围
            else word=[];flag=1;
            end
        else
            word=minimizeDistrict(imcrop(d,[1 1 wide m]));
            d(:,[1:wide])=0;
            if sum(sum(d))~=0;
                d=minimizeDistrict(d);flag=1;
            else d=[];
            end
        end
    end
%end
          result=d;

