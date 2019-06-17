clear 
close all
clc
% signal generation
pulse_len= 100000;
signal=2*randi([0,1],1,pulse_len)-1; %generating +1 and -1 pulses
fs=10; %oversampling rate
s_s=zeros(1,pulse_len*fs);%oversampled signal
 
for i = 1:length(signal)
    for j = 1:fs
        s_s((i-1)*fs + j)= signal(i);
    end
end
% %AWGN channel
L=pulse_len*fs;
DBEb_No=0:6 ;
Eb_No=10.^(DBEb_No./10);
Eb=abs(signal).^2; %energy per bit
Po=fs*sum(signal.^2)/(pulse_len);
P_No=Po./Eb_No; %noise power
noise=zeros(length(DBEb_No),L); %Noise initialization
y=zeros(length(DBEb_No),L);%recieved signal initialization 

% Matched Filter
mf=zeros(length(DBEb_No),pulse_len); %Output of matched filter
mf_e=zeros(1,length(DBEb_No)); %Number of errored bits using matched filter
mf_r=zeros(1,length(DBEb_No)); %Erorr ratio using matched filter
m1=zeros(length(DBEb_No),pulse_len); %Signals detected from matched filter
for k=1:length(DBEb_No) %For each instance of Eb/N0
noise(k,:)=sqrt(P_No(k)/2).*randn(1,L); %Gaussian noise
y(k,:)= s_s+noise(k,:);%signal+AWGN
h=ones(1,fs); % Impulse response of matched filter
 for i=1:pulse_len
 match_filter=conv(h,y(k,((i-1)*fs+1):(fs*i))); %using matched filter
 mf(i)=match_filter(fs);
 end
 
 %signal detection
 
for p=1:pulse_len
if mf(p)>0
m1(k,p)=1;
else
m1(k,p)=-1;
end
end
[mf_e(k),mf_r(k)]=symerr(signal, m1(k,:));
end

semilogy(DBEb_No,mf_r,'-ro')
xlabel('Eb/No (dB)')
ylabel('Pe')
title('Pe vs Eb/No for Bipolar tranmission')
legend('Uncoded BPSK output','location', 'northeast')
grid
hold off;
