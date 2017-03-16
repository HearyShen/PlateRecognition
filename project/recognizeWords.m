function Code = recognizeWords( word1, word2, word3, word4, word5, word6, word7 )

% 5������ʶ�� �������ѵ㡿
% Code = recognizeWords( word1, word2, word3, word4, word5, word6, word7 )
% �����ˣ������㣬 κȻ
% 
% ˵����
% �ַ�ʶ���ǳ���ʶ���к���Ҫ��һ���֣���ģʽʶ����Ҳ���ݵĺ���Ҫ�Ľ�ɫ������ʹ�õ���ģ��ƥ���㷨��
% 1�����ȱ���ʶ���ǰ����ģ���ַ��Ƕ�ֵͼ�񣬱�����ɫ���ַ�Ϊ��ɫ��ͬ����ʶ����ַ�ͬ����ˡ�
% 2����Ԥ�����Ĵ�ʶ���ַ�ͼ��imageU���ַ�ģ����е��ַ�ͼ��imageT���С��롰����õ���ͬ����ͼ��imageV��
% 3�����õ��Ĺ�ͬ����ͼ�����ʶ���ַ������߼���������㣬�õ���ʶ���ַ�ͼ����ಿ��imageX��
% 4�����õ��Ĺ�ͬ����ͼ����ģ���ַ������߼���������㣬�õ�ģ��ͼ����ಿ��imageW��
% 5������ÿ��ģ���ַ�ͼ��imageT�а����ظ���T,��ʶ���ַ�ͼ��imageU�İ����ظ���U��
% 6��imageU��imageT��ͬ�Ĳ���imageV�İ����ظ���V��imageW�İ����ظ���W��imageX�а����ظ���X��
% 7�������б������ʽΪ��
%    tempSum=sqrt(((T-TUV)*(T-TUV)+(U-TUV)*(U-TUV)+(V-TUV)*(V-TUV))/2);
%    Y(j)=V/(W/T*X/U*tempSum);
%    ����TUV=��T+U+V��/3;
%    ����������ϵ�����max��Y����Ӧ��ģ��MΪ��ʶ���ַ���

templatePath='templateCharacter\';
fileFormat='.bmp';
templateImage=zeros(40,20,67); 
%Timage=zeros(67,800);
for i=1:67 %��ȡģ��
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

liccode=char(['0':'9' 'A':'Z' '����������ɼ��ڻ�����������³ԥ�����������崨���Ʋ��¸�������']); 
Y=zeros(1,67);
I=1;
for i=1:7
    U=length(find( characterImage(:,:,i))~=0);%�����ʶ���ַ��а����صĸ���
    for j=1:67
        T=length(find( templateImage(:,:,j))~=0); %�����ַ�ģ���а����صĸ���
        tempV=characterImage(:,:,i)& templateImage(:,:,j); %���ַ�ģ�������ͼ��Ĳ���
        V=length(find(tempV)~=0); 
        tempW=xor(tempV,templateImage(:,:,j)); %���ַ�ģ��Ķ��ಿ��
        W=length(find(tempW)~=0);
        tempX=xor(tempV,characterImage(:,:,i)); %�����ͼ��Ķ��ಿ��
        X=length(find(tempX)~=0);
        %�����б���
        TUV=(T+U+V)/3; 
        tempSum=sqrt(((T-TUV)*(T-TUV)+(U-TUV)*(U-TUV)+(V-TUV)*(V-TUV))/2);
        Y(j)=V/(W/T*X/U*tempSum);
    end
    [MAX,indexMax]=max(Y); %����ϵ�����max��Y����Ӧ��ģ��MΪ��ʶ���ַ�
    Code(I*2-1)=liccode(indexMax);
    Code(I*2)=' ';
    I=I+1;

    clear imagePath indexMax;
end

