
zip_download_dest  <- "~/Documents/sad-comparison.zip"

download.file("https://zenodo.org/record/166725/files/weecology/sad-comparison-peerj.2.zip?download=1",zip_download_dest , quiet = TRUE, mode = "wb")
unzip("~/Documents/sad-comparison.zip", exdir = "~/Documents/sad-comparison")
file.remove(zip_download_dest)

