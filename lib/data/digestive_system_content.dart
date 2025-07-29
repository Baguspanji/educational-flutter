import 'package:gastrofun/models/chapter_content_model.dart';

class DigestiveSystemContent {
  static List<ChapterContent> chapters = [
    // Bab 1
    ChapterContent(
      title: 'Cover Materi - Sistem Pencernaan',
      sections: [
        ContentSection(
          blocks: [
            ContentBlock(
              text: 'assets/images/materi-1.jpg',
              type: BlockType.image,
            ),
          ],
        ),
      ],
    ),

    // Bab 2
    ChapterContent(
      title: 'Apa itu Sistem Pencernaan?',
      sections: [
        ContentSection(
          blocks: [
            ContentBlock(
              text:
                  'Setiap hari kita makan agar tubuh kita kuat, sehat, dan bisa tumbuh. Namun, makanan tidak langsung bisa digunakan oleh tubuh. Makanan harus diproses terlebih dahulu agar zat gizinya dapat diserap oleh darah dan diedarkan ke seluruh tubuh. Proses inilah yang disebut pencernaan makanan.',
            ),
            ContentBlock(
              text: 'assets/images/materi-2.jpg',
              type: BlockType.image,
            ),
            ContentBlock(
              text:
                  'Sistem pencernaan adalah rangkaian organ tubuh yang bertugas untuk mengolah makanan menjadi zat gizi dan membuang sisa yang tidak dibutuhkan. Organ-organ ini bekerja sama, mulai dari saat makanan masuk ke mulut hingga sisa makanan dikeluarkan melalui anus (Kemdikbudristek, 2022).',
            ),
          ],
        ),
      ],
    ),

    // Bab 3
    ChapterContent(
      title: 'Jenis-Jenis Pencernaan',
      sections: [
        ContentSection(
          blocks: [
            ContentBlock(
              text: 'Dalam tubuh kita, terdapat dua jenis pencernaan:',
            ),
          ],
        ),
        ContentSection(
          subtitle: '1. Pencernaan Mekanik',
          blocks: [
            ContentBlock(
              text:
                  'Ini adalah proses menghancurkan makanan secara fisik. Contohnya adalah saat kita mengunyah makanan dengan gigi, atau saat lambung mengaduk makanan.',
              type: BlockType.bulletPoint,
            ),
          ],
        ),
        ContentSection(
          subtitle: '2. Pencernaan Kimiawi',
          blocks: [
            ContentBlock(
              text:
                  'Ini adalah proses menguraikan makanan dengan bantuan enzim. Enzim adalah zat yang mempercepat reaksi kimia di tubuh. Pencernaan kimiawi terjadi di mulut, lambung, dan usus halus (Suparno, 2020).',
              type: BlockType.bulletPoint,
            ),
          ],
        ),
      ],
    ),

    // Bab 4
    ChapterContent(
      title: 'Organ-Organ dalam Sistem Pencernaan',
      sections: [
        ContentSection(
          subtitle: '1. Mulut',
          blocks: [
            ContentBlock(
              text:
                  'Mulut adalah tempat pertama makanan masuk. Gigi mengunyah makanan, lidah membantu mengaduk dan menelan makanan, dan kelenjar ludah menghasilkan air liur (saliva) yang mengandung enzim amilase. Enzim amilase membantu mencerna karbohidrat menjadi gula sederhana.',
            ),
            ContentBlock(
              text: 'assets/images/materi-3.jpg',
              type: BlockType.image,
            ),
            ContentBlock(
              text:
                  'Di mulut, proses pencernaan dimulai dengan gigi. Setiap jenis gigi memiliki bentuk dan fungsi yang berbeda.',
            ),
            ContentBlock(
              text:
                  '1. Gigi Seri (Insisivus) \nTerletak di bagian depan mulut. Berfungsi untuk memotong makanan. Kita memiliki 8 gigi seri (4 atas dan 4 bawah).',
            ),
            ContentBlock(
              text:
                  '2. Gigi Taring (Caninus) \nTerletak di sebelah gigi seri. Berfungsi untuk merobek makanan, terutama daging. Ada 4 gigi taring (2 atas dan 2 bawah)',
            ),
            ContentBlock(
              text:
                  '3. Gigi Geraham (Molar dan Premolar) \nTerletak di bagian belakang mulut. Berfungsi untuk menghaluskan dan menggiling makanan. Jumlahnya lebih banyak daripada jenis gigi lainnya (Wahono, 2021).',
            ),
          ],
        ),
        ContentSection(
          subtitle: '2. Kerongkongan',
          blocks: [
            ContentBlock(
              text:
                  'Kerongkongan adalah saluran yang menghubungkan mulut ke lambung. Makanan didorong oleh gerakan otot yang disebut gerakan peristaltik.',
            ),
          ],
        ),
        ContentSection(
          subtitle: '3. Lambung',
          blocks: [
            ContentBlock(
              text:
                  'Lambung adalah kantong berotot yang mencampur makanan dengan asam lambung (HCl) dan enzim pepsin',
            ),
            ContentBlock(
              text: 'assets/images/materi-4.jpg',
              type: BlockType.image,
            ),
            ContentBlock(
              text:
                  'Asam lambung membunuh kuman dan membantu menguraikan makanan.',
              type: BlockType.bulletPoint,
            ),
            ContentBlock(
              text: 'Pepsin mencerna protein menjadi molekul yang lebih kecil.',
              type: BlockType.bulletPoint,
            ),
          ],
        ),
        ContentSection(
          subtitle: '4. Usus Halus',
          blocks: [
            ContentBlock(
              text:
                  'Setelah dari lambung, makanan masuk ke usus halus. Di sini terjadi proses pencernaan lanjutan dan penyerapan zat gizi.',
            ),
            ContentBlock(
              text: 'assets/images/materi-5.jpg',
              type: BlockType.image,
            ),
            ContentBlock(text: 'Organ lain yang membantu usus halus:'),
            ContentBlock(
              text: 'Hati menghasilkan empedu untuk memecah lemak',
              type: BlockType.bulletPoint,
            ),
            ContentBlock(
              text:
                  'Pankreas menghasilkan enzim tambahan: \nAmilase (melanjutkan pencernaan karbohidrat),\nTripsin (pencernaan protein),\nLipase (pencernaan lemak).',
              type: BlockType.bulletPoint,
            ),
            ContentBlock(
              text:
                  'Dinding usus halus memiliki tonjolan kecil yang disebut vili, tempat terjadinya penyerapan zat gizi ke dalam darah.',
            ),
          ],
        ),
        ContentSection(
          subtitle: '5. Usus Besar',
          blocks: [
            ContentBlock(
              text:
                  'Sisa makanan yang tidak dicerna masuk ke usus besar. Di sini, air diserap kembali, dan sisa makanan dipadatkan menjadi feses (kotoran).',
            ),
          ],
        ),
        ContentSection(
          subtitle: '6. Rektum',
          blocks: [
            ContentBlock(
              text:
                  'Rektum adalah bagian akhir dari usus besar yang berfungsi sebagai tempat penyimpanan sementara feses (kotoran) sebelum dikeluarkan melalui anus.',
            ),
          ],
        ),
        ContentSection(
          subtitle: '7. Anus',
          blocks: [
            ContentBlock(
              text:
                  'Feses dikeluarkan dari tubuh melalui anus. Proses ini disebut defekasi (Dwi, 2022).',
            ),
          ],
        ),
      ],
    ),

    // Bab 5
    ChapterContent(
      title: 'Gangguan pada Sistem Pencernaan',
      sections: [
        ContentSection(
          blocks: [
            ContentBlock(
              text:
                  'Sistem pencernaan bisa mengalami gangguan jika kita tidak menjaga pola makan dan kebersihan makanan. Berikut beberapa gangguan yang sering terjadi:',
            ),
            ContentBlock(
              text:
                  'Sembelit: susah buang air besar karena kurang serat dan air.',
              type: BlockType.bulletPoint,
            ),
            ContentBlock(
              text:
                  'Diare: buang air besar cair dan sering, disebabkan oleh bakteri atau virus.',
              type: BlockType.bulletPoint,
            ),
            ContentBlock(
              text: 'Maag: nyeri pada lambung karena asam lambung berlebih.',
              type: BlockType.bulletPoint,
            ),
            ContentBlock(
              text:
                  'Keracunan makanan: terjadi karena mengonsumsi makanan yang tercemar kuman atau zat beracun.',
              type: BlockType.bulletPoint,
            ),
            ContentBlock(
              text: 'Infeksi usus: disebabkan oleh bakteri atau parasit.',
              type: BlockType.bulletPoint,
            ),
          ],
        ),
      ],
    ),

    // Bab 6
    ChapterContent(
      title: 'Menjaga Kesehatan Sistem Pencernaan',
      sections: [
        ContentSection(
          blocks: [
            ContentBlock(
              text:
                  'Agar sistem pencernaan tetap sehat dan berfungsi dengan baik, kita perlu melakukan kebiasaan baik seperti:',
            ),
            ContentBlock(
              text: 'Makan makanan sehat dan kaya serat (sayur dan buah).',
              type: BlockType.bulletPoint,
            ),
            ContentBlock(
              text: 'Minum air putih yang cukup.',
              type: BlockType.bulletPoint,
            ),
            ContentBlock(
              text: 'Makan secara teratur dan tidak terburu-buru.',
              type: BlockType.bulletPoint,
            ),
            ContentBlock(
              text: 'Cuci tangan sebelum makan.',
              type: BlockType.bulletPoint,
            ),
            ContentBlock(
              text: 'Hindari makanan yang tidak bersih atau jajan sembarangan.',
              type: BlockType.bulletPoint,
            ),
            ContentBlock(
              text: 'Berolahraga secara rutin.',
              type: BlockType.bulletPoint,
            ),
          ],
        ),
      ],
    ),

    // Bab 7
    ChapterContent(
      title: 'Kesimpulan',
      sections: [
        ContentSection(
          blocks: [
            ContentBlock(
              text:
                  'Sistem pencernaan adalah sistem penting dalam tubuh manusia yang bertugas mengolah makanan agar tubuh bisa menyerap zat gizinya. Organ-organ seperti mulut, lambung, usus, dan enzim pencernaan bekerja sama dalam proses ini. Agar sistem pencernaan bekerja dengan baik, kita perlu menjaga pola makan, kebersihan, dan gaya hidup sehat.',
            ),
          ],
        ),
      ],
    ),

    // Daftar Pustaka
    ChapterContent(
      title: 'Daftar Pustaka',
      sections: [
        ContentSection(
          blocks: [
            ContentBlock(
              text:
                  'Kementerian Pendidikan dan Kebudayaan. (2022). Buku Siswa IPAS Kelas V SD Kurikulum Merdeka. Jakarta: Pusat Perbukuan.',
              type: BlockType.bulletPoint,
            ),
            ContentBlock(
              text:
                  'Suparno. (2020). Biologi Untuk SMP dan MTs. Jakarta: Grasindo.',
              type: BlockType.bulletPoint,
            ),
            ContentBlock(
              text:
                  'Widodo, Wahono. (2021). Ilmu Pengetahuan Alam untuk SD/MI Kelas V. Jakarta: Erlangga.',
              type: BlockType.bulletPoint,
            ),
            ContentBlock(
              text:
                  'Nugroho, Wasis Dwi dkk. (2022). Ilmu Pengetahuan Alam dan Sosial SD Kelas V. Jakarta: Pusat Perbukuan Kemendikbudristek.',
              type: BlockType.bulletPoint,
            ),
          ],
        ),
      ],
    ),
  ];
}
