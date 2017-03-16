function [ vector ] = getBestArea( Img_preproc )
%GETMATRIX 此处显示有关此函数的摘要
%   此处显示详细说明
T_double = double(Img_preproc);
[row, col]=size(Img_preproc);
[L,num]=bwlabel(T_double, 4);%获得连通区域与个数%
matrixs=zeros(num,4)%构造对应大小矩阵%

%定位每个联通区域的上下左右界%
for i=1:num
    temp=-1;
    for index_row=1:row
        for index_col=1:col
            if (L(index_row,index_col)==i)
                if(temp==-1)              
                    matrixs(i,1)=index_row;%第一次检测到上界%
                    temp=0;
                else
                    temp = temp+1;       
                end
                break
            end
        end
    end
    matrixs(i,2)=matrixs(i,1)+temp;%上界+偏移=下界%
    temp = -1;
    for index_col=1:col
        for index_row=1:row
            if (L(index_row,index_col)==i)
                if(temp==-1)              
                    matrixs(i,3)=index_col;
                    temp=0;
                else
                    temp = temp+1;       
                end
                break
            end
        end
    end
    matrixs(i,4)=matrixs(i,3)+temp;
end

%判断上下界相似度  是否合并%
if(num==1)
    vector=matrixs(1,:)
    return
end
for i=1:num
    for j=i+1:row
        if (j>num)
            break
        end
        %%如果上界与下界几乎相同 可视为一个整体
        if(abs(matrixs(i,1)-matrixs(j,1))<8&&abs(matrixs(i,2)-matrixs(j,2))<8)
            matrixs(i,3)=min([matrixs(i,3),matrixs(j,3)]);
            matrixs(i,4)=max([matrixs(i,4),matrixs(j,4)]);
            matrixs(j,:)=[-1,-1,-1,-1];
            num=num-1
        end
    end
end

%再次检索长与宽之比是否符合要求%
if(num==1)
    vector=matrixs(1,:)
    return
end
best=1
best_pro=9%当前最佳比例
for i=1:num
    if(abs(3.142-(matrixs(i,4)-matrixs(i,3))/(matrixs(i,2)-matrixs(i,1)))<best_pro)
        %更新最佳区域%
        best=i
        best_pro=abs(3.142-(matrixs(i,4)-matrixs(i,3))/(matrixs(i,2)-matrixs(i,1)))
    end
end
vector=matrixs(best,:);

 

