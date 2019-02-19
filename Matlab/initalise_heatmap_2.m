
mu1 = [2 2];                            % posision [x1 x2]
Sigma1 = [1 .3; .3 3];                  % shape [(width of x1) (?) ; (?) (width of x2)]

mu2 = [7 5];                            % posision [x1 x2]
Sigma2 = [3 .3; .3 3];                  % shape [(width of x1) (?) ; (?) (width of x2)]

x1 = 0:.2:10; x2 = 0:.2:10;
[X1,X2] = meshgrid(x1,x2);

F1 = mvnpdf([X1(:) X2(:)],mu1,Sigma1);  % tall
F2 = mvnpdf([X1(:) X2(:)],mu2,Sigma2);  % fat

F = F1 + F2;                            % add a number (2) of "hotstops"  (check how merge???)
F = reshape(F,length(x2),length(x1));

% plot
figure;
surf(x1,x2,F);
caxis([min(F(:))-.5*range(F(:)),max(F(:))]);
axis([0 10 0 10 0 .1])
% lable
xlabel('x1');
ylabel('x2');
zlabel('Probability Density');

% heatmap???
figure;
h = heatmap(F);
h.GridVisible = 'off';
colormap('jet');
