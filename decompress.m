
clc
addpath(pwd)

function res = f(x,y)
  res = x**3 + y**3;
endfunction

#interpolacao bilinear

#Calcula os coeficientes do polinomio interpolador do respectivo quadrado
function res = eval_coef_bl(h,data,dim,M)
  
  F = [data(1,1,1:dim);
       data(1,2,1:dim);
       data(2,1,1:dim);
       data(2,2,1:dim)];
 
  res = M \ F;
endfunction

function res = eval_p_bl(x,y,xi,yj,coef,dim)
  for j=1 : dim
    value = coef(1,j) + coef(2,j)*(x-xi) + coef(3,j)*(y-yj) + coef(4,j)*(x-xi)*(y-yj);
    res(j) = value;
  endfor
endfunction

#######################

#interpolacao bicubica


function res = eval_coef_bb(xi,yj,img,h,H,W,dim,B)
  
  F = [img(xi,yj,1:dim), img(xi,yj+1,1:dim), ay(xi,yj,img,h,W,dim), ay(xi,yj+1,img,h,W,dim);
       img(xi+1,yj,1:dim), img(xi+1,yj+1,1:dim), ay(xi+1,yj,img,h,W,dim), ay(xi+1,yj+1,img,h,W,dim);
       ax(xi,yj,img,h,H,dim), ax(xi,yj+1,img,h,H,dim), ax_ay(xi,yj,img,h,H,W,dim), ax_ay(xi,yj+1,img,h,H,W,dim);
       ax(xi+1,yj,img,h,H,dim), ax(xi+1,yj+1,img,h,H,dim), ax_ay(xi+1,yj,img,h,H,W,dim), ax_ay(xi+1,yj+1,img,h,H,W,dim)];
  
  
  BT = B';
  for i = 1: dim 
    res(:,:,i) = inv(B)*F(:,:,i)*inv(BT);
  endfor
  

endfunction

function res = ax(xi,yj,img,h,H,dim)  
  if xi == 1
    res = ( img(2,yj,1:dim) - img(1,yj,1:dim) )/h;
  elseif xi == H
    res = ( img (H,yj,1:dim) - img(H-1,yj,1:dim) )/h;
  else
    res = ( img(xi+1,yj,1:dim) - img(xi-1,yj,1:dim) )/(2*h);
  endif
endfunction

function res = ay(xi,yj,img,h,W,dim)  
  if yj == 1
    res = ( img(xi,2,1:dim) - img(xi,1,1:dim) )/h;
  elseif yj == W
    res = ( img(xi,W,1:dim) - img(xi,W-1,1:dim) )/h;
  else
    res = ( img(xi,yj+1,1:dim) - img(xi,yj-1,1:dim) )/(2*h);
  endif
endfunction

function res = ax_ay(xi,yj,img,h,H,W,dim)  
  if xi == 1
    res = (ay(2,yj,img,h,W,dim) - ay(1,yj,img,h,W,dim))/h;
  elseif xi == H
    res = (ay(H,yj,img,h,W,dim) - ay(H-1,yj,img,h,W,dim) )/h;
  else
    res = ( ay(xi+1,yj,img,h,W,dim) - ay(xi-1,yj,img,h,W,dim) )/(2*h);
  endif
endfunction


function res = eval_p_bb(x,y,xi,yj,coef,dim)
  X = [1, x-xi, (x-xi)**2, (x-xi)**3];
  Y = [ 1;
        y-yj;
        (y-yj)**2;
        (y-yj)**3];
  for i = 1 : dim
    res(i) = X * coef(:,:,i) * Y;
  endfor
endfunction

function res = decompress(compressedImg, method, k, h)
  img = imread(compressedImg);
  typeinfo(img)
  if(strcmp(typeinfo(img),"uint8 matrix") == 1)
    img = double(img)/255.0;
  elseif (strcmp(typeinfo(img),"uint16 matrix") == 1)
    img = double(img)/65535.0;
  endif
  [H,W,dim] = size(img)
  tam = H + (H-1)*k
  if method == 1
    printf("bilinear\n")
    M = [1, 0, 0, 0;
        1, 0, h, 0;
        1, h, 0, 0;
        1, h, h, h*h];
  
    data = zeros(2,2,1:dim);
    for i = 1 : H-1
      for j =1 : W-1
        
        data(1,1,1:dim) = img(i,j,1:dim);
        data(1,2,1:dim) = img(i,j+1,1:dim);
        data(2,1,1:dim) = img(i+1,j,1:dim);
        data(2,2,1:dim) = img(i+1,j+1,1:dim);
      
        coef = eval_coef_bl(h,data,dim,M);
  
      idx = 0;
      for ix = k*i - k + i  : i*(k+1) + 1
        x = i + idx*h/(k+1);
        idy = 0;
        for jy = k*j - k + j : j*(k+1) + 1
          y = j + idy*h/(k+1);
          
          res(ix,jy,1:dim) = eval_p_bl(x,y,i,j,coef,dim);
          
        idy++;
        endfor
        idx++;
      endfor
        
      endfor
      
    endfor
else
  printf("bicubico\n")
  B = [1, 0, 0, 0;
       1, h, h*h, h*h*h;
       0, 1, 0, 0;
       0, 1, 2*h, 3*h*h];
       
  for i = 1 : H-1
    for j =1 : W-1
      
 
   coef = eval_coef_bb(i,j,img,h,H,W,dim,B);
   idx = 0;
    for ix = k*i - k + i  : i*(k+1) + 1
      x = i + idx*h/(k+1);
      idy = 0;
      for jy = k*j - k + j : j*(k+1) + 1
        y = j + idy*h/(k+1);
        
        res(ix,jy,1:dim) = eval_p_bb(x,y,i,j,coef,dim);
        
       idy++;
      endfor
      idx++;
    endfor
      
    endfor
    
  endfor
endif

imwrite(res, "decompressed.png","png",'Quality',100);

endfunction


function resp = im_teste()
red = [0.30, 0.12; 0.15, 0.7];
green = [0.20, 0.61; 0.90, 0.83];
blue = [0.53, 0.33; 0.14, 0.65];
resp = cat(3, red, green, blue);
endfunction
