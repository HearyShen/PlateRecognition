function [word,result]=getword(d)

% 6����ȡ������������
% [word, result] = getword(d)
% �����ˣ�����
% 
% ˵����
% �����������Զ�ʶ������У��ַ��ָ��г�ǰ��������á�����ǰ�����ն�λ�Ļ����Ͻ����ַ��ķָȻ�������÷ָ�Ľ�������ַ�ʶ�𡣺���function [word,result]=getword(d)������Ԥ�����ĳ���������������ȡ���ӳ����зָ����n���ַ���
% ��1��	��ʼ��dΪ�Ѿ�Ԥ������ĳ���ͼ��
% ��2��	imcrop��һ����������MATLAB�У��ú������ڷ���ͼ���һ���ü�����
% [A,rect] = imcrop(...)��ʽָ����Ҫ�ü�������imcrop(d,[1 1 wide m])Ϊ�����꣨1,1������ʼ���ü�����СΪ��wide,m��������
% ��3��	size() ��������ȡ���������������
% [r,c]=size(A)���������������ʱ��size������������������ص���һ���������r����������������ص��ڶ����������c��
% ��4��	sum(A; ����ͣ��Ծ���A��ÿһ��Ϊ���󣬶�һ���ڵ�������͡�
% sum(A,2); ����ͣ��Ծ���A��ÿһ��Ϊ���󣬶�һ���ڵ�������͡�
% sum(A(:)); �Ծ������ȫ������ֵ���
% ��5��	����г����ַ��� ����y1,�ҿ�߱�Ϊ1:2 ������Ϊ����Ч�ַ� �������и


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
                d=minimizeDistrict(d);  % �и����С��Χ
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

