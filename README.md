# rasterview-samples
Sample files to test Mike Sweet's "rasterview" application for multipage CUPS-, Apple- and PWG-raster files.

A binary rasterview [AppImage](https://appimage.org/) executable for 64bit Linux (runs on many different distros) is available here:

* https://github.com/KurtPfeifle/rasterview/releases

Just download the AppImage, make it executable (*'`chmod a+x rasterview-*.AppImage`'*) and run it.

The released files from *this* repo are here:

* https://github.com/KurtPfeifle/rasterview-samples/releases

They are wrapped up in a tarball which after downloading you need to extract first:

    tar xvzf rasterview-samples.tar.gz

Since some of these raster files are rather big, they are individually compressed as well and appear from the tarball as individual `*.gz` files. rasterview will [soon be able to open these directly](https://github.com/michaelrsweet/rasterview/issues/1), but for now you'll have to *gunzip* all samples you are interested in individually, or all at once:

    cd rasterview-samples ;
    
    for i in *.gz ; do
        gunzip $i ;
    done
    
