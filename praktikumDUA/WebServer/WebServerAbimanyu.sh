# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines in the history. See bash(1) for more options
# ... or force ignoredups and ignorespace
HISTCONTROL=ignoredups:ignorespace

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
        # We have color support; assume it's compliant with Ecma-48
        # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
        # a case would tend to support setf rather than setaf.)
        color_prompt=yes
    else
        color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
#if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
#    . /etc/bash_completion
#fi

# WEB SERVER CONFIGURATION
echo "nameserver 192.168.122.1" > /etc/resolv.conf
apt-get install -y nginx php php-fpm apache2 libapache2-mod-php7.0 unzip wget
echo '
nameserver 10.14.1.2
nameserver 10.14.2.2
nameserver 192.168.122.1
' > /etc/resolv.conf

mkdir /var/www/html
rm /etc/apache2/sites-enabled/000-default.conf
cp /etc/apache2/sites-available/000-default.conf /etc/apache2/sites-available/abimanyu.b11.conf

echo '
<?php
$hostname = gethostname();
$date = date('Y-m-d H:i:s');
$php_version = phpversion();
$username = get_current_user();



echo "Hello World!<br>";
echo "Saya adalah: $username<br>";
echo "Saat ini berada di: $hostname<br>";
echo "Versi PHP yang saya gunakan: $php_version<br>";
echo "Tanggal saat ini: $date<br>";
?>
' > /var/www/html/index.php
rm /etc/nginx/sites-enabled/default
echo '
 server {

 	listen 8002;

 	root /var/www/html;

 	index index.php index.html index.htm;
 	server_name _;

 	location / {
 			try_files $uri $uri/ /index.php?$query_string;
 	}

 	# pass PHP scripts to FastCGI server
 	location ~ \.php$ {
 	include snippets/fastcgi-php.conf;
 	fastcgi_pass unix:/var/run/php/php7.0-fpm.sock;
 	}

 location ~ /\.ht {
 			deny all;
 	}

 	error_log /var/log/nginx/www_error.log;
 	access_log /var/log/nginx/www_access.log;
 }
' > /etc/nginx/sites-available/www
ln -s /etc/nginx/sites-available/www /etc/nginx/sites-enabled
service php7.0-fpm start
service nginx restart

mkdir /var/www/abimanyu.b11
wget --no-check-certificate 'https://drive.usercontent.google.com/download?id=1a4V23hwK9S7hQEDEcv9FL14UkkrHc-Zc' -O /var/www/abimanyu
unzip /var/www/abimanyu -d /var/www
mv /var/www/abimanyu.yyy.com/* /var/www/abimanyu.b11
rm /var/www/abimanyu
rm -rf /var/www/abimanyu.yyy.com/
echo '
<VirtualHost *:80>
        RewriteEngine On
        RewriteCond %{HTTP_HOST} !^www.abimanyu.b11.com$
        RewriteRule /.* http://www.abimanyu.b11.com/ [R]
        ServerAdmin webmaster@localhost
        DocumentRoot /var/www/abimanyu.b11
        Alias /home /var/www/abimanyu.b11/index.php/home
        ErrorLog ${APACHE_LOG_DIR}/error.log
        CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
' > /etc/apache2/sites-available/abimanyu.b11.conf
ln -s /etc/apache2/sites-available/abimanyu.b11.conf /etc/apache2/sites-enabled

mkdir /var/www/parikesit.abimanyu.b11
wget --no-check-certificate 'https://drive.usercontent.google.com/download?id=1LdbYntiYVF_NVNgJis1GLCLPEGyIOreS' -O /var/www/parikesit
unzip /var/www/parikesit -d /var/www
mv /var/www/parikesit.abimanyu.yyy.com/* /var/www/parikesit.abimanyu.b11
rm /var/www/parikesit
rm -rf /var/www/parikesit.abimanyu.yyy.com/
mkdir /var/www/parikesit.abimanyu.b11/secret
echo '
top secret : forbidden area
' > /var/www/parikesit.abimanyu.b11/secret/index.html
echo '
RewriteEngine On
RewriteCond %{REQUEST_FILENAME} !-d
RewriteCond %{REQUEST_FILENAME} abimanyu
RewriteRule .* public/images/abimanyu.png [R,NC,L]
' > /var/www/parikesit.abimanyu.b11/public/images/.htaccess
echo '
<VirtualHost *:80>
        ServerName parikesit.abimanyu.b11.com
        ServerAlias www.parikesit.abimanyu.b11.com
        ServerAdmin webmaster@localhost
        DocumentRoot /var/www/parikesit.abimanyu.b11

        <Directory /var/www/parikesit.abimanyu.b11/public/images>
            Options +FollowSymLinks +Indexes -Multiviews
            AllowOverride All
        </Directory>

        <Directory /var/www/parikesit.abimanyu.b11/secret>
            Options -Indexes
            Deny from all
        </Directory>

        Alias /js /var/www/parikesit.abimanyu.b11/public/js
        ErrorDocument 404 /error/404.html
        ErrorDocument 403 /error/403.html

        ErrorLog ${APACHE_LOG_DIR}/error.log
        CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
' > /etc/apache2/sites-available/parikesit.abimanyu.b11.conf
ln -s /etc/apache2/sites-available/parikesit.abimanyu.b11.conf /etc/apache2/sites-enabled

mkdir /var/www/rjp.baratayuda.abimanyu.b11
wget --no-check-certificate 'https://drive.usercontent.google.com/download?id=1pPSP7yIR05JhSFG67RVzgkb-VcW9vQO6' -O /var/www/rjp.baratayuda
unzip /var/www/rjp.baratayuda -d /var/www
mv /var/www/rjp.baratayuda.abimanyu.yyy.com/* /var/www/rjp.baratayuda.abimanyu.b11
rm /var/www/rjp.baratayuda
rm -rf /var/www/rjp.baratayuda.abimanyu.yyy.com/

echo '
# If you just change the port or add more ports here, you will likely also
# have to change the VirtualHost statement in
# /etc/apache2/sites-enabled/000-default.conf

Listen 80
Listen 14000
Listen 14400

<IfModule ssl_module>
        Listen 443
</IfModule>

<IfModule mod_gnutls.c>
        Listen 443
</IfModule>

# vim: syntax=apache ts=4 sw=4 sts=4 sr noet
' > /etc/apache2/ports.conf
echo '
<VirtualHost *:14000 *:14400>
        ServerName rjp.baratayuda.abimanyu.b11.com
        ServerAlias www.rjp.baratayuda.abimanyu.b11.com
        ServerAdmin webmaster@localhost
        DocumentRoot /var/www/rjp.baratayuda.abimanyu.b11

        <Directory /var/www/rjp.baratayuda.abimanyu.b11>
            AuthType Basic
            AuthName "Authentication Required"
            AuthUserFile /etc/apache2/passwords
            Require user Wayang
        </Directory>
        <Directory /var/www/rjp.baratayuda.abimanyu.b11>
            Options +Indexes
        </Directory>

        ErrorLog ${APACHE_LOG_DIR}/error.log
        CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
' > /etc/apache2/sites-available/rjp.baratayuda.abimanyu.b11.conf
ln -s /etc/apache2/sites-available/rjp.baratayuda.abimanyu.b11.conf /etc/apache2/sites-enabled
htpasswd -cb /etc/apache2/passwords Wayang baratayudab11
a2enmod rewrite
a2ensite parikesit.abimanyu.b11.conf
a2ensite abimanyu.b11.conf
a2ensite rjp.baratayuda.abimanyu.b11.conf

service apache2 restart
