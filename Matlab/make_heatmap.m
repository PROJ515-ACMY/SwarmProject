%% Varables
filename = 'test.txt';                                                      % CSV

Resolution = 0.1;
Range_min = 0;
Range_max = 10;

%% Constants
out = zeros(10*(1/Resolution));

%% input x,y,v (v=z)
% x,y= copradanates v= value

% read file
M = csvread(filename);

% rearange data
out(sub2ind(size(out),(M(:,1)*(1/Resolution)),(M(:,2)*(1/Resolution)))) = M(:,3);

%% interpolate
% size(M(:,1));
% X = zeros(size(M));
% v = zeros(size(M(:,3)));
% X(:,1) = M(:,1);
% X(:,2) = M(:,2);
% V = M(:,3);
% F = scatteredInterpolant(X,V);
F = scatteredInterpolant(M(:,1),M(:,2),M(:,3));

x = Range_min:Resolution:Range_max;                                         % [low lim : resalution : up lim]
y = Range_min:Resolution:Range_max;

% [X,Y] = meshgrid(x,y);

[Xq,Yq] = meshgrid(x,y);    %0:0.1:10);
F.Method = 'natural';
Vq = F(Xq,Yq);
figure
surf(Xq,Yq,Vq);
xlabel('X','fontweight','b'),ylabel('Y','fontweight','b') 
zlabel('Value - V','fontweight','b')
title('Natural neighbor Interpolation Method','fontweight','b');

%% plot v at point x,y (= 3d graph or v=colour)
% heatmap
figure;
% Yq(:,1)
Heat_map = heatmap(Xq(1,:),Yq(:,1),Vq);%(out);
Heat_map.GridVisible = 'off';                                               % Remove gridlines
colormap('jet');                                                            % Set colour scale 'jet'= clearest for humans

%% repeat???

