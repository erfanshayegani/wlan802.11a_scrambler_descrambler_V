psdu="This is Erfanshaigani, a senior student of electrical engineering at Sharif university of technology"
service = "0000000000000000"
tail = "000000"
pad = "000000000000000000000000000000000000000000"
string = psdu;

psdu = ''.join(format(ord(i), '08b') for i in psdu) #convert it to binary bits string

data = service + psdu + tail + pad
# now this is the data needs to be scrambled!

# 16 0 service bits
# 800 psdu bits
# 6 0 tail bits
# 42 0 pad bits

f = open("data.txt", "w")
f.write(data)
f.close()

