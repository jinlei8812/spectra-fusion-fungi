function [r]=ConfidenceRegion(xdat,alpha,distribution)
%   绘制置信区域（区间、椭圆区域或椭球区域）
%   ConfidenceRegion(xdat,alpha,distribution)
%   xdat：样本观测值矩阵,p*N 或 N*p的矩阵，p = 1,2 或 3
%   alpha：显著性水平，标量，取值介于[0,1]，默认值为0.05
%   distribution：字符串（'norm'或'experience'），用来指明求置信区域用到的分布类型，
%   distribution的取值只能为字符串'norm'或'experience'，分别对应正态分布和经验分布
%   CopyRight：xiezhh（谢中华）
%   date：2011.4.14
%
%   example1：x = normrnd(10,4,100,1);
%             ConfidenceRegion(x)
%             ConfidenceRegion(x,'exp')
%   example2：x = mvnrnd([1;2],[1 4;4 25],100);
%             ConfidenceRegion(x)
%             ConfidenceRegion(x,'exp')
%   example3：x = mvnrnd([1;2;3],[3 0 0;0 5 -1;0 -1 1],100);
%             ConfidenceRegion(x)
%             ConfidenceRegion(x,'exp')
% 设定参数默认值
if nargin == 1
    distribution = 'norm';
    alpha = 0.05;
elseif nargin == 2
    if ischar(alpha)
        distribution = alpha;
        alpha = 0.05;
    else
        distribution = 'norm';
    end
end
% 判断参数取值是否合适
if ~isscalar(alpha) || alpha>=1 || alpha<=0
    error('alpha的取值介于0和1之间')
end
if ~strncmpi(distribution,'norm',3) && ~strncmpi(distribution,'experience',3)
    error('分布类型只能是正态分布（''norm''）或经验分布（''experience''）')
end
% 检查数据维数是否正确
[m,n] = size(xdat);
p = min(m,n);  % 维数
if ~ismember(p,[1,2,3])
    error('应输入一维、二维或三维样本数据,并且样本容量应大于3')
end
% 把样本观测值矩阵转置，使得行对应观测，列对应变量
if m < n
    xdat = xdat';
end
xm = mean(xdat); % 均值
n = max(m,n);  % 观测组数
% 分情况绘制置信区域
switch p
    case 1    % 一维情形（置信区间）
        xstd = std(xdat); % 标准差
        if strncmpi(distribution,'norm',3)
            lo = xm - xstd*norminv(1-alpha/2,0,1); % 正态分布情形置信下限
            up = xm + xstd*norminv(1-alpha/2,0,1); % 正态分布情形置信上限
            %lo = xm - xstd*tinv(1-alpha/2,n-1); % 正态分布情形置信下限
            %up = xm + xstd*tinv(1-alpha/2,n-1); % 正态分布情形置信上限
            TitleText = '置信区间（基于正态分布）';
        else
            lo = prctile(xdat,100*alpha/2); % 经验分布情形置信下限
            up = prctile(xdat,100*(1-alpha/2)); % 经验分布情形置信上限
            TitleText = '置信区间（基于经验分布）';
        end
        % 对落入区间内外不同点用不同颜色和符号绘图
        xin = xdat(xdat>=lo & xdat<=up);
        xid = find(xdat>=lo & xdat<=up);
        plot(xid,xin,'.')
        hold on
        xout = xdat(xdat<lo | xdat>up);
        xid = find(xdat<lo | xdat>up);
        plot(xid,xout,'r+')
        h = refline([0,lo]);
        set(h,'color','k','linewidth',2)
        h = refline([0,up]);
        set(h,'color','k','linewidth',2)
        xr = xlim;
        yr = ylim;
        text(xr(1)+range(xr)/20,lo-range(yr)/20,'置信下限',...
            'color','g','FontSize',15,'FontWeight','bold')
        text(xr(1)+range(xr)/20,up+range(yr)/20,'置信上限',...
            'color','g','FontSize',15,'FontWeight','bold')
        xlabel('观测序号')
        ylabel('观测值')
        title(TitleText)
        hold off
    case 2    % 二维情形（置信椭圆）
        x = xdat(:,1);
        y = xdat(:,2);
        s = inv(cov(xdat));  % 协方差矩阵
        xd = xdat-repmat(xm,[n,1]);
        rd = sum(xd*s.*xd,2);
        if strncmpi(distribution,'norm',3)
            r = chi2inv(1-alpha,p);
            %r = p*(n-1)*finv(1-alpha,p,n-p)/(n-p)/n;
            TitleText = '置信椭圆（基于正态分布）';
        else
            r = prctile(rd,100*(1-alpha));
            TitleText = '置信椭圆（基于经验分布）';
        end
        plot(x(rd<=r),y(rd<=r),'b.','MarkerSize',20)  % 画样本散点
        hold on
        plot(x(rd>r),y(rd>r),'b.','MarkerSize',20)  % 画样本散点
        plot(xm(1),xm(2),'k+');  % 椭圆中心
        h = ellipsefig(xm,s,r,1);  % 绘制置信椭圆
        xlabel('X')
        ylabel('Y')
        title(TitleText)
        hold off;
    case 3    % 三维情形（置信椭球）
        x = xdat(:,1);
        y = xdat(:,2);
        z = xdat(:,3);
        s = inv(cov(xdat));  % 协方差矩阵
        xd = xdat-repmat(xm,[n,1]);
        rd = sum(xd*s.*xd,2);
        if strncmpi(distribution,'norm',3)
            r = chi2inv(1-alpha,p);
            %r = p*(n-1)*finv(1-alpha,p,n-p)/(n-p)/n;
            TitleText = '置信椭球（基于正态分布）';
        else
            r = prctile(rd,100*(1-alpha));
            TitleText = '置信椭球（基于经验分布）';
        end
        plot3(x(rd<=r),y(rd<=r),z(rd<=r),'r.','MarkerSize',25)  % 画样本散点
        hold on
        plot3(x(rd>r),y(rd>r),z(rd>r),'r+','MarkerSize',10)  % 画样本散点
        plot3(xm(1),xm(2),xm(3),'k+');  % 椭球中心
        h = ellipsefig(xm,s,r,2);  % 绘制置信椭球
        xlabel('X')
        ylabel('Y')
        zlabel('Z')
        title(TitleText)
        hidden off;
        hold off;
end
