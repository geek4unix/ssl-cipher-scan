# cipher-scan.sh

A script that uses openssl to scan for different Ciphers available on a TLS/SSL secured service

I found myself in need of a simple tool run against a specific server / port while remediating a large number of servers and services. 
This script will connect to any SSL/TLS service like WWW/Email/LDAPS and so on.

It requires OpenSSL and coreutils packages to be installed. ( OpenSSL for openssl s_client, coreutils for the timeout command )

NOTE: Your version of Openssl must support the cipher you want to scan. So if you are looking for RC4 or MD5 ciphers, your version of openssl needs to support it.

Usage:


Examples:

