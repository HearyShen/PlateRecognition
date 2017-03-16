function [ vector ] = getBestArea( Img_preproc )
%GETMATRIX �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
T_double = double(Img_preproc);
[row, col]=size(Img_preproc);
[L,num]=bwlabel(T_double, 4);%�����ͨ���������%
matrixs=zeros(num,4)%�����Ӧ��С����%

%��λÿ����ͨ������������ҽ�%
for i=1:num
    temp=-1;
    for index_row=1:row
        for index_col=1:col
            if (L(index_row,index_col)==i)
                if(temp==-1)              
                    matrixs(i,1)=index_row;%��һ�μ�⵽�Ͻ�%
                    temp=0;
                else
                    temp = temp+1;       
                end
                break
            end
        end
    end
    matrixs(i,2)=matrixs(i,1)+temp;%�Ͻ�+ƫ��=�½�%
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

%�ж����½����ƶ�  �Ƿ�ϲ�%
if(num==1)
    vector=matrixs(1,:)
    return
end
for i=1:num
    for j=i+1:row
        if (j>num)
            break
        end
        %%����Ͻ����½缸����ͬ ����Ϊһ������
        if(abs(matrixs(i,1)-matrixs(j,1))<8&&abs(matrixs(i,2)-matrixs(j,2))<8)
            matrixs(i,3)=min([matrixs(i,3),matrixs(j,3)]);
            matrixs(i,4)=max([matrixs(i,4),matrixs(j,4)]);
            matrixs(j,:)=[-1,-1,-1,-1];
            num=num-1
        end
    end
end

%�ٴμ��������֮���Ƿ����Ҫ��%
if(num==1)
    vector=matrixs(1,:)
    return
end
best=1
best_pro=9%��ǰ��ѱ���
for i=1:num
    if(abs(3.142-(matrixs(i,4)-matrixs(i,3))/(matrixs(i,2)-matrixs(i,1)))<best_pro)
        %�����������%
        best=i
        best_pro=abs(3.142-(matrixs(i,4)-matrixs(i,3))/(matrixs(i,2)-matrixs(i,1)))
    end
end
vector=matrixs(best,:);

 

