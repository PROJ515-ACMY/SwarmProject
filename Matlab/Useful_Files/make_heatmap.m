%% Varables
Resolution_decimal_place = 2;                                               % 0-3 how many dp you want the data set to
loop = 1;

f1 = figure('Name','Surface Plot','NumberTitle','off');
f2 = figure('Name','Raw Heatmap','NumberTitle','off');
f3 = figure('Name','Heatmap','NumberTitle','off');

filename_1 = 'Current_Data.txt';                                            % CSV x,y,v x,y= copradanates v= value
filename_2 = 'Start_Stopped.txt';

%% Poll start stop file so know when to start.
while loop == 1
    
    % Read file
    [Start, Last, ~, filename_1] = textread(filename_2, '%d %d %d %s');
    filename_1 = char(filename_1);

    if Last == 1
        % Exit waiting to begin loop
        loop = 0;
    end
    
end

%% Read file
File_Data_1 = csvread(filename_1);

%% Alter the argos data to work with matlab
% Set the Resolution values
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

% Work out a small offset
x_off = abs(min(File_Data_1(:,1))) + Resolution;
y_off = abs(min(File_Data_1(:,2))) + Resolution;

% Change from range -X,Y to 0,X+a small offset (as doesnt like 0)
File_Data_1(:,2) = (File_Data_1(:,2) + y_off);
File_Data_1(:,1) = (File_Data_1(:,1) + x_off);

% Round data to resaloution required
File_Data_1(:,2) = round(File_Data_1(:,2), Resolution_decimal_place);
File_Data_1(:,1) = round(File_Data_1(:,1), Resolution_decimal_place);

% Change data from float to int
File_Data_1(:,2) = File_Data_1(:,2) * Multiplier;
File_Data_1(:,1) = File_Data_1(:,1) * Multiplier;

% Fix remaining floats that refuse to be ints??? (15.000000)
File_Data_1(:,2) = fix(File_Data_1(:,2));
File_Data_1(:,1) = fix(File_Data_1(:,1));

% Area whitch has been sampeled
Range_min_X = min(File_Data_1(:,1));
Range_max_X = max(File_Data_1(:,1));
Range_min_Y = min(File_Data_1(:,2));
Range_max_Y = max(File_Data_1(:,2));

%% Make raw heatmap
Raw_Heatmap_Data = zeros(Range_max_Y,Range_max_X);

% Rearange data
Raw_Heatmap_Data(sub2ind(size(Raw_Heatmap_Data),(File_Data_1(:,2)),(File_Data_1(:,1)))) = File_Data_1(:,3);

%% Interpolate
F = scatteredInterpolant(File_Data_1(:,1),File_Data_1(:,2),File_Data_1(:,3));     % Interpolate???
F.Method = 'natural';                                                       % Defines how interpolation is made between points...

% Get a set of coardanates evenly distrobuted throuout area.
x = Range_min_X:1:Range_max_X;                                              % [low lim : Resolution : up lim]
y = Range_min_Y:1:Range_max_Y;
[X,Y] = meshgrid(x,y);

% Work out a "Value" for each coardanate
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

%% Tell argos mapping is finished
Finish = 1;
File_Data_2 = [Start, Last, Finish, filename_1];

% Write over file
fileID = fopen(filename_2, 'w');
fprintf(fileID, '%d %d %d %s', File_Data_2);
fclose(fileID);

