function I_out = preProcPlateImg( Img_plate )

% 3������ͼ��Ԥ����
% I_plateProced = preProcPlateImg(I_plateRaw)
% �����ˣ�½�ѳ�
% 
% ˵����
% ����Ϊ��Ϊ����ĳ�����Χ��ͼ��
% ���Ϊϸ����ĳ��ƶ�ֵͼ��
% 
% ԭ��
% ���ȶ�����ͼ����ж�ֵ������Ȼ������robert���ӱ�Ե��⣬
% ������Ե����и�ʴȻ��ƽ����������Ʋ�����һ���Ƚϴ�Ķ���
% ��С�����Ƴ������ȷ�������Ƶ����ꡣ���������ԭͼ�н����ƽس���
% Ȼ������ö�ֵ������ֵ�˲������ͣ����ܵõ�Ԥ�����ĳ���ͼ��

%%%%%%%%%%%%%% ����ͼ��Ԥ���� %%%%%%%%%%%%%%%%
% [filename,filepath]=uigetfile('cuttedplate.jpg','ѡ��ü����ĳ���ͼ��');
% url_plate=strcat(filepath,filename);
% a=imread(url_plate);
a = Img_plate;
b=rgb2gray(a);

g_max=double(max(max(b)));
g_min=double(min(min(b)));
T=round(g_max-(g_max-g_min)/3); % T Ϊ��ֵ������ֵ
[m,n]=size(b);
d=(double(b)>=T);  % d:��ֵͼ��

% �˲�
h=fspecial('average',3);
d=im2bw(round(filter2(h,d)));

% ĳЩͼ����в���
% ���ͻ�ʴ
% se=strel('square',3);  % ʹ��һ��3X3�������ν��Ԫ�ض���Դ�����ͼ���������
% 'line'/'diamond'/'ball'...
se=eye(2); % eye(n) returns the n-by-n identity matrix ��λ����
[m,n]=size(d);
if bwarea(d)/m/n>=0.365
    d=imerode(d,se);
elseif bwarea(d)/m/n<=0.235
    d=imdilate(d,se);
end

% ��Ԥ�����ĳ��������������������и�����³�������
I_out = minimizeDistrict(d);

end

