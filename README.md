# 💻 Manajemen Lab Komputer - Frontend (Flutter Web)

Aplikasi antarmuka web (Frontend) untuk Sistem Manajemen Lab Komputer. Proyek ini merupakan tugas kuliah yang dibangun menggunakan **Flutter Web** dengan penekanan utama pada desain *layout* yang responsif (beradaptasi dari layar ponsel hingga monitor *desktop*) menggunakan Material Design 3.

Repositori Backend (API): [api_flutter_project](https://github.com/Syfiq2625/api_flutter_project)

## ✨ Fitur Utama

- **Desain Responsif:** Menggunakan `LayoutBuilder` dengan *breakpoint* 600px & 900px.
  - Layar Sempit (< 900px): Menggunakan navigasi *Floating Bottom Bar* ala macOS/iPadOS dan daftar dalam bentuk *Card/ListView*.
  - Layar Lebar (≥ 900px): Bertransisi otomatis menggunakan `NavigationRail` di sisi kiri dan data tabular menggunakan `DataTable`.
- **Manajemen State Terpusat:** Memanfaatkan *package* `provider` untuk mengelola keranjang data secara efisien.
- **Dark Mode:** Dukungan tema Gelap/Terang terintegrasi secara dinamis menggunakan `ThemeMode` Material 3.
- **Sinkronisasi Data Real-time:** UI otomatis memuat ulang stok barang ketika transaksi peminjaman berhasil divalidasi oleh server.

## 🛠️ Tech Stack

- **Framework:** Flutter (Channel Stable) - Target Web
- **State Management:** `provider`
- **HTTP Client:** `http`
- **UI Kit:** Material 3

## 🚀 Cara Menjalankan Proyek (Local Development)

Aplikasi ini berjalan di atas *browser* dan berkomunikasi dengan REST API lokal. Untuk menghindari pemblokiran CORS (*Cross-Origin Resource Sharing*), proyek ini harus dijalankan pada *port* yang spesifik.

1. Pastikan Backend API sudah berjalan di Laragon (`http://localhost/lab_api/`).
2. Buka terminal dan lakukan *clone* repositori ini:
   ```bash
   git clone [https://github.com/USERNAME_ANDA/flutter_project.git](https://github.com/Syfiq2625/flutter_project.git)
   cd flutter_project
   ```
3. Unduh semua *dependencies* (paket Dart):
   ```bash
   flutter pub get
   ```
4. Jalankan aplikasi di Chrome dengan *port* yang dikunci ke `5000`:
   ```bash
   flutter run -d chrome --web-port=5000
   ```

## 📝 Arsitektur & Keputusan Desain (ADR)
- **Validasi Terpusat di Backend:** *Frontend* sama sekali tidak melakukan pengurangan stok secara mandiri. Aplikasi mengirim data transaksi ke API dan menunggu respons dari *server* untuk menjamin integritas data (mencegah manipulasi stok dari sisi klien).
- **Pemilihan Stack:** Penggunaan `provider` dan `http` murni dipilih untuk mencegah kompleksitas (*over-engineering*) mengingat skala proyek yang difokuskan pada penguasaan *layouting* responsif.