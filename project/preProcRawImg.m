function I_out = preProcRawImg( Img_raw )

% 1��ԭʼͼ��Ԥ���� �������ѵ㡿
% I_Proced = preProcRawImg(I_raw)
% �����ˣ�������
% 
% ˵����
% ����	preProcRawImg
% ����	ԭͼ
% ���	�ܹ����ֳ��ƺͱ����Ķ�ֵͼ
% 
% ԭ��
% ���Ƚ�ԭͼ��ת��Ϊ�Ҷ�ͼ��Ȼ��ѡ�����ʵ���ֵ�����Ҷ�ͼת��Ϊ��ֵͼ��
% ��roberts���ӽ��б�Ե��⣬�Ա�Եͼ�������̬ѧ��ʴ��
% ֮����к������̬ѧ�պϣ�
% ���ͼ���е�С�����Ƴ����õ�Ŀ�공��������λ�ö�ֵͼ��


%%%%%%%%%%%%%% ԭʼͼ��Ԥ���� %%%%%%%%%%%%%%%%
%1)ԭͼת���Ҷ�ͼ
I1_rgb2gray = rgb2gray(Img_raw);

%2)�Ҷ�ͼת����ֵͼ 
%===========�Ľ�=============
T=graythresh(I1_rgb2gray);
I2_binary=im2bw(I1_rgb2gray,T);

%3)��Ե��⣺sobel
I3_edge = edge(I2_binary,'sobel',0.15);

%4) ��ʴͼ��: ��̬ѧ��ʴ
se = [1;1];
I4_erosion = imerode(I3_edge,se);

%5)ƽ��ͼ����������̬ѧ�պ�
se = strel('rectangle',[24,24]);    % ��̬ѧ�ṹԪ��
%=================��������ڣ�����������������============================
%���ƴ����������Сʱ��[]����ֵ����
I5_smooth = imclose(I4_erosion,se);


% ����������ƣ��������ұ߽�����������¾�Ϊ��Ѷ������S��
I_cutmargin = I5_smooth;
[m,n,~] = size(I_cutmargin);
vertical_margin = m/10      % �����ֱ����߽磬�����±߽�
horizontal_margin = n/10    % ���ˮƽ����߽磬�����ұ߽磨ע�⣺n/10��Ϊ������
for i = 1:m
    for j = 1:n
        if (i<vertical_margin || i>m-vertical_margin || j<horizontal_margin || j>n-horizontal_margin)
            I_cutmargin(i,j) = 0;
        end
    end
end
I5_smooth = I_cutmargin;

%6)�Ӷ������Ƴ�С����
imLabel = bwlabel(I5_smooth);                %�Ը���ͨ����б��
stats = regionprops(imLabel,'Area');        %�����ͨ��Ĵ�С
area = cat(1,stats.Area);                   %��������
index = find(area == max(area));            %�������ͨ�������
I6_filter = ismember(imLabel,index);          %��ȡ�����ͨ��ͼ��

I_out = I6_filter;
end