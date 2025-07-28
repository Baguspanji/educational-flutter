import '../models/content_models.dart';

class ArtikelRepository {
  // Singleton pattern
  ArtikelRepository._privateConstructor();
  static final ArtikelRepository instance =
      ArtikelRepository._privateConstructor();

  // Dummy data for Artikel
  final List<Artikel> _artikels = [
    Artikel(
      id: 'art-001',
      title: 'Pentingnya Matematika dalam Kehidupan',
      category: 'Matematika',
      createdAt: DateTime(2025, 5, 14),
      description:
          'Artikel tentang pentingnya matematika dalam aspek kehidupan sehari-hari',
      author: 'Dr. Budi Santoso',
      content: '''
        Matematika seringkali dipandang sebagai mata pelajaran yang abstrak dan tidak terkait langsung dengan kehidupan sehari-hari. Namun, faktanya matematika adalah dasar dari banyak aspek kehidupan modern kita.

        Di bidang ekonomi, pemahaman matematika dibutuhkan untuk mengelola keuangan pribadi, mulai dari menabung, investasi, hingga perencanaan pensiun. Di dunia teknologi, algoritma yang menjadi dasar hampir semua perangkat lunak dan aplikasi yang kita gunakan sehari-hari berasal dari konsep matematika.

        Bahkan dalam seni, prinsip-prinsip matematika seperti proporsi, simetri, dan pola memberikan struktur pada karya-karya visual dan musik. Dalam arsitektur, matematika membantu menciptakan struktur yang tidak hanya indah tapi juga kuat dan fungsional.

        Kemampuan berpikir logis dan analitis yang diasah melalui pembelajaran matematika juga membantu kita dalam pengambilan keputusan sehari-hari. Dengan memahami statistik dasar, kita dapat lebih kritis dalam menafsirkan informasi dan data yang sekarang membanjiri kehidupan digital kita.

        Jadi, matematika bukan sekadar pelajaran di sekolah, tapi keterampilan hidup yang penting untuk sukses di era modern.
      ''',
      readTimeMinutes: 5,
    ),
    Artikel(
      id: 'art-002',
      title: 'Aplikasi Fisika di Era Modern',
      category: 'Fisika',
      createdAt: DateTime(2025, 5, 22),
      description: 'Menelusuri aplikasi prinsip fisika dalam teknologi modern',
      author: 'Prof. Indah Pratiwi',
      content: '''
        Fisika bukan hanya teori yang dipelajari di ruang kelas, tetapi ilmu yang secara langsung mempengaruhi perkembangan teknologi yang kita gunakan sehari-hari. Dari smartphone hingga transportasi, prinsip fisika berada di balik hampir semua teknologi modern.

        Pemahaman tentang elektromagnetisme memungkinkan kita mengembangkan teknologi wireless yang menjadi tulang punggung komunikasi modern. Hukum termodinamika membantu kita membangun mesin yang lebih efisien, dari kendaraan hingga pembangkit listrik.

        Dalam bidang kesehatan, teknologi pencitraan seperti MRI yang didasarkan pada prinsip fisika kuantum telah merevolusi diagnosis medis. Sementara itu, fisika nuklir memungkinkan pengembangan terapi radiasi untuk pengobatan kanker.

        Teknologi energi terbarukan seperti panel surya dan turbin angin juga tidak dapat dipisahkan dari pemahaman mendalam tentang prinsip fisika. Bahkan teknologi display seperti LCD dan OLED pada perangkat yang kita gunakan setiap hari memanfaatkan sifat fisika material dan cahaya.

        Dengan kemajuan dalam fisika kuantum, kita sekarang berada di ambang revolusi komputasi kuantum yang mungkin akan mengubah paradigma teknologi informasi. Semua ini menunjukkan betapa fisika terus menjadi pendorong utama inovasi di era modern.
      ''',
      readTimeMinutes: 6,
      isBookmarked: true,
    ),
    Artikel(
      id: 'art-003',
      title: 'Tips Belajar Bahasa Inggris',
      category: 'Bahasa',
      createdAt: DateTime(2025, 6, 8),
      description:
          'Kumpulan tips efektif untuk meningkatkan kemampuan bahasa Inggris',
      author: 'Linda Wijaya',
      content: '''
        Belajar bahasa Inggris tidak harus melalui metode konvensional yang membosankan. Ada banyak cara kreatif dan menyenangkan yang dapat membantu meningkatkan kemampuan berbahasa Inggris Anda.

        Pertama, konsistenlah dalam belajar. Lebih baik belajar 15 menit setiap hari daripada 2 jam sekali seminggu. Otak kita memproses dan menyimpan informasi lebih efektif dengan paparan reguler.

        Kedua, manfaatkan media yang Anda sukai. Jika Anda suka film, tontonlah film berbahasa Inggris dengan subtitle bahasa Inggris. Penggemar musik bisa mempelajari lirik lagu favorit dan mencari tahu artinya.

        Ketiga, praktikkan percakapan sebanyak mungkin. Bergabunglah dengan kelompok belajar bahasa, cari partner berbahasa Inggris, atau gunakan aplikasi language exchange. Berbicara adalah cara terbaik untuk membangun kepercayaan diri dan kelancaran.

        Keempat, perbanyak kosakata secara kontekstual. Daripada menghafal daftar kata, pelajari kosakata baru dalam konteks kalimat atau situasi. Ini membantu Anda mengingat kata dan menggunakannya secara tepat.

        Terakhir, jangan takut membuat kesalahan. Kesalahan adalah bagian natural dari proses belajar. Yang terpenting adalah berani mencoba dan terus memperbaiki diri.
      ''',
      readTimeMinutes: 4,
      isCompleted: true,
    ),
    Artikel(
      id: 'art-004',
      title: 'Pengaruh Sosial Media terhadap Budaya',
      category: 'Sosial',
      createdAt: DateTime(2025, 6, 20),
      description:
          'Analisis dampak media sosial pada perkembangan budaya kontemporer',
      author: 'Dr. Ahmad Fauzi',
      content: '''
        Media sosial telah menjadi katalis perubahan budaya yang signifikan dalam masyarakat modern. Platform digital ini tidak hanya mengubah cara kita berkomunikasi, tetapi juga mentransformasi bagaimana budaya diciptakan, disebarkan, dan diadopsi.

        Salah satu dampak paling signifikan adalah demokratisasi produksi konten budaya. Dulu, konten budaya seperti musik, film, atau literatur diproduksi oleh industri besar. Sekarang, siapa saja dengan smartphone dapat menjadi kreator dan menjangkau audiens global.

        Media sosial juga mempercepat difusi budaya lintas geografis. Tren fashion, musik, atau kuliner dari satu negara dapat dengan cepat menjadi populer di belahan dunia lain hanya dalam hitungan hari. Hal ini menciptakan fenomena "global village" di mana batas-batas budaya tradisional menjadi semakin kabur.

        Di sisi lain, media sosial juga mendorong fragmentasi budaya. Algoritma yang mempersonalisasi konten menciptakan "filter bubble" di mana orang cenderung hanya terpapar pada konten yang sesuai dengan preferensi mereka. Ini bisa mengurangi pemahaman dan apresiasi terhadap keberagaman budaya.

        Transformasi digital juga mengubah ritual dan tradisi. Perayaan budaya yang dulunya bersifat lokal dan komunal kini sering dipresentasikan dan dirayakan secara digital, mengubah makna dan pengalaman kolektif dari tradisi tersebut.

        Meskipun perubahan ini membawa tantangan, media sosial juga menawarkan peluang untuk pelestarian dan revitalisasi budaya tradisional. Komunitas dengan budaya minoritas kini memiliki platform untuk mempresentasikan dan mempertahankan identitas budaya mereka di era digital.
      ''',
      readTimeMinutes: 7,
    ),
    Artikel(
      id: 'art-005',
      title: 'Kimia dalam Makanan Sehari-hari',
      category: 'Kimia',
      createdAt: DateTime(2025, 7, 11),
      description:
          'Mengenal reaksi kimia pada proses memasak dan pengawetan makanan',
      author: 'Dr. Siti Aminah',
      content: '''
        Dapur adalah laboratorium kimia yang kita gunakan setiap hari. Setiap kali kita memasak, berbagai reaksi kimia kompleks terjadi yang mengubah bahan mentah menjadi hidangan lezat yang kita nikmati.

        Proses pemasakan seperti merebus, menggoreng, memanggang, dan memfermentasi semuanya melibatkan reaksi kimia yang berbeda. Contohnya, ketika daging dipanaskan, terjadi reaksi Maillard antara asam amino dan gula yang menghasilkan warna cokelat dan aroma yang khas.

        Pengembangan adonan roti melibatkan reaksi fermentasi di mana ragi mengubah gula menjadi karbon dioksida, membuat adonan mengembang. Sementara itu, proses karamelisasi gula adalah contoh klasik reaksi pirolisis yang mengubah gula menjadi senyawa dengan rasa dan aroma yang kompleks.

        Bahan pengawet makanan juga bekerja melalui prinsip kimia. Garam dan gula digunakan sebagai pengawet karena kemampuannya menciptakan lingkungan hipertonik yang menghambat pertumbuhan mikroba. Asam seperti cuka atau asam sitrus menurunkan pH makanan, membuat lingkungan yang tidak kondusif bagi bakteri.

        Bahkan proses mencuci sayuran melibatkan prinsip kimia, di mana air sebagai pelarut universal membantu melarutkan kotoran dan residu dari permukaan sayuran. 

        Memahami prinsip-prinsip kimia dalam memasak tidak hanya membuat kita menjadi koki yang lebih baik, tetapi juga membantu kita membuat keputusan lebih informasi tentang cara menyimpan, menyiapkan, dan mengonsumsi makanan dengan aman dan efektif.
      ''',
      readTimeMinutes: 5,
      isBookmarked: true,
    ),
    Artikel(
      id: 'art-006',
      title: 'Biodiversitas Indonesia yang Terancam',
      category: 'Biologi',
      createdAt: DateTime(2025, 7, 16),
      description:
          'Ulasan tentang keanekaragaman hayati Indonesia dan upaya konservasinya',
      author: 'Prof. Surya Darma',
      content: '''
        Indonesia dikenal sebagai salah satu negara dengan biodiversitas tertinggi di dunia. Terletak di wilayah Wallacea, pertemuan antara zona Asia dan Australia, Indonesia memiliki kombinasi unik flora dan fauna yang tidak ditemukan di tempat lain.

        Dengan lebih dari 17.000 pulau, Indonesia menjadi rumah bagi sekitar 17% spesies mamalia dunia, 16% reptil dan amfibi, 17% burung, dan 25% spesies ikan. Hutan hujan tropisnya menyimpan ribuan jenis tumbuhan, banyak di antaranya memiliki potensi obat yang belum sepenuhnya dieksplorasi.

        Sayangnya, kekayaan biodiversitas ini terancam oleh berbagai faktor. Deforestasi untuk pembukaan lahan pertanian dan perkebunan telah menghancurkan habitat alami banyak spesies. Perubahan iklim juga memberikan tekanan tambahan pada ekosistem yang sudah rentan.

        Perdagangan ilegal satwa liar terus menjadi ancaman serius bagi spesies langka Indonesia. Dari orangutan hingga burung cenderawasih, banyak spesies ikonik Indonesia berada di ambang kepunahan akibat perburuan dan perdagangan ilegal.

        Berbagai upaya konservasi telah dilakukan, termasuk pembentukan taman nasional, program penangkaran ex-situ, dan inisiatif berbasis masyarakat. Namun, tantangan konservasi tetap besar dan memerlukan pendekatan terpadu yang melibatkan pemerintah, komunitas lokal, sektor swasta, dan masyarakat internasional.

        Melindungi biodiversitas Indonesia bukan hanya tanggung jawab nasional, tetapi juga global. Sebagai "megadiversity country", Indonesia memegang peran kunci dalam menjaga keseimbangan ekosistem global dan melestarikan keanekaragaman hayati untuk generasi mendatang.
      ''',
      readTimeMinutes: 8,
    ),
  ];

  // Get all artikels
  List<Artikel> getAllArtikels() {
    return _artikels;
  }

  // Get artikels by category
  List<Artikel> getArtikelsByCategory(String category) {
    return _artikels.where((artikel) => artikel.category == category).toList();
  }

  // Get artikel by id
  Artikel? getArtikelById(String id) {
    try {
      return _artikels.firstWhere((artikel) => artikel.id == id);
    } catch (e) {
      return null;
    }
  }

  // Get artikels by author
  List<Artikel> getArtikelsByAuthor(String author) {
    return _artikels.where((artikel) => artikel.author == author).toList();
  }

  // Get bookmarked artikels
  List<Artikel> getBookmarkedArtikels() {
    return _artikels.where((artikel) => artikel.isBookmarked).toList();
  }

  // Get quick reads (under 5 minutes)
  List<Artikel> getQuickReads() {
    return _artikels.where((artikel) => artikel.readTimeMinutes <= 5).toList();
  }

  // Get completed artikels
  List<Artikel> getCompletedArtikels() {
    return _artikels.where((artikel) => artikel.isCompleted).toList();
  }
}
