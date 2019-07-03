function export_pdf(fig,strname)

set(fig,'renderer','painters')
fig.PaperPositionMode = 'auto';
fig_pos = fig.PaperPosition;
fig.PaperSize = [fig_pos(3) fig_pos(4)];
print(fig,strname,'-dpdf')
