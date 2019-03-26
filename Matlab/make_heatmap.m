%% Varables
Resolution = 0.1;
Range_min = 0;
Range_max = 10;
loop = 1;
File_Data_old = [0,0,0];

f1 = figure('Name','Surface Plot','NumberTitle','off');
f2 = figure('Name','Raw Heatmap','NumberTitle','off');
f3 = figure('Name','Heatmap','NumberTitle','off');

filename_1 = 'test.txt';                                                     % CSV x,y,v x,y= copradanates v= value
filename_2 = 'SS.txt';

%% Constants
Raw_Heatmap_Data = zeros(10*(1/Resolution));

%% poll start stop file
while loop == 1
    
    % read file
    File_Data_2 = csvread(filename_2);
    
    if File_Data_2(1,1) == 1
        % exit while loop
        loop = 0;
    end
    
end

%% Get data
% read file
File_Data_1 = csvread(filename_1);

% rearange data
Raw_Heatmap_Data(sub2ind(size(Raw_Heatmap_Data),(File_Data_1(:,2)*(1/Resolution)),(File_Data_1(:,1)*(1/Resolution)))) = File_Data_1(:,3);

%% Interpolate
F = scatteredInterpolant(File_Data_1(:,1),File_Data_1(:,2),File_Data_1(:,3));     % Interpolate???
F.Method = 'natural';                                                       % Defines how interpolation is made between points...

% Get a set of coardanates evenly distrobuted throuout area.
x = Range_min:Resolution:Range_max;                                         % [low lim : resalution : up lim]
y = Range_min:Resolution:Range_max;
[X,Y] = meshgrid(x,y);

Value = F(X,Y);                                                             % Maps each coardanate with a Value

%% Plots
% Heatmaps
% Raw
figure(f2);
Raw_Heat_map = heatmap(Raw_Heatmap_Data);
Raw_Heat_map.GridVisible = 'off';                                           % Remove gridlines
colormap('jet');                                                            % Set colour scale 'jet'= clearest for humans

% Interpolated
figure(f3);
Int_Heat_map = heatmap(X(1,:),Y(:,1),Value);
Int_Heat_map.GridVisible = 'off';                                           % Remove gridlines
Int_Heat_map.ColorbarVisible = 'off';                                           % Remove colour bar
Int_Heat_map.FontColor = 'none';
Int_Heat_map.ColorLimits = [0 max(abs(Value(:)))];  % change second to 1 when reading argos data...
colormap('jet');                                                            % Set colour scale 'jet'= clearest for humans

% 3d "surface" plot
figure(f1);
surf(X,Y,Value,'edgecolor','none');
% Labels
xlabel('X','fontweight','b');
ylabel('Y','fontweight','b');
zlabel('Value - V','fontweight','b');
title('Natural neighbor Interpolation Method','fontweight','b');

%% tell argos finished
File_Data_2(2,1) = 1;

% write file
fileID = fopen(filename_2, 'w');
fprintf(fileID, '%d\n', File_Data_2);
fclose(fileID);
% might need a pause to let argos close the file befor i can open here...

