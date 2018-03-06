% Register RFP and GFP channels
figure; 
subplot(1,2,1); imshowpair(imagelist_g{1,1}, imagelist_r{1,1});
image_registration_tform; 
subplot(1,2,2); imshowpair(imagelist_g{1,1}, imagelist_r{1,1});