clear all; clc;
on=1; off=0;

Movie = on;
PlotAll=on;
SaveFigure=off;

BarFontSize      = 20;
TitleFontSize    = 24;
load('plant.mat')

% FID=fopen('clSortedStones.dat', 'r');
% A=fread(FID, 3, 'int32');
A=size(P);
X=A(1);
Y=A(2);
Z=A(3);
EndTime=A(3);
Length=100;
% RecordTimes=fread(FID,EndTime+1,'double');
xWorldLimits=linspace(0,Length,X);
yWorldLimits=linspace(0,Length,Y);
popP=zeros(X,Y,'double');
popO=zeros(X,Y,'double');
% popW=zeros(X,Y,'double');

% Get Screen dimensions and set Main Window Dimensions
x = get(0,'ScreenSize'); ScreenDim=x(3:4);
MainWindowDim=floor(ScreenDim.*[0.9 0.8]);

if Movie==on,
    writerObj = VideoWriter('FCs_Turing_patterns.mp4', 'MPEG-4');
    open(writerObj);
end;

if PlotAll==on,
    MainWindowDim=[720*2 818];
else
    MainWindowDim=[720 720];
end;

% The graph window is initiated, with specified dimensions.
Figure1=figure('Position',[(ScreenDim-MainWindowDim)/2 MainWindowDim],...
               'Color', 'white');
% set(gca,'position',[0.1 0.1 .9 .9],'fontsize',BarFontSize);

if PlotAll==on, 
    subplot('position',[0.05 0.05 0.43 0.90]);
end;

F1=imagesc(xWorldLimits,yWorldLimits,popP',[0 4]);
title('Plant biomass (g/m^2)','FontSize',TitleFontSize);  
cbh=colorbar('SouthOutside','FontSize',BarFontSize); 
colormap('jet'); axis image; axis on;
cbh.Ticks = linspace(0, 4, 5) ; %cbh.TickLabels = num2cell(0:4) ;
% set(get(cbh,'Label'),'string','Phase separation model','Rotation',0.0);
set(gca,'fontsize',BarFontSize,'linewidth',3,'TickDir', 'out','box','off','YDir','normal');
xticks(0:20:100); yticks(0:20:100); %ytickangle(90)
% xticklabels({'0','50','100','150','200','250'})
% xtickformat('%0.0f'); ytickformat('%0.0f'); 

if PlotAll==on,
    subplot('position',[0.53 0.05 0.43 0.90]);
    F2=imagesc(xWorldLimits,yWorldLimits,popO',[0.1 0.2]);
    title('Sulfide (uM)','FontSize',TitleFontSize);  
    cbh2=colorbar('SouthOutside','FontSize',BarFontSize);
    axis image; axis on;
    cbh2.Ticks = linspace(0.1, 0.2, 6) ; %cbh.TickLabels = num2cell(0:4) ;
    % set(get(cbh,'Label'),'string','Phase separation model','Rotation',0.0);
    set(gca,'fontsize',BarFontSize,'linewidth',3,'TickDir', 'out','box','off','YDir','normal');
    xticks(0:20:100); yticks(0:20:100); %ytickangle(90)
    % xticklabels({'0','50','100','150','200','250'})
    % xtickformat('%0.0f'); ytickformat('%0.0f'); 

%     subplot('position',[0.68 0 0.30 0.95]);
%     F3=imagesc(popW',[0 10]);
%     title('Soil water (mm)','FontSize',TitleFontSize);    
%     colorbar('SouthOutside','FontSize',BarFontSize);
%     axis image; axis off;  
end
MassS=zeros(EndTime,2);

for x=1:Z,
%     popP=reshape(fread(FID,X*Y,'float32'),X,Y);
%     popO=reshape(fread(FID,X*Y,'float32'),X,Y);
    popP=P(:,:,x);
    popO=S(:,:,x);
%     popW=reshape(fread(FID,X*Y,'float32'),X,Y);

    set(F1,'CData',popP');
    if PlotAll==on,
        set(F2,'CData',popO');
%         set(F3,'CData',popW');  
    end; 
    set(Figure1,'Name',['Timestep ' num2str(x/Z*EndTime) ' of ' num2str(EndTime)]); 
    if ~exist('Images')
        mkdir('Images');
    end
    if mod(x,10)==0 && SaveFigure
        save2pdf(sprintf('Images/Patterns_%04.0f',x),gcf,600);
    end
    
    
    
    drawnow; 
    
    if Movie==on,
         frame = getframe(Figure1);
         writeVideo(writerObj,frame);
    end

end;

% fclose(FID);

if Movie==on,
    close(writerObj);
end;

disp('Done');beep;

[min(popP(:)) max(popP(:))]
[min(popO(:)) max(popO(:))]


% save2pdf(strcat('Patterns_Test1'),gcf,600);