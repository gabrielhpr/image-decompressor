clear
clc
addpath(pwd)

function resp = compress(originalImg, k)
  img = imread(originalImg);
  img_info = imfinfo(originalImg)
  [H,W,dim] = size(img)
  #Size of the new matrix
  n = (img_info.Height+k)/(1+k)
  
  h = 1;
  for i = 1 : H
    w = 1;
    if(mod(i,k+1) == 0)
      for j = 1 : W
        if(mod(j,k+1) == 0)
          M(h,w,1:dim) = img(i,j,1:dim);
          w++;
        endif
      endfor  
      h++;
    endif
  endfor
  
  imwrite (M, "compressed.png","png",'Quality',100);
  imgnova = imread("compressed.png");
  imshow(imgnova);
  imfinfo("compressed.png")
  resp = M;
  
endfunction