%% Question 1
%
% Ce code g�n�re un jeu de donn�es en forme de grille d'�chec et l'affiche.

n = 500;
sigma=1.4;
[Xapp,yapp,Xtest ,ytest]=dataset_KM('checkers',n,n^2 ,sigma) ;
[n,p] = size(Xapp) ;
figure(1) ;
clf;
set(gcf,'Color',[1 ,1 ,1])
hold on
h1=plot(Xapp(yapp==1 ,1) ,Xapp(yapp==1 ,2) , '+r') ;
set(h1,'LineWidth',2) ;
h2=plot(Xapp(yapp== -1 ,1) ,Xapp(yapp== -1 ,2) ,'db') ;
set(h2,'LineWidth',2) ;

%% Question 2
%
% On calcule le kernel gaussien manuellement puis avec la fonction
% |svmkernel|. On notera le param�tre |kerneloption| qui est l'�cart type
% dans la formule du kernel gaussien.

% Compute the same gaussian kernel using the svmkernel function of the
% SVMKM toolbox
kernel = 'gaussian';
kerneloption = .05;
K=svmkernel(Xapp, kernel, kerneloption);
G = (yapp*yapp') .* K;

%% 2.d
%
% On r�soud cette fois le probl�me avec le solveur de probl�me quadratique
% |monqp|

e = ones(n,1);
C = 10000;
lambda = eps^.5;
[alpha ,b,pos] = monqp(G,e,yapp ,0 ,C,lambda ,0) ;

%% Question 3
%
% Affichage du r�sultat avec un |meshgrid|

[xtest1 xtest2] = meshgrid([ -1:.01:1]*3 ,[ -1:0.01:1]*3) ;

nn = length(xtest1);
Xgrid = [reshape(xtest1, nn*nn,1) reshape(xtest2 ,nn*nn,1) ];
Kgrid = svmkernel(Xgrid ,kernel ,kerneloption ,Xapp(pos ,:) ) ;
ypred = Kgrid*(yapp(pos) .*alpha) + b;
ypred = reshape(ypred,nn,nn);
contourf(xtest1 ,xtest2 ,ypred ,50) ; shading flat;
hold on;
[cc,hh]=contour(xtest1 ,xtest2 ,ypred ,[ -1 0 1] , 'k') ;
clabel(cc,hh) ;
set(hh, 'LineWidth', 2) ;
h1=plot(Xapp(yapp==1 ,1), Xapp(yapp==1 ,2) , '+r' , 'LineWidth' ,2) ;
h2=plot(Xapp(yapp== -1 ,1) ,Xapp(yapp== -1 ,2) , 'db' , 'LineWidth' ,2) ;
xsup = Xapp(pos ,:) ;
h3=plot(xsup(: ,1) ,xsup(: ,2) , 'ok', 'LineWidth',2) ;
axis([ -3 3 -3 3]) ;

%%
%
% On voit que la /bandwidth/ r�gle bien la dispersion des donn�es donnant
% des classes plus petites (et plus vraiment repr�sentatives de la
% ditsribution des donn�es).



