# cipher-scan.sh

A script that uses openssl to scan for different Ciphers available on a TLS/SSL secured service

I found myself in need of a simple tool run against a specific server / port while remediating a large number of servers and services. 
This script will connect to any SSL/TLS service like WWW/Email/LDAPS and so on.

It requires OpenSSL and coreutils packages to be installed. ( OpenSSL for openssl s_client, coreutils for the timeout command )

NOTE: Your version of Openssl must support the cipher you want to scan. So if you are looking for RC4 or MD5 ciphers, your version of openssl needs to support it.

Usage:

![Screenshot 2023-11-17 at 05 23 01](https://github.com/geek4unix/ssl-cipher-scan/assets/6726149/f278ce5f-0786-4a76-b599-3daeedb967b8)

*Examples*

Test a single Cipher:

![Screenshot 2023-11-17 at 05 27 42](https://github.com/geek4unix/ssl-cipher-scan/assets/6726149/566747ec-7203-4ee3-befe-b04375f879e0)

Test any SHA256 cipher available:

![Screenshot 2023-11-17 at 05 28 36](https://github.com/geek4unix/ssl-cipher-scan/assets/6726149/1f399971-15a5-42f2-b319-b0737208d946)
