function [word1, word2, word3, word4, word5, word6, word7] = partitionWords( I_plateProced )

% 4���������ֲ��� 
%   [word1,word2,word3,word4,word5,word6,word7] = partitionWords(I_plateProced)
% �����ˣ��߱�
% 
% ˵����
% �������������һ����ֵͼ�������Ӧ���ַ�ģ�塣
% 
% ���̣�
% 	����ѭ���ҳ��ַ������ж��ַ������С�����ڰ�������ַ��������ҳ�����ֵ���ٵ��У��������ֵ���ֿ��ַ�����
% 	��ʼ���ηָ��ַ����򣬲�����getword������ȡ���Ӧ���ַ�ģ�塣
% 	���ж��ڵ�һ���ַ������ж��Ƿ����ַ������С�ھ����ȣ��Ͳ����ַ�����ո���������ֵ�������иֱ���ҵ����Ͽ�ȵ��ַ����򣬲��Ҹ������м������ֵ�ܺʹ��ھ�����Сֵ������Ϊ�ǵ�һ���ַ����ָ�ɹ���
% 	�����Ӧ���ַ�ģ�塣

%%%%%%%%%%%%%% �������ֲ��� %%%%%%%%%%%%%%%%
% Ѱ�����������ֵĿ飬�����ȴ���ĳ��ֵ������Ϊ�ÿ��������ַ���ɣ���Ҫ�ָ�

d = I_plateProced;

[m,n]=size(d);

k1=1;%ĳ���ַ�����������
k2=1;%ĳ���ַ���������ұ�

s=sum(d);%��������ÿ������ֵ�ĺ�

i=1;%ѭ����������
while i~=n

	%�ҳ�ĳ���ַ�����������
    while s(i)==0
        i=i+1;
    end
    k1=i;
	
	%�ҳ�ĳ���ַ���������ұ�
    while s(i)~=0 && i<=n-1
        i=i+1;
    end
    k2=i-1;
	
    if k2-k1>=round(n/6.5)%�жϸ��ַ������ȣ�ȷ���ǲ��ǰ����˶���ַ�
        [val,num]=min(sum(d(:,[k1+5:k2-5])));%�ҳ��ַ������������ֵ�����ٵ���һ��
        d(:,k1+5+num)=0;  % ��� �ַ�������������ֵ
    end
end

d=minimizeDistrict(d); %��С��ϸ������
%%�и�� 7 ���ַ�
%һЩ������ֵ
y1=10;
y2=0.25;
%�źű���
flag=0;

%�ָ����һ���ַ�����Ϊ�������ţ���������������
word1=[];
while flag==0
    [m,n]=size(d);
	%�ҳ� ���� ����ĳ�ַ��������ұߵ��кţ�Ҳ����Ϊ���� ������Ŀ��
    wide=0;
    while sum(d(:,wide+1))~=0
        wide=wide+1;
    end
	
    if wide<y1   % ��� ���ұ��к� С�� �������ޣ��� �������� С�� �����ȣ���Ϊ�� ������,���� �ַ�
        d(:,[1:wide])=0;%��ո��ŵ�����ֵ
        d=minimizeDistrict(d);%�и�
    else
        temp=minimizeDistrict(imcrop(d,[1 1 wide m]));%�ü��ַ�����
        [m,n]=size(temp);
        all=sum(sum(temp));%�ܵ�����ֵ
        two_thirds=sum(sum(temp([round(m/3):2*round(m/3)],:)));%�ַ������м䲿�ֵ�����ֵ֮��
		
        if two_thirds/all>y2%��� �ַ������м䲿�ֵ�����ֵ֮�� ��ռ ������ֵ ���� ���ھ�����Сֵ������Ϊ �˲��� �����ַ�
            flag=1;	%�����ź�
			word1=temp;   %��������
        end
        d(:,[1:wide])=0;d=minimizeDistrict(d);
    end
end


% �ָ���ڶ����ַ�
[word2,d]=getword(d);
% �ָ���������ַ�
[word3,d]=getword(d);
% �ָ�����ĸ��ַ�
[word4,d]=getword(d);
% �ָ��������ַ�
[word5,d]=getword(d);
% �ָ���������ַ�
[word6,d]=getword(d);
% �ָ�����߸��ַ�
[word7,d]=getword(d);

%[m,n]=size(word1);
% ͳһ����СΪ 40*20����ʾ
word1=imresize(word1,[40 20]);
word2=imresize(word2,[40 20]);
word3=imresize(word3,[40 20]);
word4=imresize(word4,[40 20]);
word5=imresize(word5,[40 20]);
word6=imresize(word6,[40 20]);
word7=imresize(word7,[40 20]);

end

