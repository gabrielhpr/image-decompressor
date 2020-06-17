clc
addpath(pwd)

function res = calculateError(originalImg, decompressedImg)
  orig_img = imread(originalImg);
  dec_img = imread(decompressedImg);
  [H,W,dim] = size(dec_img);
  
  %% Converte as imagens lidas para uma matriz double %%
  if(strcmp(typeinfo(orig_img),"uint8 matrix") == 1)
    orig_img = double(orig_img)/255.0;
  elseif (strcmp(typeinfo(orig_img),"uint16 matrix") == 1)
    orig_img = double(orig_img)/65535.0;
  endif

  if(strcmp(typeinfo(dec_img),"uint8 matrix") == 1)
    dec_img = double(dec_img)/255.0;
  elseif (strcmp(typeinfo(dec_img),"uint16 matrix") == 1)
    dec_img = double(dec_img)/65535.0;
  endif
  
  %% Calcula a diferença entre as duas matrizes %%
  for i = 1 : H
    for j = 1 : W
       dif(i,j,1:dim) = orig_img(i,j,1:dim) - dec_img(i,j,1:dim);
    endfor
  endfor
  
  errR = norm(dif(:,:,1),2)/norm(orig_img(:,:,1), 2);
  errG = 0;
  errB = 0;
  
  if(dim > 1)
    errG = norm(dif(:,:,2), 2)/norm(orig_img(:,:,2), 2);
    errB = norm(dif(:,:,3), 2)/norm(orig_img(:,:,3), 2);
    res = (errR + errG + errB) / 3;
  else
    res = errR;
  endif
  
endfunction
