function Code = recognizeWords( word1, word2, word3, word4, word5, word6, word7 )

% 5、文字识别 【技术难点】
% Code = recognizeWords( word1, word2, word3, word4, word5, word6, word7 )
% 负责人：张珍茹， 魏然
% 
% 说明：
% 字符识别是车牌识别中很重要的一部分，在模式识别中也扮演的很重要的角色。这里使用的是模板匹配算法：
% 1、首先本文识别的前提是模板字符是二值图像，背景黑色，字符为白色；同样待识别的字符同样如此。
% 2、将预处理后的待识别字符图像imageU与字符模板库中的字符图像imageT进行”与“运算得到共同部分图像imageV；
% 3、将得到的共同部分图像与待识别字符进行逻辑”异或“运算，得到待识别字符图像多余部分imageX；
% 4、将得到的共同部分图像与模板字符进行逻辑”异或“运算，得到模板图像多余部分imageW。
% 5、计算每个模板字符图像imageT中白像素个数T,待识别字符图像imageU的白像素个数U，
% 6、imageU与imageT共同的部分imageV的白像素个数V，imageW的白像素个数W；imageX中白像素个数X；
% 7、构造判别函数表达式为：
%    tempSum=sqrt(((T-TUV)*(T-TUV)+(U-TUV)*(U-TUV)+(V-TUV)*(V-TUV))/2);
%    Y(j)=V/(W/T*X/U*tempSum);
%    其中TUV=（T+U+V）/3;
%    这样，相似系数最大max（Y）对应的模板M为待识别字符；

templatePath='templateCharacter\';
fileFormat='.bmp';
templateImage=zeros(40,20,67); 
%Timage=zeros(67,800);
for i=1:67 %读取模板
    stri=num2str(i-1);
    imagePath=[templatePath,stri,fileFormat];
    tempImage=imread(imagePath);
    templateImage(:,:,i)=tempImage;
    clear imagePath stri tempImage;
end

%characterImage(40,20,7)= {word1,word2,word3,word4,word5,word6,word7};
characterImage = zeros(40,20,7);
 characterImage(:,:,1)= word1;
 characterImage(:,:,2)= word2;
 characterImage(:,:,3)= word3; 
 characterImage(:,:,4)= word4; 
 characterImage(:,:,5)= word5; 
 characterImage(:,:,6)= word6; 
 characterImage(:,:,7)= word7;
%Uimage=zeros(7,800);

liccode=char(['0':'9' 'A':'Z' '京冀津晋蒙辽吉黑沪苏浙皖闽赣鲁豫鄂湘粤桂琼渝川贵云藏陕甘青宁新']); 
Y=zeros(1,67);
I=1;
for i=1:7
    U=length(find( characterImage(:,:,i))~=0);%计算待识别字符中白像素的个数
    for j=1:67
        T=length(find( templateImage(:,:,j))~=0); %计算字符模板中白像素的个数
        tempV=characterImage(:,:,i)& templateImage(:,:,j); %求字符模板与待测图像的并集
        V=length(find(tempV)~=0); 
        tempW=xor(tempV,templateImage(:,:,j)); %求字符模板的多余部分
        W=length(find(tempW)~=0);
        tempX=xor(tempV,characterImage(:,:,i)); %求待测图像的多余部分
        X=length(find(tempX)~=0);
        %构造判别函数
        TUV=(T+U+V)/3; 
        tempSum=sqrt(((T-TUV)*(T-TUV)+(U-TUV)*(U-TUV)+(V-TUV)*(V-TUV))/2);
        Y(j)=V/(W/T*X/U*tempSum);
    end
    [MAX,indexMax]=max(Y); %相似系数最大max（Y）对应的模板M为待识别字符
    Code(I*2-1)=liccode(indexMax);
    Code(I*2)=' ';
    I=I+1;

    clear imagePath indexMax;
end

