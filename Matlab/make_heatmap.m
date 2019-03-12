%% Varables
Resolution = 0.1;
Range_min = 0;
Range_max = 10;

filename = 'test.txt';                                                      % CSV x,y,v x,y= copradanates v= value

%% Constants
Raw_Heatmap_Data = zeros(10*(1/Resolution));

%% Get data
% read file
File_Data = csvread(filename);

% rearange data
Raw_Heatmap_Data(sub2ind(size(Raw_Heatmap_Data),(File_Data(:,2)*(1/Resolution)),(File_Data(:,1)*(1/Resolution)))) = File_Data(:,3);

%% Interpolate
F = scatteredInterpolant(File_Data(:,1),File_Data(:,2),File_Data(:,3));     % Interpolate???

% Get a set of coardanates evenly distrobuted throuout area.
x = Range_min:Resolution:Range_max;                                         % [low lim : resalution : up lim]
y = Range_min:Resolution:Range_max;
[X,Y] = meshgrid(x,y);

F.Method = 'natural';                                                       % Defines how interpolation is made between points...
Value = F(X,Y);                                                             % Maps each coardanate with a Value

%% Plots
% 3d "surface" plot
figure;
surf(X,Y,Value,'edgecolor','none');
% Labels
xlabel('X','fontweight','b');
ylabel('Y','fontweight','b'); 
zlabel('Value - V','fontweight','b');
title('Natural neighbor Interpolation Method','fontweight','b');

% Heatmaps
% Raw
figure;
Raw_Heat_map = heatmap(Raw_Heatmap_Data);
Raw_Heat_map.GridVisible = 'off';                                           % Remove gridlines
colormap('jet');                                                            % Set colour scale 'jet'= clearest for humans

% Interpolated
figure;
Int_Heat_map = heatmap(X(1,:),Y(:,1),Value);
Int_Heat_map.GridVisible = 'off';                                           % Remove gridlines
Int_Heat_map.ColorbarVisible = 'off';                                           % Remove colour bar
Int_Heat_map.FontColor = 'none';
Int_Heat_map.ColorLimits = [-max(abs(Value(:))) max(abs(Value(:)))];
colormap('jet');                                                            % Set colour scale 'jet'= clearest for humans

%% repeat???
% for latter versions...

