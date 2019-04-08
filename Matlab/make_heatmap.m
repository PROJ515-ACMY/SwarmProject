%% Varables
Resolution_decimal_place = 2;                                               % 0-3 how many dp you want the data set to
loop = 1;

f1 = figure('Name','Surface Plot','NumberTitle','off');
f2 = figure('Name','Raw Heatmap','NumberTitle','off');
f3 = figure('Name','Heatmap','NumberTitle','off');

filename_1 = 'Current_Data.txt';                                                     % CSV x,y,v x,y= copradanates v= value
filename_2 = 'Start_Stopped.txt';

%% poll start stop file
while loop == 1
    
    % read file
    File_Data_2 = csvread(filename_2);
    
    if File_Data_2(1,1) == 1
        % exit while loop
        loop = 0;
    end
    
end

%% read file
File_Data_1 = csvread(filename_1);

%% alter the data to work with matlab
% resolution...
if Resolution_decimal_place == 0
    Resolution = 1;
    Multiplier = 1;
elseif Resolution_decimal_place == 1
    Resolution = 0.1;
    Multiplier = 10;
elseif Resolution_decimal_place == 2
    Resolution = 0.01;
    Multiplier = 100;
elseif Resolution_decimal_place == 3
    Resolution = 0.001;
    Multiplier = 1000;
else
    Resolution_decimal_place = 2;
    Resolution = 0.01;
    Multiplier = 100;
end

% offsets...
x_off = abs(min(File_Data_1(:,1))) + Resolution;
y_off = abs(min(File_Data_1(:,2))) + Resolution;

% change from range -X,Y to 0,d+(X+a small amount (as doesnt like 0))
File_Data_1(:,2) = (File_Data_1(:,2) + y_off);
File_Data_1(:,1) = (File_Data_1(:,1) + x_off);

% round data to resaloution required
File_Data_1(:,2) = round(File_Data_1(:,2), Resolution_decimal_place);
File_Data_1(:,1) = round(File_Data_1(:,1), Resolution_decimal_place);

% change data from float to int...
File_Data_1(:,2) = File_Data_1(:,2) * Multiplier;
File_Data_1(:,1) = File_Data_1(:,1) * Multiplier;

% fix remaining floats that refuse to be ints??? (15.000000)
File_Data_1(:,2) = fix(File_Data_1(:,2));
File_Data_1(:,1) = fix(File_Data_1(:,1));

% area whitch has been sampeled
Range_min_X = min(File_Data_1(:,1));
Range_max_X = max(File_Data_1(:,1));
Range_min_Y = min(File_Data_1(:,2));
Range_max_Y = max(File_Data_1(:,2));

%% make raw heatmap
Raw_Heatmap_Data = zeros(Range_max_Y,Range_max_X);

% rearange data
Raw_Heatmap_Data(sub2ind(size(Raw_Heatmap_Data),(File_Data_1(:,2)),(File_Data_1(:,1)))) = File_Data_1(:,3);

%% Interpolate
F = scatteredInterpolant(File_Data_1(:,1),File_Data_1(:,2),File_Data_1(:,3));     % Interpolate???
F.Method = 'natural';                                                       % Defines how interpolation is made between points...

% Get a set of coardanates evenly distrobuted throuout area.
x = Range_min_X:1:Range_max_X;                                              % [low lim : Resolution : up lim]
y = Range_min_Y:1:Range_max_Y;
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
Int_Heat_map = heatmap(x,y,flip(Value));
Int_Heat_map.GridVisible = 'off';                                           % Remove gridlines
% Int_Heat_map.ColorbarVisible = 'off';                                     % Remove colour bar
% Int_Heat_map.FontColor = 'none';
Int_Heat_map.ColorLimits = [0 1];
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


