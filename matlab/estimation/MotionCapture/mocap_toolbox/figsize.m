function figsize(width,height)

scrsz=get(gcf,'Position');
set(gcf,'Position',[10 10 scrsz(3)*width scrsz(4)*height]);
