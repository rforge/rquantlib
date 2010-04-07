#!/usr/bin/r

text <- "
Date, Version, Size, Comment
24 Feb 2010,  1.0,    3.6,
11 Nov 2009,  0.9.9,  3.6,
18 Nov 2008,  0.9.7,  3.4,
06 Aug 2008,  0.9.6,  3.2,
30 Jul 2008,  0.9.5, ,
24 Dec 2007,  0.9.0,  3.0,
04 Jun 2007,  0.8.1,  2.1,
30 May 2007,  0.8.0,  2.1,
20 Feb 2007,  0.4.0,  1.9,
06 Nov 2006,  0.3.14, 1.9,
31 Jul 2006,  0.3.13, 1.7,
27 Mar 2006,  0.3.12, 1.7,
20 Oct 2005,  0.3.11, 1.6,
14 Jul 2005,  0.3.10, 1.5,
02 May 2005,  0.3.9, 1.5,
22 Dec 2004,  0.3.8, 1.5,
23 Jul 2004,  0.3.7, 1.4,  1st QL with Boost
15 Apr 2004,  0.3.6, 1.3,
31 Mar 2004,  0.3.5, ,
12 Nov 2003,  0.3.4, 1.2,
03 Sep 2003,  0.3.3, 1.1,
04 Feb 2003,  0.3.1, 0.8284,
06 May 2002,  0.3.0, 0.7297,
03 Dec 2001,  0.2.1, 0.6107, (first RQuantLib Feb 2002)
18 Sep 2001,  0.2.0, 0.5497,
31 May 2001,  0.1.9, 0.2856, 1st QL Debian package
21 Nov 2000,  0.1.1, 0.1010,
"

con <- textConnection(text)
ql <- read.csv(con)
close(con)

ql$Date <- as.Date(ql$Date, "%d %b %Y")

overplot <- c(4,7,18)  # skip these

#plot(ql$Date, rep(0, nrow(ql)), type='n', xlim=range(ql$Date), ylim=c(-1,1), ylab="", yaxt="n")
#text(ql[-overplot, "Date"], 0, labels=ql[-overplot,"Version"], srt=90, cex=0.75)
#text(ql[overplot, "Date"], 0.5, labels=ql[overplot,"Version"], srt=90, cex=0.75)

pdf("qlReleases.pdf", 8, 8)
oldpar <- par(mar=c(3,5,8,1))
plot(ql$Date, ql$Size, xlim=range(ql$Date), ylab="", yaxt="n", pch=16, type='b')
axis(3, ql[-overplot, "Date"], label=ql[-overplot, "Version"], line=0, las=2, cex=0.5)
axis(2, ql[-overplot, "Size"], label=format(ql[-overplot, "Size"], digit=2), line=0, las=1, cex=0.5)
title(main="Growth of QuantLib code over its initial decade:\n From version 0.1.1 in Nov 2000 to 1.0 in Feb 2010", line=4)
mtext("Release size in mb", side=2, line=4)
par(oldpar)
dev.off()

