clear;
clc;

seed = [1 0 1 1 1 0 1]; 
% this is the key(seed) which both transmitter and receiver know about
% tx uses it to scramble raw data
% rx uses it to descramble the received data(scrambled data)
scrambling_seq(1:864) = 0;
for i=1:864
   scrambling_seq(i) = xor(seed(1),seed(4));
   seed = [seed(2:7) scrambling_seq(i)];
end

fid = fopen('data.txt');
datachar = fgetl(fid);
data(1:864) = 0;
for i=1:864
    data(i) = datachar(i)-48;
end
fclose(fid);

scrambled_data(1:864) = 0;
for i=1:864
    scrambled_data(i) = xor(data(i),scrambling_seq(i));
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This is for writing to a file in matlab
 fid = fopen('scrambled_data.txt','wt');
 fprintf(fid,'%d',scrambled_data);
 fclose(fid);


%%%%%%%%%%%%%%%%%%%%%%%%result.txt is the output of wlanScramble() function%%%%%%%%%%%%%%%%%%%%%%
fid = fopen('result.txt');
datachar = fgetl(fid);
wlan(1:864) = 0;
for i=1:864
    wlan(i) = datachar(i)-48;
end
fclose(fid);

% compare the output of my code with the ready function of matlab
%diff = wlan - scrambled_data;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%NOW lets descramble the scrambled data (retrieve the data in receiver)%%%%%%%%%%%%%
% do it with the same key(seed)
descrambled_data(1:864) = 0;
for i=1:864
    descrambled_data(i) = xor(scrambled_data(i),scrambling_seq(i));
end

 isequal(descrambled_data,data);

 fid = fopen('descrambled_data.txt','wt');
 fprintf(fid,'%d',descrambled_data);
 fclose(fid);
%compare the descrambled data with the original data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
% output of testbench in verilog
fid = fopen('tb_out.txt');
datachar = fgetl(fid);
tb_out(1:864) = 0;
for i=1:864
    tb_out(i) = datachar(i)-48;
end
fclose(fid);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 99/10/11
% I made a mistake in the previous part, we do not know the seed in the
% receiver side, we have to obtain it!!!!

seed_rx(1:7) = 0;
seed_rx(1) = xor(xor(scrambled_data(1),scrambled_data(4)),xor(scrambled_data(7),scrambled_data(3)));
seed_rx(2) = xor(xor(scrambled_data(2),scrambled_data(5)),scrambled_data(1));
seed_rx(3) = xor(xor(scrambled_data(3),scrambled_data(6)),scrambled_data(2));
seed_rx(4) = xor(xor(scrambled_data(4),scrambled_data(7)),scrambled_data(3));
seed_rx(5) = xor(scrambled_data(5),scrambled_data(1));
seed_rx(6) = xor(scrambled_data(6),scrambled_data(2));
seed_rx(7) = xor(scrambled_data(7),scrambled_data(3));

%we retrieved the seed successfully!Now we can descramble!
scrambling_seq(1:864) = 0;
for i=1:864
   scrambling_seq(i) = xor(seed_rx(1),seed_rx(4));
   seed_rx = [seed_rx(2:7) scrambling_seq(i)];
end

descrambled_data(1:864) = 0;
for i=1:864
    descrambled_data(i) = xor(scrambled_data(i),scrambling_seq(i));
end

 isequal(descrambled_data,data)
