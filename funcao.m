clc
addpath(pwd)

function res = f(tam)
  for i = 1 : tam
    for j = 1 : tam
      x = i*j;
      y = i**2 + j**2;
      z = j**3;
      x = x/(10**5);
      y = y/(10**5);
      z = z/(10**7);
      res(i,j,1) = x;
      res(i,j,2) = y;
      res(i,j,3) = z;
    endfor
  endfor
  imwrite (res, "function.png","png",'Quality',100);
endfunction

function res = g(tam)
  for i = 1 : tam
    for j = 1 : tam
      x = sin(i);
      y = (sin(i) + sin(j))/2;
      z = sin(i);
      x = x/2 + 0.5;
      y = y/2 + 0.5;
      z = z/2 + 0.5;
      res(i,j,1) = x;
      res(i,j,2) = y;
      res(i,j,3) = z;
    endfor
  endfor
  imwrite(res,"function.png","png",'Quality',100);
  endfunction

function res = h(tam)
  for i = 1 : tam
    for j = 1 : tam
      x = sin(i+j);
      x = x/2 + 0.5;
      res(i,j) = x;
    endfor
  endfor
  imwrite(res,"function.png","png",'Quality',100);
endfunction

function res = a(tam)
  for i = 1 : tam
    for j = 1 : tam
      if i != 1
      x = (i**2) * sin(1/(i-1));
      else
        x = 0;
       endif
      x = x/tam;
      res(i,j) = x;
    endfor
  endfor
  imwrite(res,"function.png","png",'Quality',100);
endfunction
