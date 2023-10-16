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
zone "arjuna.b11.com" { 
    type master; 
    notify yes;
    also-notify { 10.14.2.2; };
    allow-transfer { 10.14.2.2; };
    file "/etc/bind/domain/arjuna.b11.com";
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
- Pada Yudhistira
```
zone "abimanyu.b11.com" {
    type master; 
    notify yes;
    also-notify { 10.14.2.2; };
    allow-transfer { 10.14.2.2; };
    file "/etc/bind/domain/abimanyu.b11.com";
};
```
![image](https://github.com/ulimakrh/Jarkom-Modul-2-B11-2023/assets/114993076/e6c0a9bd-67a8-4c87-971a-9a4565323ef8)

![image](https://github.com/ulimakrh/Jarkom-Modul-2-B11-2023/assets/114993076/6e2afe56-f15c-42e8-ac44-2d3313ec096f)

- Pada Abimanyu
- 
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

