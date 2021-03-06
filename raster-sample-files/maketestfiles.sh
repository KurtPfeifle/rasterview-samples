#!/bin/sh
#
# Make test files using the CUPS imagetoraster filter and the test PPD
# in this directory...
#
# Usage:
#
#     ./maketestfiles.sh [ [depth(s)] [colorspace(s)] [order(s)] | [all] ] \
#                        [ pstoraster | imagetoraster | cgpdftoraster | cgimagetoraster] \
#                        [ ras | apple | pwg ]
#

PPD=rasterview.ppd; export PPD
basedir=`dirname $0`
depths=""
cspaces=""
orders=""
filter=""
format="ras"
FINAL_CONTENT_TYPE=application/vnd.cups-raster; export FINAL_CONTENT_TYPE
if test -d /usr/libexec/cups/filter; then
	filterpath="/usr/libexec/cups/filter"
else
	filterpath="/usr/lib/cups/filter"
fi

for file in pdftoraster cgpdftoraster; do
	if test -x $filterpath/$file; then
		filter=$file
		break
	fi
done


for file in pstoraster pstocupsraster; do
	if test -x $filterpath/$file; then
		ps_to_raster=$file
		break
	fi
done

for option in $*; do
	case $option in
		1 | 2 | 4 | 8 | 16)
			depths="$depths $option"
			;;
		Chunked | Banded)
			orders="$orders $option"
			;;
		Planar)
			echo "Error: Planar order is not supported!"
			exit 1
			;;
		W | RGB | RGBA | K | CMY | YMC | CMYK | YMCK | KCMY | \
		KCMYcm | GMCK | GMCS | WHITE | GOLD | SILVER | RGBW | \
		sW | sRGB | AdobeRGB | \
		CIEXYZ | CIELab | ICC1 | ICC2 | ICC3 | ICC4 | ICC5 | \
		ICC6 | ICC7 | ICC8 | ICC9 | ICCA | ICCB | ICCC | ICCD | \
		ICCE | ICCF | \
		Device1 | Device2 | Device3 | Device4 | Device5 | Device6 | \
		Device7 | Device8 | Device9 | DeviceA | DeviceB | DeviceC | \
		DeviceD | DeviceE | DeviceF)
			cspaces="$cspaces $option"
			;;
		pstoraster | imagetoraster | pdftoraster | cgimagetoraster | cgpdftoraster)
			filter="$option"
			;;
		all)
			cspaces="W RGB RGBA K CMY YMC CMYK YMCK KCMY KCMYcm"
			cspaces="$cspaces GMCK GMCS WHITE GOLD SILVER RGBW"
			cspaces="$cspaces sW sRGB AdobeRGB"
			cspaces="$cspaces CIEXYZ CIELab ICC1 ICC2 ICC3 ICC4"
			cspaces="$cspaces ICC5 ICC6 ICC7 ICC8 ICC9 ICCA ICCB"
			cspaces="$cspaces ICCC ICCD ICCE ICCF"
			cspaces="$cspaces Device1 Device2 Device3 Device4"
			cspaces="$cspaces Device5 Device6 Device7 Device8"
			cspaces="$cspaces Device9 DeviceA DeviceB DeviceC"
			cspaces="$cspaces DeviceD DeviceE DeviceF"
			depths="1 2 4 8 16"
			orders="Chunked Banded"
			;;

		apple)
			FINAL_CONTENT_TYPE="image/urf"
			format="apple"
			;;

		pwg)
			FINAL_CONTENT_TYPE="image/pwg-raster"
			format="pwg"
			;;

		ras)
			FINAL_CONTENT_TYPE="application/vnd.cups-raster"
			format="ras"
			;;

		clean)
			rm -f *.apple
			rm -f *.pwg
			rm -f *.ras
			rm -f *.log
			exit 0
			;;

		failedclean)
			rm -f *-FAILED.apple
			rm -f *-FAILED.pwg
			rm -f *-FAILED.ras
			rm -f *.log
			exit 0
			;;

		help|--help|-h)
			echo "Usage: $0 [filter] [format] [colorspace(s)] [depth(s)] [order(s)]"
			echo "       $0 [filter] [format] [all]"
			echo "       $0 clean"
			echo ""
			echo "Colorspaces: W RGB RGBA K CMY YMC CMYK YMCK KCMY KCMYcm"
			echo "             GMCK GMCS WHITE GOLD SILVER RGBW"
			echo "             sW sRGB AdobeRGB"
			echo "             CIEXYZ CIELab ICC1 ICC2 ICC3 ICC4"
			echo "             ICC5 ICC6 ICC7 ICC8 ICC9 ICCA ICCB"
			echo "             ICCC ICCD ICCE ICCF"
			echo "             Device1 Device2 Device3 Device4"
			echo "             Device5 Device6 Device7 Device8"
			echo "             Device9 DeviceA DeviceB DeviceC"
			echo "             DeviceD DeviceE DeviceF"
			echo ""
			echo "Depths: 1 2 4 8 16"
			echo ""
			echo "Orders: Chunked Banded"
			echo ""
			echo "Filters: cgimagetoraster cgpdftoraster imagetoraster pdftoraster pstoraster"
			echo "         (Use maximum of one per command -- if not given,"
			echo "         defaults to cgpdftoraster on macOS and to pdftoraster on Linux)"
			echo ""
			echo "Formats: apple, pwg, ras"
			echo "         (Use maximum of one per command -- defaults to ras if not given)"
			echo ""
			exit 0
			;;

		*)
			echo "Unknown option '$option'!"
			exit 1
			;;
	esac
done

if test -z "$depths"; then
	depths="1 8"
fi

if test -z "$cspaces"; then
	cspaces="W RGB RGBW K CMY CMYK KCMY KCMYcm CIEXYZ CIELab"
fi

if test -z "$orders"; then
	orders="Chunked Banded"
fi

if test -z "$filter"; then
	echo No image filter found!
	exit 1
else
	echo Using $filter...
fi

for cspace in $cspaces; do
	for depth in $depths; do
		for order in $orders; do
			if test $depth -lt 8 -o $order = Banded; then
				case $cspace in
					CIEXYZ | CIELab | ICC1 | ICC2 | \
					ICC3 | ICC4 | ICC5 | ICC6 | ICC7 | \
					ICC8 | ICC9 | ICCA | ICCB | ICCC | \
					ICCD | ICCE | ICCF)
						continue
						;;
				esac
			fi

			echo "$filter-$cspace-$depth-$order.$format:\c"

			case $filter in
				pstoraster)
					($filterpath/pstops job user title 1 \
						"ColorModel=$cspace cupsBitsPerColor=$depth cupsColorOrder=$order" \
						$basedir/testprint.ps | \
					$filterpath/$ps_to_raster job user \
						title 1 "") \
						> $filter-$cspace-$depth-$order.$format \
						2> $filter-$cspace-$depth-$order-$format.log
					;;
				imagetoraster)
					$filterpath/imagetoraster job user \
						title 1 \
						"scaling=100 ColorModel=$cspace cupsBitsPerColor=$depth cupsColorOrder=$order" \
						$basedir/testprint.jpg \
						> $filter-$cspace-$depth-$order.$format \
						2> $filter-$cspace-$depth-$order-$format.log
					;;
				cgimagetoraster)
					($filterpath/cgimagetopdf job user title 1 \
						"" $basedir/testprint.jpg | \
					$filterpath/cgpdftoraster job user \
						title 1 \
						 "ColorModel=$cspace cupsBitsPerColor=$depth cupsColorOrder=$order") \
						> $filter-$cspace-$depth-$order.$format \
						2> $filter-$cspace-$depth-$order-$format.log
					;;
				cgpdftoraster)
					$filterpath/cgpdftoraster job user \
						title 1 \
						"ColorModel=$cspace cupsBitsPerColor=$depth cupsColorOrder=$order" \
						$basedir/testprint.pdf \
						> $filter-$cspace-$depth-$order.$format \
						2> $filter-$cspace-$depth-$order-$format.log
					;;
				pdftoraster)
					$filterpath/pdftoraster job user \
						title 1 \
						"scaling=100 ColorModel=$cspace cupsBitsPerColor=$depth cupsColorOrder=$order" \
						$basedir/testprint.pdf \
						> $filter-$cspace-$depth-$order.$format  \
						2> $filter-$cspace-$depth-$order-$format.log
					;;
			esac

			if test $? = 0; then
				echo " OK"
				mv $filter-$cspace-$depth-$order-$format.log  $filter-$cspace-$depth-$order-$format-SUCCESS.log
			else
				echo " FAIL (see log file)"
				#rm -f $filter-$cspace-$depth-$order.$format
				mv $filter-$cspace-$depth-$order-$format.log  $filter-$cspace-$depth-$order-$format-FAILED.log
				mv $filter-$cspace-$depth-$order.$format      $filter-$cspace-$depth-$order-FAILED.$format
			fi
		done
	done
done
