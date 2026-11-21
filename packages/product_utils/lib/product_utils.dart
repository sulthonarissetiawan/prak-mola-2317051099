String formatNamaProduk(String nama) {
    return nama.trim().toUpperCase();
}

double hitungHargaDiskon(
    double harga,
    double persentase,
) {
    if (persentase < 0 || persentase > 100) {
        throw ArgumentError(
            'Diskon harus antara 0 sampai 100.',
        );
    }

    return harga * (100 - persentase) / 100;
}