%% Varables
Resolution = 0.1;
Range_min = 0;
Range_max = 10;
SD_min = 1;
SD_max = 4;%0;
Number_of_Hotspots = 3;
Mat_Size = (((Range_max-Range_min)*(1/Resolution))+1)^2;
Hot_Spots = zeros(Mat_Size,1);

%% genarate a coradanate grid                   %Range???
x = Range_min:Resolution:Range_max;                                         % [low lim : resalution : up lim]
y = Range_min:Resolution:Range_max;

[X,Y] = meshgrid(x,y);                                                      % ???

%% Genarate selected number of hotspots
for a=1:Number_of_Hotspots
    %% Random number genarators
    Pos_X = randi([Range_min Range_max],1);
    Pos_Y = randi([Range_min Range_max],1);
    Shape_X = randi([SD_min SD_max],1);%/10;
    Shape_Y = randi([SD_min SD_max],1);%/10;
    
    Good_Bad = randi([1 2],1);                                                   % determin if the hotspot is of good or bad quilaty
    
    %% Hotspot info
    Pos = [Pos_X Pos_Y];
    Shape = [Shape_X .3; .3 Shape_Y];                                       % shape [(width of x) (?) ; (?) (width of y)]
    
    %% Make hotspots
    HotSpot = mvnpdf([X(:) Y(:)],Pos,Shape);
    if Good_Bad == 1
        Hot_Spots = Hot_Spots - HotSpot;
    else
        Hot_Spots = Hot_Spots + HotSpot;
    end
    
end

%% reshape???
Hot_Spots = reshape(Hot_Spots,length(y),length(x));

%%
% A = [1 9 -2; 8 4 -5; -11 0 5];
% MX = max(abs(A(:)))
% MN = min(A(:))
% MX = max(abs(Hot_Spots(:)));
% MN = min(Hot_Spots);


%% plots
% 3d "surface" plot
figure;
Surf_plot = surf(x,y,Hot_Spots);
set(Surf_plot,'edgecolor','none');                                          % Remove gridlines
caxis([min(Hot_Spots(:))-.5*range(Hot_Spots(:)),max(Hot_Spots(:))]);
% lables
xlabel('X');
ylabel('Y');
zlabel('Probability Density');


% heatmap
figure;
Heat_map = heatmap(Hot_Spots);
Heat_map.GridVisible = 'off';                                               % Remove gridlines
Heat_map.ColorbarVisible = 'off';                                           % Remove colour bar
% made lables invisable but dont think there is a way to get rid of the lables
Heat_map.FontColor = 'none';
Heat_map.ColorLimits = [-max(abs(Hot_Spots(:))) max(abs(Hot_Spots(:)))];
colormap('jet');                                                            % Set colour scale 'jet'= clearest for humans

