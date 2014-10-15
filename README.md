#Splash
=======
#####Created at CalHacks
#####by Anksuh, Clayton, Elle, Long, and Rohan
#####On ChallengePost here: http://challengepost.com/software/splash
======
The internet may be ubiquitous, but networking is not a solved problem. With NSA spying, celeb nude leaks, and growing awareness of the limitations of ipv6, the last few years have brought much public attention to over-the-top layered protocols and even alternative nets.

Any mass gathering is a threat to internet stability. The Arab Spring brought to light the incredible power of Twitter during protests, and more recently FireChat's intranet helped fuel student involvement in Hong Kong. During protests, a government's ability to disable cell service and thus internet data can be debilitating and deadly.

Privacy also seems like a bigger concern now than ever. The Tor protocol has taken off as a way to get near-anonymity online, and despite its reputation for drugs has played an important part in securing civil liberties.

It also really sucks when wifi is down from mass usage at hackathons, and barely anyone can tether because the building is so packed.

So we created a one-to-one messaging platform based on Bluetooth Low Energy technology in our iPhones. It is fast, requires no wi-fi or cellular connection, and completely local. There is no NSA threat, because the messages never hit the internet. In large gathering, the intranet can be as big as the space the people occupy.

Each iPhone acts as a Bluetooth Low Energy node, and finds nearby nodes. While one phone may have a BLE range of 30 - 100 feet, our application lets them chain together to form a mesh. By creating a mesh network of phones, messages can bounce through multiple nodes to get to their recipient.
