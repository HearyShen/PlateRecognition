function [word1, word2, word3, word4, word5, word6, word7] = partitionWords( I_plateProced )

% 4、车牌文字裁切 
%   [word1,word2,word3,word4,word5,word6,word7] = partitionWords(I_plateProced)
% 负责人：高冰
% 
% 说明：
% 输入输出：输入一个二值图像，输出对应的字符模板。
% 
% 过程：
% 	首先循环找出字符区域，判断字符区域大小，对于包含多个字符的区域，找出像素值最少的列，清空像素值，分开字符区域。
% 	开始依次分割字符区域，并调用getword函数获取相对应的字符模板。
% 	其中对于第一个字符区域，判断是否是字符，如果小于经验宽度，就不是字符，清空该区域像素值，进行切割。直至找到符合宽度的字符区域，并且该区域中间的像素值总和大于经验最小值，就认为是第一个字符，分割成功。
% 	输出对应的字符模板。

%%%%%%%%%%%%%% 车牌文字裁切 %%%%%%%%%%%%%%%%
% 寻找连续有文字的块，若长度大于某阈值，则认为该块有两个字符组成，需要分割

d = I_plateProced;

[m,n]=size(d);

k1=1;%某个字符区域的最左边
k2=1;%某个字符区域的最右边

s=sum(d);%行向量，每列像素值的和

i=1;%循环计数变量
while i~=n

	%找出某个字符区域的最左边
    while s(i)==0
        i=i+1;
    end
    k1=i;
	
	%找出某个字符区域的最右边
    while s(i)~=0 && i<=n-1
        i=i+1;
    end
    k2=i-1;
	
    if k2-k1>=round(n/6.5)%判断该字符区域宽度，确定是不是包含了多个字符
        [val,num]=min(sum(d(:,[k1+5:k2-5])));%找出字符间隔，即像素值和最少的那一列
        d(:,k1+5+num)=0;  % 清空 字符间隔区域的像素值
    end
end

d=minimizeDistrict(d); %缩小、细化区域
%%切割出 7 个字符
%一些经验数值
y1=10;
y2=0.25;
%信号变量
flag=0;

%分割出第一个字符，因为有左侧干扰，首先消除左侧干扰
word1=[];
while flag==0
    [m,n]=size(d);
	%找出 可能 包含某字符区域最右边的列号，也可认为就是 此区域的宽度
    wide=0;
    while sum(d(:,wide+1))~=0
        wide=wide+1;
    end
	
    if wide<y1   % 如果 最右边列号 小于 给定界限，即 此区域宽度 小于 经验宽度，认为是 左侧干扰,不是 字符
        d(:,[1:wide])=0;%清空干扰的像素值
        d=minimizeDistrict(d);%切割
    else
        temp=minimizeDistrict(imcrop(d,[1 1 wide m]));%裁剪字符区域
        [m,n]=size(temp);
        all=sum(sum(temp));%总的像素值
        two_thirds=sum(sum(temp([round(m/3):2*round(m/3)],:)));%字符区域中间部分的像素值之和
		
        if two_thirds/all>y2%如果 字符区域中间部分的像素值之和 所占 总像素值 比重 大于经验最小值，则认为 此部分 包含字符
            flag=1;	%结束信号
			word1=temp;   %保存区域
        end
        d(:,[1:wide])=0;d=minimizeDistrict(d);
    end
end


% 分割出第二个字符
[word2,d]=getword(d);
% 分割出第三个字符
[word3,d]=getword(d);
% 分割出第四个字符
[word4,d]=getword(d);
% 分割出第五个字符
[word5,d]=getword(d);
% 分割出第六个字符
[word6,d]=getword(d);
% 分割出第七个字符
[word7,d]=getword(d);

%[m,n]=size(word1);
% 统一化大小为 40*20后显示
word1=imresize(word1,[40 20]);
word2=imresize(word2,[40 20]);
word3=imresize(word3,[40 20]);
word4=imresize(word4,[40 20]);
word5=imresize(word5,[40 20]);
word6=imresize(word6,[40 20]);
word7=imresize(word7,[40 20]);

end

