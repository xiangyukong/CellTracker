function mergeMultipleMontageDirectories(directory1,directory2,dims,chans,outdir,alignchans)

max_imgs = prod(dims);

if ~exist(outdir,'dir')
    mkdir(outdir);
end


for ii = 1:max_imgs
    col = mod(ii-1,dims(1))+1;
    row = floor((ii - col)/dims(1))+1;
    
    imgnow1 = maxIntensityLSMMontage(directory1{1},ii);
    for kk = 2:length(directory1)
        imgnow1 = cat(3,imgnow1,maxIntensityLSMMontage(directory1{kk},ii));
    end
    
    imgnow2 = maxIntensityLSMMontage(directory2{1},ii);
    for kk = 2:length(directory2)
        imgnow2 = cat(3,imgnow2,maxIntensityLSMMontage(directory2{kk},ii));
    end
    
    fi = registerTwoImages(imgnow1,imgnow2,chans,true);
    
    posstr = int2str(ii);
    while length(posstr) < 4
        posstr = ['0' posstr];
    end
    
    all_imgs{row,col}=fi;
    writeMultichannel(fi,fullfile(outdir,['merge_f' posstr '.tif']));
    
end

if exist('alignchans','var')
    si = size(all_imgs);
    all_si_c = cellfun(@size,all_imgs,'UniformOutput',false);
    all_si = cell2mat(all_si_c);
    im_max_size = [max(max(all_si(:,[1 3 5 7]))) max(max(all_si(:,[2 4 6 8])))];
    toAlign = cell(dims);
    for ii=1:si(1)
        for jj = 1:si(2)    
            toAlign{ii,jj} = max(all_imgs{ii,jj}(:,:,alignchans),[],3);
        end
    end
    [ac, fi]=alignManyImages(toAlign,200);
    for kk = 1:size(all_imgs{1,1},3)
        for ii=1:si(1)
            for jj = 1:si(2)
                toAlign{ii,jj} = max(all_imgs{ii,jj}(:,:,kk));
            end
        end
        [~,fi]=alignManyImages(toAlign,200,ac);
        imwrite(fi,fullfile(outdir,['montage_c' int2str(kk) '.tif']));
    end
    
end


