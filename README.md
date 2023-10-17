# Jarkom-Modul-2-B11-2023

| No | Nama | NRP |
| -------- | -------- | -------- |
| 1 | Muhammad Rafif Tri Risqullah | 5025211009 |
| 2 | Ulima Kaltsum Rizky Hibatullah | 5025211232 |

# Soal 1
Yudhistira akan digunakan sebagai DNS Master, Werkudara sebagai DNS Slave, Arjuna merupakan Load Balancer yang terdiri dari beberapa Web Server yaitu Prabakusuma, Abimanyu, dan Wisanggeni. Buatlah topologi dengan pembagian sebagai berikut. Folder topologi dapat diakses pada drive berikut
## Jawaban
### Topologi
![image](https://github.com/ulimakrh/Jarkom-Modul-2-B11-2023/assets/114993076/d42472df-3a3d-405c-bed6-a6d35fbb3fec)

Topologi tersebut dikonfigurasi sesuai dengan langkah-langkah pada modul. Jalankan `iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE -s 10.14.0.0/16.` dan `cat /etc/resolv.conf` untuk mendapatkan ip dari nameserver. Sementara pada node lainnya, jalankan `echo nameserver 192.168.122.1 > /etc/resolv.conf.`

Untuk mengecek apakah sudah berhasil terkoneksi, restart seluruh node dan lakukan ping google.com.
![image](https://github.com/ulimakrh/Jarkom-Modul-2-B11-2023/assets/114993076/cbdaa156-2af3-4916-8a78-593cc9fc3fb6)

# Soal 2
Buatlah website utama pada node arjuna dengan akses ke arjuna.yyy.com dengan alias www.arjuna.yyy.com dengan yyy merupakan kode kelompok.
## Jawaban
Pertama, dilakukan setup Domain Name di Master DNS Server (Yudhistira). Lakukan `nano /etc/bind/named.conf.local` dan tambahkan setup seperti gambar di bawah.

```
zone “arjuna.b11.com” {
	type master;
	file “/etc/bind/domain/arjuna.b11.com";
};
```

![image](https://github.com/ulimakrh/Jarkom-Modul-2-B11-2023/assets/114993076/a6e31325-5774-4085-b18c-9467f4ebbc9d)

Buat direktori baru bernama arjuna dengan command `mkdir /etc/bind/domain` dan jalankan `cp /etc/bind/db.local /etc/bind/domain/arjuna.b11.com` untuk mengcopy /etc/bind/db.local ke dalam direktori arjuna dan mengubah namanya menjadi arjuna.b11.com. Setup /etc/bind/arjuna/arjuna.b11.com dengan mengubah nama dan IP masing-masing.

![image](https://github.com/ulimakrh/Jarkom-Modul-2-B11-2023/assets/114993076/2022e157-c0e7-49dc-95dd-c91980767b48)

Jika sudah, restart bind9 dengan `service bind9 restart`

Selanjutnya, pada Arjuna-LB, dilakukan setup `/etc/resolv.conf` dengan IP dari Yudhistira (IP paling atas).

![image](https://github.com/ulimakrh/Jarkom-Modul-2-B11-2023/assets/114993076/ec91343b-9afa-44a1-8f67-989140b00246)

Jalankan `ping arjuna.b11.com` dan `ping www.arjuna.b11.com` untuk mengecek sudah berhasil atau belum.
![image](https://github.com/ulimakrh/Jarkom-Modul-2-B11-2023/assets/114993076/74e0263c-2292-4965-abbe-c639026619c3)

# Soal 3
Dengan cara yang sama seperti soal nomor 2, buatlah website utama dengan akses ke abimanyu.yyy.com dan alias www.abimanyu.yyy.com.
## Jawaban
Soal nomor ini memiliki langkah yang serupa dengan nomor 2.
- Yudhistira
```
zone “abimanyu.b11.com” {
	type master;
	file “/etc/bind/domain/abimanyu.it19.com";
};
```
![image](https://github.com/ulimakrh/Jarkom-Modul-2-B11-2023/assets/114993076/e6c0a9bd-67a8-4c87-971a-9a4565323ef8)

![image](https://github.com/ulimakrh/Jarkom-Modul-2-B11-2023/assets/114993076/6e2afe56-f15c-42e8-ac44-2d3313ec096f)

- Abimanyu

![image](https://github.com/ulimakrh/Jarkom-Modul-2-B11-2023/assets/114993076/a5e02409-f747-42f6-9ff4-df6c9cfb186a)

![image](https://github.com/ulimakrh/Jarkom-Modul-2-B11-2023/assets/114993076/a9bae43b-2b10-4c71-9377-8bed41760037)

# Soal 4
Kemudian, karena terdapat beberapa web yang harus di-deploy, buatlah subdomain parikesit.abimanyu.yyy.com yang diatur DNS-nya di Yudhistira dan mengarah ke Abimanyu.
## Jawaban
Pada Yudhistira, dilakukan setup /etc/bind/domain/abimanyu.b11.com dengan menambahkan IP untuk parikesit. Sesuaikan dengan ip sebelumnya yang terhubung dengan Abimanyu. Lalu restart bind9.	

![image](https://github.com/ulimakrh/Jarkom-Modul-2-B11-2023/assets/114993076/e6852679-240f-4abc-be63-eef009717970)

Lakukan ujicoba pada Abimanyu dengan menjalankan `ping parikesit.abimanyu.b11.com`

![image](https://github.com/ulimakrh/Jarkom-Modul-2-B11-2023/assets/114993076/ab78637e-7a52-4ecc-8be8-6e608ea0659c)

# Soal 5
Buat juga reverse domain untuk domain utama. (Abimanyu saja yang direverse)
## Jawaban
Pertama, lakukan setup pada /etc/bind/named.conf.local Yudhistira. 4.14.10 sendiri adalah reverse dari IP abimanyu.

![image](https://github.com/ulimakrh/Jarkom-Modul-2-B11-2023/assets/114993076/700c6fbe-f911-42bc-80c8-6d0758938921)

Lakukan setup seperti pada gambar di bawah.

![image](https://github.com/ulimakrh/Jarkom-Modul-2-B11-2023/assets/114993076/264c4144-765d-475b-8839-46561a5b6eb3)

Pada Abimanyu, lakukan pengecekan dengan `host -t PTR 10.14.4.4` (IP Abimanyu).

![image](https://github.com/ulimakrh/Jarkom-Modul-2-B11-2023/assets/114993076/6bfd6ef5-2d6f-4265-8cd8-323a949f31ef)

# Soal 6
Agar dapat tetap dihubungi ketika DNS Server Yudhistira bermasalah, buat juga Werkudara sebagai DNS Slave untuk domain utama.
## Jawaban
Setup pada /etc/bind/named.conf.local.
```
zone "arjuna.b11.com" { 
    type master; 
    notify yes;
    also-notify { 10.14.2.2; };
    allow-transfer { 10.14.2.2; };
    file "/etc/bind/domain/arjuna.b11.com";
};

zone "abimanyu.b11.com" {
    type master; 
    notify yes;
    also-notify { 10.14.2.2; };
    allow-transfer { 10.14.2.2; };
    file "/etc/bind/domain/abimanyu.b11.com";
};
```
![image](https://github.com/ulimakrh/Jarkom-Modul-2-B11-2023/assets/114993076/1e2b10fc-6593-491d-a224-4c9683619f27)

Kemudian stop bind9 dengan `service bind9 stop`.

- Werkudara

Dilakukan setup pada /etc/bind/named.conf.local seperti di bawah ini.

![image](https://github.com/ulimakrh/Jarkom-Modul-2-B11-2023/assets/114993076/a321a443-7d9b-410a-a623-5919da23e5ba)

- Sadewa

Setup nameserver di /etc/resolv.conf dengan IP Yudhistira dan IP Werkudara.

![image](https://github.com/ulimakrh/Jarkom-Modul-2-B11-2023/assets/114993076/e98b2cb7-85da-4320-9cae-3be1efe06da8)

Lakukan ujicoba dengan melakukan `ping abimanyu.b11.com`
![image](https://github.com/ulimakrh/Jarkom-Modul-2-B11-2023/assets/114993076/e1699e61-6c7b-4fce-8ff4-1c8539b2787e)

# Soal 7
Seperti yang kita tahu karena banyak sekali informasi yang harus diterima, buatlah subdomain khusus untuk perang yaitu baratayuda.abimanyu.yyy.com dengan alias www.baratayuda.abimanyu.yyy.com yang didelegasikan dari Yudhistira ke Werkudara dengan IP menuju ke Abimanyu dalam folder Baratayuda.
## Jawaban
Pada Yudhistira, lakukan setup pada /etc/bind/domain/abimanyu.b11.com seperti gambar di bawah ini.

![image](https://github.com/ulimakrh/Jarkom-Modul-2-B11-2023/assets/114993076/27db769e-f383-4838-b91a-580af3995f83)

Lalu, setup untuk mengizinkan akses query pada /etc/bind/named.conf.options seperti di bawah ini.

![image](https://github.com/ulimakrh/Jarkom-Modul-2-B11-2023/assets/114993076/8ca4e73e-6107-4e40-b66c-c2187e29cc3d)

Kemudian restart bind9 dengan `service bind9 restart`

- Werkudara
  
Buat setup /etc/bind/named.conf.options sama seperti pada Yudhistira.

![image](https://github.com/ulimakrh/Jarkom-Modul-2-B11-2023/assets/114993076/178527a5-34ea-4b04-8110-bfdd553109b5)

Buat direktori baru dan lakukan copy db.local ke /etc/bind/delegate/baratayuda
```
mkdir /etc/bind/delegate
mkdir /etc/bind/delegate/baratayuda
cp /etc/bind/db.local /etc/bind/delegate/baratayuda
```
Buat setup pada /etc/bind/delegate/baratayuda/baratayuda.abimanyu.b11.com seperti di bawah ini.

![image](https://github.com/ulimakrh/Jarkom-Modul-2-B11-2023/assets/114993076/f8ad564e-9bf5-4e12-8d30-07d63665307d)

Kemudian restart bind9 dengan `service bind9 restart`.

- Sadewa

Jalankan `ping baratayuda.abimanyu.b11.com` dan `ping www.baratayuda.abimanyu.b11.com`

![image](https://github.com/ulimakrh/Jarkom-Modul-2-B11-2023/assets/114993076/a9ff3a6e-c028-4bda-b345-80672a49d7fc)

# Soal 8
Untuk informasi yang lebih spesifik mengenai Ranjapan Baratayuda, buatlah subdomain melalui Werkudara dengan akses rjp.baratayuda.abimanyu.yyy.com dengan alias www.rjp.baratayuda.abimanyu.yyy.com yang mengarah ke Abimanyu.
## Jawaban
Setup /etc/bind/named.conf.local pada Wekudara seperti berikut.
```
zone "baratayuda.abimanyu.b11.com" {
    type master;
    file "/etc/bind/delegate/baratayuda/baratayuda.abimanyu.b11.com";
};
```
![image](https://github.com/ulimakrh/Jarkom-Modul-2-B11-2023/assets/114993076/1f89c9f0-a961-417e-a2ab-f4c6152d23ff)

Lalu, buat direktori baru dan setup direktori tersebut.
```
mkdir /etc/bind/delegate
mkdir /etc/bind/delegate/baratayuda
```
Berikut adalah setup dari /etc/bind/delegate/baratayuda/baratayuda.abimanyu.b11.com. Kemudian restart bind9 dengan
`service bind9 restart`

![image](https://github.com/ulimakrh/Jarkom-Modul-2-B11-2023/assets/114993076/588a0e4d-b98d-48b0-8fe2-747c2f662d44)

- Sadewa

Lakukan ujicoba dengan `ping baratayuda.abimanyu.b11.com` `ping www.baratayuda.abimanyu.b11.com`

![image](https://github.com/ulimakrh/Jarkom-Modul-2-B11-2023/assets/114993076/ec3cbd78-f305-4276-8608-25847ef2c0aa)

# Soal 9 dan 10
Arjuna merupakan suatu Load Balancer Nginx dengan tiga worker (yang juga menggunakan nginx sebagai webserver) yaitu Prabakusuma, Abimanyu, dan Wisanggeni. Lakukan deployment pada masing-masing worker.

Kemudian gunakan algoritma Round Robin untuk Load Balancer pada Arjuna. Gunakan server_name pada soal nomor 1. Untuk melakukan pengecekan akses alamat web tersebut kemudian pastikan worker yang digunakan untuk menangani permintaan akan berganti ganti secara acak. Untuk webserver di masing-masing worker wajib berjalan di port 8001-8003. Contoh
- Prabakusuma:8001
- Abimanyu:8002
- Wisanggeni:8003
## Jawaban
Pada Arjuna, tepatnya pada /etc/nginx/sites-available/arjuna, dilakukan konfigurasi seperti berikut.

![image](https://github.com/ulimakrh/Jarkom-Modul-2-B11-2023/assets/114993076/5a78a2fb-07a3-430e-8565-0978bdf847c9)

IP pada blok upstream arjuna.b11.com adalah IP dari Prabukusuma, Abimanyu, dan Wisanggeni.

Setelah config, hapus file default pada /etc/nginx/sites-available/default, dan dibentuk symlink dari file /etc/nginx/sites-available/arjuna ke folder /etc/nginx/sites-enabled/.
```
rm /etc/nginx/sites-available/default
ln -s /etc/nginx/sites-available/arjuna /etc/nginx/sites-enabled
```
Lalu, restart kembali nginx dengan `service nginx restart`.

- Prabukusuma, Abimanyu, Wisanggeni
Lakukan command-command berikut ini.
```
wget -O arjuna.zip --no-check-certificate -r 'https://drive.google.com/uc?export=download&id=17tAM_XDKYWDvF-JJix1x7txvTBEax7vX'
// download
unzip arjuna.zip // unzip
rm arjuna.zip // remove zip
```
Ganti root dengan folder tempat index.php yang telah diekstrak tadi sebagai value, dan ubah value angka listen di awal file config dengan angka yang sesuai untuk semuanya (Prabukusuma 8001, Abimanyu 8002, Wisanggeni 8003). Berikut adalah contoh dari node Prabukusuma.

![image](https://github.com/ulimakrh/Jarkom-Modul-2-B11-2023/assets/114993076/2ae27f6a-432e-4c2f-9021-f422a909444e)

Buat setup pada /var/www/html/index.php seperti berikut.
![image](https://github.com/ulimakrh/Jarkom-Modul-2-B11-2023/assets/114993076/32e6e6ef-8708-4ba6-96e7-e0415782cc18)

# Soal 11
Selain menggunakan Nginx, lakukan konfigurasi Apache Web Server pada worker Abimanyu dengan web server www.abimanyu.yyy.com. Pertama dibutuhkan web server dengan DocumentRoot pada /var/www/abimanyu.yyy
## Jawaban
Jalankan command-command berikut pada Abimanyu.
```
mkdir /var/www/abimanyu.b11 # Create directory
wget --no-check-certificate 'https://drive.usercontent.google.com/download?id=1a4V23hwK9S7hQEDEcv9FL14UkkrHc-Zc' -O /var/www/abimanyu # Download resources
unzip /var/www/abimanyu -d /var/www # Unzip folder

mv /var/www/abimanyu.yyy.com/* /var/www/abimanyu.b11 # Move folder
rm /var/www/abimanyu # Remove folder
rm -rf /var/www/abimanyu.yyy.com/
```
Membuat konfigurasi pada /etc/apache2/sites-available/abimanyu.b11.conf. Dengan menggunakan file 000-default.conf sebagai template, lalu dimodifikasi seperti berikut ini.

![image](https://github.com/ulimakrh/Jarkom-Modul-2-B11-2023/assets/114993076/65bceadb-8af0-4228-bd18-50584a5dac78)

Lalu, ujicoba dengan menggunakan `lynx http://abimanyu.b11.com` atau `curl http://abimanyu.b11.com`.

![image](https://github.com/ulimakrh/Jarkom-Modul-2-B11-2023/assets/114993076/4922fee6-5963-431c-91ac-702663e7632b)
![image](https://github.com/ulimakrh/Jarkom-Modul-2-B11-2023/assets/114993076/a9c10161-e43f-40a5-80da-8a262ba8fa33)

Ujicoba juga dilakukan pada node Sadewa.

![image](https://github.com/ulimakrh/Jarkom-Modul-2-B11-2023/assets/114993076/baf6bc32-d938-4bf1-9435-d371f99ecf10)

# Soal 12
Setelah itu ubahlah agar url www.abimanyu.yyy.com/index.php/home menjadi www.abimanyu.yyy.com/home.
## Jawaban
Buat konfigurasi pada /etc/apache2/sites-available/abimanyu.b11.conf seperti ini.

![image](https://github.com/ulimakrh/Jarkom-Modul-2-B11-2023/assets/114993076/3ac0fab6-6a58-460e-8f34-6b00da731b53)

Bagian `Alias /home /var/www/abimanyu.b11/index.php/home` akan menggantikan path /index.php/home untuk mengakses home.html yang ada di folder /var/www/abimanyu.b11/.

Ujicoba dilakukan pada node Sadewa dengan menggunakan `lynx http://www.abimanyu.b11.com/home`

![image](https://github.com/ulimakrh/Jarkom-Modul-2-B11-2023/assets/114993076/7428bc6b-4c46-4a6a-8dc3-a091a82e5dfd)

# Soal 13
Selain itu, pada subdomain www.parikesit.abimanyu.yyy.com, DocumentRoot disimpan pada /var/www/parikesit.abimanyu.yyy
## Jawaban
Jalankan command-command berikut ini pada node Abimanyu.
```
mkdir /var/www/parikesit.abimanyu.b11
wget --no-check-certificate 'https://drive.usercontent.google.com/download?id=1LdbYntiYVF_NVNgJis1GLCLPEGyIOreS' -O /var/www/parikesit
unzip /var/www/parikesit -d /var/www

mv /var/www/parikesit.abimanyu.yyy.com/* /var/www/parikesit.abimanyu.b11
rm /var/www/parikesit
rm -rf /var/www/parikesit.abimanyu.yyy.com/
```
![image](https://github.com/ulimakrh/Jarkom-Modul-2-B11-2023/assets/114993076/4380e1fa-16db-4dd6-ab56-1c2791f0ebfc)
```
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
```

# Soal 14
Pada subdomain tersebut folder /public hanya dapat melakukan directory listing sedangkan pada folder /secret tidak dapat diakses (403 Forbidden).

# Soal 15
Buatlah kustomisasi halaman error pada folder /error untuk mengganti error kode pada Apache. Error kode yang perlu diganti adalah 404 Not Found dan 403 Forbidden.

# Soal 16
Buatlah suatu konfigurasi virtual host agar file asset www.parikesit.abimanyu.yyy.com/public/js menjadi 
www.parikesit.abimanyu.yyy.com/js 

# Soal 17
Agar aman, buatlah konfigurasi agar www.rjp.baratayuda.abimanyu.yyy.com hanya dapat diakses melalui port 14000 dan 14400.

# Soal 18
Untuk mengaksesnya buatlah autentikasi username berupa “Wayang” dan password “baratayudayyy” dengan yyy merupakan kode kelompok. Letakkan DocumentRoot pada /var/www/rjp.baratayuda.abimanyu.yyy.

# Soal 19
Buatlah agar setiap kali mengakses IP dari Abimanyu akan secara otomatis dialihkan ke www.abimanyu.yyy.com (alias)

# Soal 20
Karena website www.parikesit.abimanyu.yyy.com semakin banyak pengunjung dan banyak gambar gambar random, maka ubahlah request gambar yang memiliki substring “abimanyu” akan diarahkan menuju abimanyu.png.

