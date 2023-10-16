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

![image](https://github.com/ulimakrh/Jarkom-Modul-2-B11-2023/assets/114993076/a6e31325-5774-4085-b18c-9467f4ebbc9d)

Buat direktori baru bernama arjuna dengan command `mkdir /etc/bind/arjuna` dan jalankan `cp /etc/bind/db.local /etc/bind/arjuna/arjuna.it19.com`
 untuk mengcopy /etc/bind/db.local ke dalam direktori arjuna dan mengubah namanya menjadi arjuna.b11.com. Setup /etc/bind/arjuna/arjuna.it19.com dengan mengubah nama dan IP masing-masing.

![image](https://github.com/ulimakrh/Jarkom-Modul-2-B11-2023/assets/114993076/6bd390d3-a234-45e5-ae75-c9e7d5a94a66)

Jika sudah, restart bind9 dengan `service bind9 restart`

![image](https://github.com/ulimakrh/Jarkom-Modul-2-B11-2023/assets/114993076/ec91343b-9afa-44a1-8f67-989140b00246)

![image](https://github.com/ulimakrh/Jarkom-Modul-2-B11-2023/assets/114993076/c7b16143-c4b1-4a6e-b38d-5723366b9e37)


# Soal 3
Dengan cara yang sama seperti soal nomor 2, buatlah website utama dengan akses ke abimanyu.yyy.com dan alias www.abimanyu.yyy.com.

# Soal 4
Kemudian, karena terdapat beberapa web yang harus di-deploy, buatlah subdomain parikesit.abimanyu.yyy.com yang diatur DNS-nya di Yudhistira dan mengarah ke Abimanyu.

# Soal 5
Buat juga reverse domain untuk domain utama. (Abimanyu saja yang direverse)

# Soal 6
Agar dapat tetap dihubungi ketika DNS Server Yudhistira bermasalah, buat juga Werkudara sebagai DNS Slave untuk domain utama.

# Soal 7
Seperti yang kita tahu karena banyak sekali informasi yang harus diterima, buatlah subdomain khusus untuk perang yaitu baratayuda.abimanyu.yyy.com dengan alias www.baratayuda.abimanyu.yyy.com yang didelegasikan dari Yudhistira ke Werkudara dengan IP menuju ke Abimanyu dalam folder Baratayuda.

# Soal 8
Untuk informasi yang lebih spesifik mengenai Ranjapan Baratayuda, buatlah subdomain melalui Werkudara dengan akses rjp.baratayuda.abimanyu.yyy.com dengan alias www.rjp.baratayuda.abimanyu.yyy.com yang mengarah ke Abimanyu.

# Soal 9
Arjuna merupakan suatu Load Balancer Nginx dengan tiga worker (yang juga menggunakan nginx sebagai webserver) yaitu Prabakusuma, Abimanyu, dan Wisanggeni. Lakukan deployment pada masing-masing worker.

# Soal 10
Kemudian gunakan algoritma Round Robin untuk Load Balancer pada Arjuna. Gunakan server_name pada soal nomor 1. Untuk melakukan pengecekan akses alamat web tersebut kemudian pastikan worker yang digunakan untuk menangani permintaan akan berganti ganti secara acak. Untuk webserver di masing-masing worker wajib berjalan di port 8001-8003. Contoh
    - Prabakusuma:8001
    - Abimanyu:8002
    - Wisanggeni:8003

# Soal 11
Selain menggunakan Nginx, lakukan konfigurasi Apache Web Server pada worker Abimanyu dengan web server www.abimanyu.yyy.com. Pertama dibutuhkan web server dengan DocumentRoot pada /var/www/abimanyu.yyy

# Soal 12
Setelah itu ubahlah agar url www.abimanyu.yyy.com/index.php/home menjadi www.abimanyu.yyy.com/home.

# Soal 13
Selain itu, pada subdomain www.parikesit.abimanyu.yyy.com, DocumentRoot disimpan pada /var/www/parikesit.abimanyu.yyy

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

