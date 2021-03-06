function [y] = window_re(x)

  %This funtions creates a zeros matrix and places the rectangular window
  %centered in the middle. It returns the correct result only for ACF.

  L = length(x);
  w = zeros(1, L);
  w(1, ceil((L-65)/2):floor((L+65)/2)) = window(@rectwin,65);

  y = x.*w;

end
