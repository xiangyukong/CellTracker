function cellsToDynColonies(matfile)

load(matfile,'cells');
nc = length(cells);

pts = zeros(nc,2);
for ii=1:nc
    pts(ii,:) = mean(cells(ii).position);
end

allinds=NewColoniesAW(pts);
ngroups = max(allinds);

%Make colony structure for the single cell algorythm
for ii=1:ngroups;
    cellstouse=allinds==ii;
    colonies(ii)=dynColony(cells(cellstouse));
end

save(matfile,'colonies','-append');