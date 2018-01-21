# rasterview-samples

Releases from this repo provide a set of sample files to test Mike Sweet's "rasterview" application.
This application is specialized in displaying CUPS-, Apple- and PWG-raster files.
Such raster files are common place in CUPS, AirPrint or *[IPP Everywhere](https://github.com/KurtPfeifle/ippsample)* printing environments.

A binary *rasterview [AppImage](https://appimage.org/)* executable for 64bit Linux (runs on many different distros) is available from another GitHub project:

* https://github.com/KurtPfeifle/rasterview/releases

If you are interested in rasterview, just download that AppImage, make it executable (*'`chmod a+x rasterview-*.AppImage`'*) and run it.

The released files from *this* repo are here, embedded in a tarball:

* https://github.com/KurtPfeifle/rasterview-samples/releases

The files were generated from 3 one-page input files: one of PostScript, PDF and JPEG each.
From the inputs, CUPS filters with various settings regarding color depths (1, 2, 4, 8 and 16 bit) and color spaces (RGB, sRGB, AdobeRGB, CMYK, CIEXYZ, ...) created the output raster files.

They are wrapped up in a tarball which after downloading you need to extract first:

    tar xvzf rasterview-samples.tar.gz

Since some of these raster files are rather big, they are individually compressed as well and appear from the tarball as individual `*.gz` files.[^1]
rasterview will [soon be able to open these `*.gz` files directly](https://github.com/michaelrsweet/rasterview/issues/7), but for now you'll have to *gunzip* all samples you are interested in individually, or all at once:

    cd rasterview-samples ;

    for i in *.gz ; do
        gunzip $i ;
    done


[^1]: Else the unpacking of the tarball may already consume too much space on disk:
The total number of raster files included in the release tarball is more than 1500.
If uncompressed, these would add up to ~670 MByte of disk space.
The compressed tarball archive consumes only ~127 MByte.
