% fstretch --- FFT-based signal interpolation

xf=1:10;
yf=xf.^2+5*xf+2;


% Original data are (x1, y1). x1 is assumed to be uniformly spaced.
% (but note that only x1(1) and x1(n) are used).
% N2 is the size of the interpolated grid.
% y2 is the new (interpolated) y values.
% x2 is corresponding the new set of x values.

N1 = length(yf);
N2=N1*10;

% Construct the new x-axis, x2
dx1 = (xf(N1) - xf(1))/(N1-1);
period = N1*dx1; % Note that this is larger than x1(N1)-x1(1).
dx2 = period/N2; % New sampling interval.
x2 = xf(1) + (0:N2-1)*dx2; % New x-axis

% Detrend the data
slope = (yf(N1) - yf(1))/((N1-1)*dx1);
trend1 = slope * dx1 * (0:N1-1);
y1d = yf - trend1;
y1f = fft(y1d); % FFT of y1, which will supply parts for FFT of y2.

% Construct the FFT of the interpolated signal, y2
y2f = zeros(1,N2); % initialize blank FFT for y2
y2f(1:floor(N1/2+1)) = y1f(1:floor(N1/2+1));

% Frequencies 0 through Nyquist go to the first part of y2f.
y2f(N2-floor(N1/2-1):N2) = y1f(ceil(N1/2+1):N1);

% Frequencies from Nyquist to N go to the last part of y2f.
% In the case where N1 is odd, there is no element at Nyquist
% frequency; this case is handled above by floor() and ceil().

y2 = ifft((N2/N1)*y2f); % create y2 by the inverse transform.

% Reconstruct the original trend, rebinned for the newly interpolated
% data, and add it back in.
trend2 = slope * dx2 * (0:N2-1);
y2 = y2 + trend2; % Add the trend back in

figure()
hold on
scatter(x2,y2,'k')
scatter(xf,yf,'r')