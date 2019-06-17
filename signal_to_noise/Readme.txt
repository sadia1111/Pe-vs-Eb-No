Performance evaluation (Pe vs Eb/No) of baseband coded (5-repitation code) and uncoded signaling

The signals are then passed through a AWGN channel. At the receiver the signal is received distorted and noisy. 
The signal is then passed through a filter, whose job is to maximize the SNR, such a filter is called the matched filter.
Y(t)=r(t)?h(t) [convolving the received signal with the channel impulse]. A matched filter can be also deployed by using a correlator. Y(t)=?¦?r(t)*s(t)  dt ?.
So both will give similar result. After this a suitable threshold is selected (?=(a_1+a_2)/2) for demodulating the signal. 
Demodulated signal is then compared with the original signal to find error. The probability of error will lower as the Eb/No will increase

For the coded part repetitive code is used as the transmitted signal which means each bit is repeated 5 times. 
The bit energy of a single data bit is divided between physical bits after coding. The signal is then passed through a AWGN channel, matched filter and correlator. 
After the reception the decoding and error correction mechanism were used according to the major voting technique.