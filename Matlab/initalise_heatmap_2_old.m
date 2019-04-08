%% varables
Resolution = 0.1;
Range_min = 0;
Range_max = 10;
SD_min = 1;
SD_max = 5;
Number_of_Hotspots = 2;
Mat_Size = (((Range_max-Range_min)*(1/Resolution))+1)^2;
out = zeros(Mat_Size,1);
% size(test)

%% old
% %% random number genarators
% Pos_X_1 = randi([Range_min Range_max],1);
% Pos_X_2 = randi([Range_min Range_max],1);
% Pos_Y_1 = randi([Range_min Range_max],1);
% Pos_Y_2 = randi([Range_min Range_max],1);
% Shape_X_1 = randi([SD_min SD_max],1);
% Shape_X_2 = randi([SD_min SD_max],1);
% Shape_Y_1 = randi([SD_min SD_max],1);
% Shape_Y_2 = randi([SD_min SD_max],1);
% 
%% hot spots info
mu1 = [9 9];                            % posision [X Y]
Sigma1 = [1 .3; .3 3];                  % shape [(width of x) (?) ; (?) (width of y)]

mu2 = [5 5];                            % posision [X Y]
Sigma2 = [3 .3; .3 3];                  % shape [(width of x) (?) ; (?) (width of y)]
% 
% Pos_1 = [Pos_X_1 Pos_Y_1];
% Shape_1 = [Shape_X_1 .3; .3 Shape_Y_1];
% 
% Pos_2 = [Pos_X_2 Pos_Y_2];
% Shape_2 = [Shape_X_2 .3; .3 Shape_Y_2];

%% Range???
x = Range_min:Resolution:Range_max;     % [low lim : resalution : up lim]
y = Range_min:Resolution:Range_max;

%%
[X,Y] = meshgrid(x,y);                  % ???

%% slect number of hotspots on map...
% F1 = mvnpdf([X(:) Y(:)],mu1,Sigma1);    % tall
% 
% size(F1)
% out = zeros(size(F1));
% for a=1:Number_of_Hotspots
%     % random
%     Pos_X = randi([Range_min Range_max],1);
%     Pos_Y = randi([Range_min Range_max],1);
%     Shape_X = randi([SD_min SD_max],1);
%     Shape_Y = randi([SD_min SD_max],1);
%     Pos = [Pos_X Pos_Y];
%     Shape = [Shape_X .3; .3 Shape_Y];
%     
%     % make hotspot
%     test = mvnpdf([X(:) Y(:)],Pos,Shape);
%     out = out + test;
% end

%% hot spots
% inital functions
F1 = mvnpdf([X(:) Y(:)],mu1,Sigma1);    % tall
F2 = mvnpdf([X(:) Y(:)],mu2,Sigma2);    % wide

out = F1 + F2;                            % add a number (2) of "hotspots"  (check how merge???)
% 
% % actual hotspots
% H1 = mvnpdf([X(:) Y(:)],Pos_1,Shape_1);
% H2 = mvnpdf([X(:) Y(:)],Pos_2,Shape_2);
% 
% H = H1 + H2;

% test
Hot_Spots = out;

%% reeshape???
Hot_Spots = reshape(Hot_Spots,length(y),length(x));


%% plots
% 3d
figure;
Surf_plot = surf(x,y,Hot_Spots);
set(Surf_plot,'edgecolor','none');
caxis([min(Hot_Spots(:))-.5*range(Hot_Spots(:)),max(Hot_Spots(:))]);
%axis([0 10 0 10 0 .1])

% lable
xlabel('X');
ylabel('Y');
zlabel('Probability Density');


% heatmap
figure;
Heat_map = heatmap(Hot_Spots);
Heat_map.GridVisible = 'off';
colormap('jet');

