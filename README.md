# rasterview-samples

Releases from this repo provide a set of sample files to test Mike Sweet's "rasterview" application.
This application is specialized in displaying CUPS-, Apple- and PWG-raster files.
Such raster files are common place in CUPS, AirPrint or *[IPP Everywhere](https://github.com/KurtPfeifle/ippsample)* printing environments.

A binary *rasterview [AppImage](https://appimage.org/)* executable for 64bit Linux (runs on many different distros) is available from another GitHub project:

* https://github.com/KurtPfeifle/rasterview/releases

If you are interested in rasterview, just download that AppImage, make it executable (*'`chmod a+x rasterview-*.AppImage`'*) and run it.

The released files from *this* repo are here, embedded in a tarball:

* https://github.com/KurtPfeifle/rasterview-samples/releases

They are wrapped up in a tarball which after downloading you need to extract first:

    tar xvzf rasterview-samples.tar.gz

Since some of these raster files are rather big, they are individually compressed as well and appear from the tarball as individual `*.gz` files.
Else the unpacking of the tarball may already consume too much space on disk.
rasterview will [soon be able to open these `*.gz` files directly](https://github.com/michaelrsweet/rasterview/issues/7), but for now you'll have to *gunzip* all samples you are interested in individually, or all at once:

    cd rasterview-samples ;

    for i in *.gz ; do
        gunzip $i ;
    done

