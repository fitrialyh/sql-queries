SELECT COALESCE(pengadaan.id_material, permintaan.id_material) AS id_material,
       COALESCE(pengadaan.nama, permintaan.nama) AS nama_material,
       COALESCE(pengadaan.stok_masuk, 0),
       COALESCE(permintaan.stok_keluar, 0)
FROM (
    SELECT jp.id_material, m.nama, SUM(jp.jumlah) AS stok_masuk
    FROM jumlah_pengadaan jp
    INNER JOIN material m ON jp.id_material = m.id_material
    INNER JOIN pengadaan p ON jp.id_pengadaan = p.id_pengadaan
    WHERE p.status = 'Selesai'
    AND p.tanggal_permintaan BETWEEN :startDate AND :endDate
    GROUP BY jp.id_material
) pengadaan
LEFT JOIN (
    SELECT jp.id_material, m.nama, SUM(jp.jumlah) AS stok_keluar
    FROM jumlah_permintaan jp
    INNER JOIN material m ON jp.id_material = m.id_material
    INNER JOIN permintaan p ON jp.id_permintaan = p.id_permintaan
    WHERE p.status = 'Selesai'
    AND p.tanggal_permintaan BETWEEN :startDate AND :endDate
    GROUP BY jp.id_material
) permintaan ON pengadaan.id_material = permintaan.id_material
UNION
SELECT COALESCE(pengadaan.id_material, permintaan.id_material) AS id_material,
       COALESCE(pengadaan.nama, permintaan.nama) AS nama_material,
       COALESCE(pengadaan.stok_masuk, 0),
       COALESCE(permintaan.stok_keluar, 0)
FROM (
    SELECT jp.id_material, m.nama, SUM(jp.jumlah) AS stok_masuk
    FROM jumlah_pengadaan jp
    INNER JOIN material m ON jp.id_material = m.id_material
    INNER JOIN pengadaan p ON jp.id_pengadaan = p.id_pengadaan
    AND p.tanggal_permintaan BETWEEN :startDate AND :endDate
    WHERE p.status = 'Selesai'
    GROUP BY jp.id_material
) pengadaan
RIGHT JOIN (
    SELECT jp.id_material, m.nama, SUM(jp.jumlah) AS stok_keluar
    FROM jumlah_permintaan jp
    INNER JOIN material m ON jp.id_material = m.id_material
    INNER JOIN permintaan p ON jp.id_permintaan = p.id_permintaan
    WHERE p.status = 'Dikirim'
    AND p.tanggal_permintaan BETWEEN :startDate AND :endDate
    GROUP BY jp.id_material
) permintaan ON pengadaan.id_material = permintaan.id_material
WHERE pengadaan.stok_masuk IS NOT NULL OR permintaan.stok_keluar IS NOT NULL;