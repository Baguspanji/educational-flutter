import 'package:gastrofun/models/chapter_content_model.dart';

class DigestiveSystemContent {
  static List<ChapterContent> chapters = [
    // Bab 1
    ChapterContent(
      title: 'Pengantar Sistem Pencernaan - "Mesin" Pengolah Energi Tubuh',
      sections: [
        ContentSection(
          blocks: [
            ContentBlock(
              text:
                  'Setiap hari, tubuh kita membutuhkan "bahan bakar" untuk dapat beraktivitas, berpikir, dan bertumbuh. Bahan bakar ini berasal dari makanan yang kita konsumsi. Namun, tubuh tidak bisa langsung menggunakan nasi, daging, atau sayuran begitu saja. Makanan tersebut perlu dipecah menjadi molekul-molekul kecil yang disebut zat gizi agar dapat diserap dan digunakan oleh sel-sel di seluruh tubuh.',
            ),
            ContentBlock(
              text:
                  'Proses kompleks inilah yang dijalankan oleh sistem pencernaan. Anggaplah sistem pencernaan sebagai sebuah "pabrik" biokimia canggih. Sistem ini adalah serangkaian organ yang bekerja secara terkoordinasi untuk mengubah makanan menjadi energi dan nutrisi, serta membuang sisa-sisa yang tidak lagi diperlukan. Perjalanan makanan ini dimulai dari mulut dan akan berakhir di anus, melewati serangkaian proses yang luar biasa di sepanjang jalan.',
            ),
            ContentBlock(
              text:
                  'Dalam bab-bab selanjutnya, kita akan "membongkar" setiap bagian dari sistem ini untuk memahami bagaimana setiap komponen bekerja secara sinergis.',
            ),
          ],
        ),
      ],
    ),

    // Bab 2
    ChapterContent(
      title: 'Dua Proses Utama Pencernaan - Mekanik vs. Kimiawi',
      sections: [
        ContentSection(
          blocks: [
            ContentBlock(
              text:
                  'Untuk mengubah makanan menjadi zat gizi, tubuh kita menggunakan dua metode utama yang bekerja secara bersamaan.',
            ),
          ],
        ),
        ContentSection(
          subtitle: '2.1 Pencernaan Mekanik: Penghancuran Fisik',
          blocks: [
            ContentBlock(
              text:
                  'Pencernaan mekanik adalah proses pemecahan makanan dari ukuran besar menjadi potongan-potongan yang lebih kecil secara fisik. Proses ini tidak mengubah susunan kimia makanan, tetapi sangat penting untuk memperluas area permukaan makanan, sehingga enzim nantinya dapat bekerja lebih efisien.',
            ),
            ContentBlock(
              text:
                  'Di Mulut: Proses ini dimulai saat gigi mengunyah makanan. Gigi seri memotong, gigi taring merobek, dan gigi geraham menggiling makanan hingga menjadi partikel kecil.',
              type: BlockType.bulletPoint,
            ),
            ContentBlock(
              text:
                  'Di Lambung: Dinding lambung yang berotot akan bergerak meremas dan mengaduk makanan, mencampurnya dengan getah lambung hingga menjadi seperti bubur kental yang disebut kimus.',
              type: BlockType.bulletPoint,
            ),
          ],
        ),
        ContentSection(
          subtitle: '2.2 Pencernaan Kimiawi: Pemecahan Molekuler dengan Enzim',
          blocks: [
            ContentBlock(
              text:
                  'Pencernaan kimiawi adalah proses penguraian molekul kompleks dalam makanan (karbohidrat, protein, lemak) menjadi molekul yang lebih sederhana dengan bantuan zat kimia khusus yang disebut enzim. Enzim berfungsi sebagai katalisator biologis yang mempercepat reaksi kimia tanpa ikut bereaksi.',
            ),
            ContentBlock(text: 'Proses ini terjadi di beberapa lokasi utama:'),
            ContentBlock(
              text:
                  'Mulut: Enzim amilase dalam air liur mulai memecah karbohidrat.',
              type: BlockType.bulletPoint,
            ),
            ContentBlock(
              text: 'Lambung: Enzim pepsin mulai memecah protein.',
              type: BlockType.bulletPoint,
            ),
            ContentBlock(
              text:
                  'Usus Halus: Ini adalah arena utama pencernaan kimiawi, di mana berbagai macam enzim dari pankreas dan dinding usus halus bekerja untuk menyelesaikan pemecahan karbohidrat, protein, dan lemak.',
              type: BlockType.bulletPoint,
            ),
          ],
        ),
      ],
    ),

    // Bab 3
    ChapterContent(
      title: 'Organ-Organ Utama Sistem Pencernaan - Tur di Sepanjang Saluran',
      sections: [
        ContentSection(
          blocks: [
            ContentBlock(
              text:
                  'Mari kita telusuri perjalanan makanan dari awal hingga akhir dan mengenal setiap organ yang terlibat.',
            ),
          ],
        ),
        ContentSection(
          subtitle: '3.1 Pintu Gerbang: Mulut',
          blocks: [
            ContentBlock(
              text:
                  'Mulut adalah titik awal dari semua proses pencernaan. Di sini terjadi:',
            ),
            ContentBlock(
              text:
                  'Pencernaan Mekanik: Oleh gigi yang mengunyah makanan. Manusia memiliki berbagai jenis gigi dengan fungsi spesifik: gigi seri untuk memotong, taring untuk merobek, serta premolar dan molar untuk menggiling.',
              type: BlockType.bulletPoint,
            ),
            ContentBlock(
              text:
                  'Pencernaan Kimiawi: Kelenjar ludah memproduksi air liur yang mengandung enzim amilase (ptialin), yang memulai pemecahan pati (karbohidrat) menjadi gula yang lebih sederhana.',
              type: BlockType.bulletPoint,
            ),
            ContentBlock(
              text:
                  'Lidah: Berperan dalam mengaduk makanan, mencampurnya dengan air liur, dan mendorongnya ke belakang untuk proses menelan.',
              type: BlockType.bulletPoint,
            ),
          ],
        ),
        ContentSection(
          subtitle: '3.2 Saluran Penghubung: Kerongkongan (Esofagus)',
          blocks: [
            ContentBlock(
              text:
                  'Setelah ditelan, makanan tidak jatuh begitu saja ke lambung. Makanan didorong melalui kerongkongan, sebuah tabung berotot, oleh gerakan ritmis yang disebut gerakan peristaltik. Gerakan ini seperti gelombang kontraksi otot yang memastikan makanan bergerak ke arah yang benar, yaitu menuju lambung.',
            ),
          ],
        ),
        ContentSection(
          subtitle: '3.3 "Mixer" Asam: Lambung',
          blocks: [
            ContentBlock(
              text:
                  'Lambung adalah organ berotot berbentuk seperti kantong di mana makanan akan ditampung dan diproses selama beberapa jam. Di dalam lambung terjadi:',
            ),
            ContentBlock(
              text: 'Pencernaan Mekanik: Otot lambung mengaduk-aduk makanan.',
              type: BlockType.bulletPoint,
            ),
            ContentBlock(
              text:
                  'Pencernaan Kimiawi: Dinding lambung mengeluarkan getah lambung yang berisi:',
              type: BlockType.bulletPoint,
            ),
            ContentBlock(
              text:
                  'Asam Klorida (HCl): Menciptakan suasana yang sangat asam (pH 1.5-3.5) untuk membunuh sebagian besar kuman dan bakteri yang masuk bersama makanan, serta mengaktifkan enzim pepsin.',
              type: BlockType.bulletPoint,
            ),
            ContentBlock(
              text:
                  'Enzim Pepsin: Berfungsi memecah protein menjadi molekul yang lebih kecil yang disebut pepton.',
              type: BlockType.bulletPoint,
            ),
          ],
        ),
        ContentSection(
          subtitle: '3.4 Pusat Penyerapan: Usus Halus',
          blocks: [
            ContentBlock(
              text:
                  'Dari lambung, makanan yang sudah berbentuk bubur (kimus) masuk ke usus halus, organ terpanjang dalam sistem pencernaan. Di sinilah sebagian besar pencernaan kimiawi dan penyerapan nutrisi terjadi. Proses ini dibantu oleh tiga organ tambahan:',
            ),
            ContentBlock(
              text:
                  'Hati: Menghasilkan cairan empedu yang disimpan di kantong empedu. Empedu ini berfungsi untuk mengemulsikan (memecah) lemak menjadi butiran-butiran kecil agar mudah dicerna oleh enzim.',
              type: BlockType.bulletPoint,
            ),
            ContentBlock(
              text:
                  'Pankreas: Menghasilkan getah pankreas yang berisi enzim-enzim kuat:',
              type: BlockType.bulletPoint,
            ),
            ContentBlock(
              text: 'Amilase: Melanjutkan pencernaan karbohidrat.',
              type: BlockType.bulletPoint,
            ),
            ContentBlock(
              text: 'Tripsin: Melanjutkan pencernaan protein.',
              type: BlockType.bulletPoint,
            ),
            ContentBlock(
              text: 'Lipase: Mencerna lemak yang sudah diemulsikan.',
              type: BlockType.bulletPoint,
            ),
            ContentBlock(
              text:
                  'Dinding Usus Halus: Permukaannya dipenuhi oleh jutaan lipatan kecil seperti jari yang disebut vili. Vili ini memperluas area penyerapan secara drastis, memungkinkan zat-zat gizi yang sudah sederhana (gula, asam amino, asam lemak) diserap masuk ke dalam aliran darah.',
              type: BlockType.bulletPoint,
            ),
          ],
        ),
        ContentSection(
          subtitle: '3.5 Pengelola Sisa: Usus Besar dan Rektum',
          blocks: [
            ContentBlock(
              text:
                  'Sisa makanan yang tidak dapat dicerna atau diserap (terutama serat) akan melanjutkan perjalanannya ke usus besar. Fungsi utama usus besar adalah:',
            ),
            ContentBlock(
              text:
                  'Penyerapan Air: Menyerap kembali sebagian besar air dari sisa makanan, memadatkannya menjadi feses.',
              type: BlockType.bulletPoint,
            ),
            ContentBlock(
              text:
                  'Pembusukan: Dengan bantuan bakteri baik (seperti E. coli), sisa makanan dibusukkan dan beberapa vitamin penting (seperti vitamin K) disintesis.',
              type: BlockType.bulletPoint,
            ),
            ContentBlock(
              text:
                  'Feses yang sudah terbentuk kemudian disimpan sementara di rektum, bagian ujung dari usus besar, sebelum akhirnya dikeluarkan dari tubuh.',
            ),
          ],
        ),
        ContentSection(
          subtitle: '3.6 Pintu Keluar: Anus',
          blocks: [
            ContentBlock(
              text:
                  'Anus adalah lubang di ujung saluran pencernaan tempat feses dikeluarkan dari tubuh melalui proses yang disebut defekasi.',
            ),
          ],
        ),
      ],
    ),

    // Bab 4
    ChapterContent(
      title: 'Gangguan Umum pada Sistem Pencernaan dan Cara Mencegahnya',
      sections: [
        ContentSection(
          blocks: [
            ContentBlock(
              text:
                  'Sistem yang kompleks ini bisa mengalami gangguan jika tidak dirawat dengan baik. Memahami masalah ini penting untuk menjaga kesehatan.',
            ),
            ContentBlock(
              text:
                  'Sembelit (Konstipasi): Kesulitan buang air besar yang disebabkan oleh feses yang keras dan kering. Umumnya terjadi karena kurangnya asupan serat dan cairan.',
              type: BlockType.bulletPoint,
            ),
            ContentBlock(
              text:
                  'Diare: Kondisi di mana buang air besar menjadi encer dan frekuensinya meningkat. Sering kali disebabkan oleh infeksi bakteri atau virus dari makanan atau minuman yang terkontaminasi.',
              type: BlockType.bulletPoint,
            ),
            ContentBlock(
              text:
                  'Maag (Gastritis): Rasa nyeri atau perih di ulu hati akibat peradangan pada dinding lambung, seringkali karena produksi asam lambung yang berlebihan.',
              type: BlockType.bulletPoint,
            ),
            ContentBlock(
              text:
                  'Keracunan Makanan: Gejala seperti mual, muntah, dan diare yang muncul setelah mengonsumsi makanan yang terkontaminasi oleh kuman atau racun.',
              type: BlockType.bulletPoint,
            ),
            ContentBlock(
              text:
                  'Infeksi Usus: Peradangan pada usus yang disebabkan oleh bakteri atau parasit.',
              type: BlockType.bulletPoint,
            ),
            ContentBlock(
              text:
                  'Pencegahan adalah kunci. Dengan menerapkan gaya hidup sehat, kita bisa menjaga "mesin" pencernaan kita tetap berfungsi optimal.',
            ),
          ],
        ),
      ],
    ),

    // Bab 5
    ChapterContent(
      title: 'Panduan Praktis Menjaga Kesehatan Sistem Pencernaan',
      sections: [
        ContentSection(
          blocks: [
            ContentBlock(
              text:
                  'Merawat sistem pencernaan adalah investasi jangka panjang untuk kesehatan tubuh secara keseluruhan. Berikut adalah langkah-langkah praktis yang bisa diterapkan:',
            ),
            ContentBlock(
              text:
                  'Konsumsi Makanan Kaya Serat: Makanlah banyak sayuran, buah-buahan, dan biji-bijian utuh. Serat membantu melancarkan pergerakan usus dan mencegah sembelit.',
              type: BlockType.bulletPoint,
            ),
            ContentBlock(
              text:
                  'Minum Air yang Cukup: Air sangat penting untuk membantu proses pencernaan dan penyerapan nutrisi, serta mencegah dehidrasi yang dapat menyebabkan sembelit.',
              type: BlockType.bulletPoint,
            ),
            ContentBlock(
              text:
                  'Makan Secara Teratur dan Penuh Kesadaran: Hindari makan terburu-buru. Kunyah makanan secara perlahan untuk membantu kerja mulut dan lambung.',
              type: BlockType.bulletPoint,
            ),
            ContentBlock(
              text:
                  'Jaga Kebersihan: Selalu cuci tangan dengan sabun sebelum makan untuk mencegah masuknya kuman ke dalam tubuh. Hindari jajan di tempat yang kebersihannya diragukan.',
              type: BlockType.bulletPoint,
            ),
            ContentBlock(
              text:
                  'Kelola Stres: Stres dapat memengaruhi fungsi sistem pencernaan. Lakukan aktivitas yang menenangkan seperti meditasi atau olahraga.',
              type: BlockType.bulletPoint,
            ),
            ContentBlock(
              text:
                  'Rutin Berolahraga: Aktivitas fisik dapat merangsang kontraksi otot usus, membantu makanan bergerak lebih lancar di sepanjang saluran pencernaan.',
              type: BlockType.bulletPoint,
            ),
            ContentBlock(
              text:
                  'Dengan memahami setiap detail dari cara kerja sistem pencernaan, kita bisa lebih menghargai proses luar biasa yang terjadi di dalam tubuh dan membuat pilihan yang lebih baik untuk menjaga kesehatannya.',
            ),
          ],
        ),
      ],
    ),
  ];
}
