# Transfuse

A script to backup (copy+compress) and restore KDE Plasma user configurations.

Also includes options to export and use package lists for pacman and the Arch User Repository.

<br>

### Download and Use

##### Download
```text
curl -O https://gitlab.com/cscs/transfuse/-/raw/main/transfuse
```

##### Mark Executable
```text
chmod +x transfuse
```

##### Example usage:
```text
./transfuse -b `whoami`
```

> Note: `transfuse` will now present you with a menu if no argument is used

##### Help

```text
 
  TRANSFUSE                                                          
                                                                     
  A Script to Backup and Restore KDE Plasma Desktop Configurations   
                                                                     
  Usage: transfuse [option] [USER/PATIENT]                           
                                                                     
  Options:                                                           
   -h   --help                                      show this help   
   -b   --backup USER               copy and compress USER configs   
   -bt  --backupt USER                 backup USER appearance only   
   -BR  --backuproot                           backup root configs   
   -C   --copy USER                       copy but do not compress   
   -Ct  --copyt USER                     copy USER appearance only   
   -c   --compress                         compress copied configs   
   -p   --pkglists              create lists of installed packages * 
   -pr  --pkgrestore                   install native package list * 
   -pra --pkgrestorealien               install alien package list * 
   -r   --restore PATIENT             restore configs /to/ PATIENT   
                                                                    
  Environment Variable       TR_COVER=1       Skip wallpaper steps   
  Environment Variable       TR_CHART=1        More verbose output   
  Environment Variable       TR_USECP=1          Use cp over rsync   
  (*) pkg* options require pacman package manager or an AUR helper   
 
```

<br>

### Run the script remotely via the URL

The syntax looks like this:<br>
`bash <(curl -s https://gitlab.com/cscs/transfuse/-/raw/main/transfuse) {options}`

##### Example run prompting a menu:
```text
bash <(curl -s https://gitlab.com/cscs/transfuse/-/raw/main/transfuse)
```

##### Example run creating a package list
```text
bash <(curl -s https://gitlab.com/cscs/transfuse/-/raw/main/transfuse) -p
```

<br>

### License

[The Unlicense](/LICENSE)

<br>

### Donate  

Everything is free, but you can donate using these:  

[<img src="https://storage.ko-fi.com/cdn/kofi4.png?v=6" width=160px>](https://ko-fi.com/X8X0VXZU) &nbsp;[<img src="https://gitlab.com/cscs/resources/raw/main/paypalkofi.png" width=160px />](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=M2AWM9FUFTD52)

<br>
