# wlan802.11a_scrambler_descrambler
synchronous data scrambler and descrambler synthesized on Spartan6 FPGA

This project implements both data scrambler and descrambler of Wlan802.11a standard for both RX and TX side.

Both Matlab and HDL codes are provided and also verified. a python script is also included to generate the PSDU field and also the DATA field of the PPDU frame as well as saving it in data.txt for us.

Scrambler scrambles the DATA field of the PPDU frame, prevents having long series of successive 0s or 1s, Descrambler at the receiving side descrambles the received data and gives us the first data we sent.

The initial seed you use to scramble the data playes an important role in descrambling the data which I have also explained it briefly in comments.
