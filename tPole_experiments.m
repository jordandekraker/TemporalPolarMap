clear all; close all;
addpath(genpath('.'));


makeGif = true;
gifname = 'TPconformalMap.gif';
maxdist = 50;
load('FastDiskConformalMap/human_brain.mat');


% flip (easier to work with)
v = v(:,[2 1 3]);

% find temporal apex (heauristically - most anterior point below y=-15)
TL = find(v(:,3)<-15);
[m,i] = max(v(TL,1));
antPole = TL(i);
dist = perform_fast_marching_mesh(v,f,antPole);

if makeGif
fig = figure;
p1 = patch('faces',f,'vertices',v);
axis equal tight;
p1.FaceVertexCData = dist;
p1.FaceColor = 'flat';
p1.LineStyle = 'none';
title('Geodesic distance from temporal apex');
view(180,0);
material dull;
light;
drawnow;
frame = getframe(1);
im = frame2im(frame);
[imind,cm] = rgb2ind(im,256);
imwrite(imind,cm,gifname,'gif','DelayTime',2, 'Loopcount',inf);
xl = xlim;
yl = ylim;
zl = zlim;
end

% get only area around apex
rm = sort(find(dist>maxdist),'descend');
v2 = v; f2 = f;
for s = 1:length(rm)
    r = rm(s);
    v2(r,:) = [];
    f2(any(f2==r,2),:) = [];
    f2(f2>r) = f2(f2>r)-1;
end
dist(rm) = [];
mean_curv(rm) = [];

if makeGif
fig2 = figure;
p = patch('faces',f2,'vertices',v2);
axis equal tight;
drawnow;
xl2 = xlim;
yl2 = ylim;
zl2 = zlim;
close;
fig;
for n = 1:90
    fraction = n/90;
    p1.FaceAlpha = 1-fraction;
    xlim(xl2*fraction + xl*(1-fraction));
    ylim(yl2*fraction + yl*(1-fraction));
    zlim(zl2*fraction + zl*(1-fraction));
    view(90*fraction + 180*(1-fraction),0);
    p2 = patch('faces',f2,'vertices',v2);
    p2.FaceVertexCData = dist;
    p2.FaceColor = 'flat';
    p2.LineStyle = 'none';
    material dull;
    title('50mm distance from temporal apex');
    
    frame = getframe(1);
    im = frame2im(frame);
    [imind,cm] = rgb2ind(im,256);
    imwrite(imind,cm,gifname,'gif','DelayTime',1/30,'WriteMode','append');
end
imwrite(imind,cm,gifname,'gif','DelayTime',1,'WriteMode','append');
end


%% conformal map

% map to unfolded
map = disk_conformal_map(v2,f2);
map(:,3) = 0;
map = map(:,[3 2 1]);
map = map.*maxdist;

if makeGif
close all;
fig = figure;
p = patch('faces',f2,'vertices',v2);
p.FaceVertexCData = mean_curv;
p.FaceColor = 'flat';
p.LineStyle = 'none';
axis equal tight;
view(90,0);
light;
material dull;
drawnow;
title('Temporal pole mean curvature (for visualization)');
frame = getframe(1);
im = frame2im(frame);
[imind,cm] = rgb2ind(im,256);
imwrite(imind,cm,gifname,'gif','DelayTime',2,'WriteMode','append');
    
for n = 1:90
    cla;
    fraction = n/90;
    vmid = map.*fraction + v2.*(1-fraction);
    
    p = patch('faces',f2,'vertices',vmid);
    p.FaceVertexCData = mean_curv;
    p.FaceColor = 'flat';
    p.LineStyle = 'none';
    axis equal tight;
    view(90,0);
    light;
    material dull;
    title('Conformal mapping to disk (Choi et al., 2015)');
    drawnow;
    frame = getframe(1);
    im = frame2im(frame);
    [imind,cm] = rgb2ind(im,256);
    imwrite(imind,cm,gifname,'gif','DelayTime',1/30,'WriteMode','append');
end
imwrite(imind,cm,gifname,'gif','DelayTime',2,'WriteMode','append');
end