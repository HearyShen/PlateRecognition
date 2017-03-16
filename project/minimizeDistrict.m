function I_out = minimizeDistrict( I_in )

% 7、收缩、细化有效区域
% I_out = minimizeDistrict(I_in)
% 负责人：丁瑞宇
% 
% 说明：
% 对预处理后的车牌文字区域再做收缩切割，即更新车牌区域。

% 对预处理后的车牌文字区域再做收缩切割，即更新车牌区域
[m,n]=size(I_in);
top=1;
bottom=m;
left=1;
right=n;   % init
while sum(I_in(top,:))==0 && top<=m
    top=top+1;
end
while sum(I_in(bottom,:))==0 && bottom>=1
    bottom=bottom-1;
end
while sum(I_in(:,left))==0 && left<=n
    left=left+1;
end
while sum(I_in(:,right))==0 && right>=1
    right=right-1;
end
I_out = I_in(top:bottom, left:right, :);

end

