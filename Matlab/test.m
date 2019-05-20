fig = openfig('10_Seeds/Heatmap_1.fig');

axObjs = fig.Children;
% dataObjs = axObjs.Children
data = axObjs.ColorData;

createfigure1(data)
% saveas(fig,'Heatmap_.jpg')

% imwrite(data,'myGray.png')
% saveas(fig,'myGray.png')

% x = dataObjs(1).XData
% y = dataObjs(1).YData
% z = dataObjs(1).ZData

% createfigure(axObjs)

% imwrite(fig,'myGray.png')
% imsave