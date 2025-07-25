# DRIA Node Otomatik Kurulum Betiği (macOS)

Bu betik, **macOS (Apple Silicon & Intel)** işletim sistemine sahip bilgisayarlarda [Ollama](https://ollama.com/), [Gemma](https://ollama.com/library/gemma) ve [DRIA Compute Node](https://dria.co/) kurulumunu tek bir komutla otomatikleştirmek için tasarlanmıştır.

Kurulum sürecini basitleştirir, gerekli bağımlılıkları (Homebrew gibi) kontrol eder, yaygın ağ hatalarını gidermeye çalışır ve kullanıcıyı adım adım yönlendirir. Özellikle düşük RAM'e sahip sistemler için optimize edilmiştir.

## 🎯 Ne İşe Yarar?

Bu betik aşağıdaki işlemleri sırasıyla ve otomatik olarak gerçekleştirir:

1.  **Homebrew Kontrolü ve Kurulumu:** Sisteminizde Homebrew paket yöneticisi yüklü değilse, otomatik olarak kurar ve kabuk (shell) yapılandırmanıza ekler.
2.  **Ollama Kurulumu:** Homebrew aracılığıyla en güncel Ollama versiyonunu kurar.
3.  **Gemma Modelini İndirme:** DRIA için gerekli olan ve daha az kaynak tüketen `gemma:4b` modelini Ollama kütüphanesinden indirir. Olası DNS ve ağ hatalarına karşı ikinci bir deneme ve önbellek temizleme mekanizması içerir.
4.  **DRIA Compute Node Kurulumu:** DRIA'nın resmi başlatıcısını (`dkn-compute-launcher`) indirir ve kurar.
5.  **DRIA Düğümünü Başlatma:** Kurulumun son adımında DRIA düğümünü başlatır ve ilk yapılandırma için sizi yönlendirir.

## ⚙️ Minimum Sistem Gereksinimleri

-   **İşletim Sistemi:** macOS 11.0 (Big Sur) veya daha yenisi.
-   **Mimarî:** Apple Silicon (M1, M2, M3, M4 serisi) veya Intel işlemcili Mac'ler.
-   **RAM:** Minimum **8 GB RAM**. 16 GB veya daha fazlası tavsiye edilir.
-   **Disk Alanı:** Minimum **15 GB** boş disk alanı (Homebrew, Ollama, Gemma modeli ve DRIA için).
-   **İnternet Bağlantısı:** Kurulum sırasında paketleri ve modeli indirmek için aktif ve stabil bir internet bağlantısı gereklidir.

## 🚀 Nasıl Kullanılır?

Kurulumu başlatmak için tek yapmanız gereken, aşağıdaki komutu kopyalayıp Mac'inizdeki **Terminal** uygulamasına yapıştırmak ve `Enter` tuşuna basmaktır.

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/sh3rly13/dria_node/main/dria_low.sh)"
```

> **Önemli:** Yukarıdaki komutta `KULLANICI_ADINIZ` ve `REPO_ADINIZ` kısımlarını kendi GitHub kullanıcı adınız ve repository adınız ile değiştirmeyi unutmayın!

### Kurulum Süreci

1.  Komutu çalıştırdığınızda, betik başlayacak ve adımları size bildirecektir.
2.  Homebrew veya DRIA kurulumu sırasında sizden **yönetici (sudo) şifreniz** istenebilir. Şifrenizi yazdığınızda ekranda görünmeyecektir, bu normaldir. Yazıp `Enter`'a basın.
3.  Kurulumun sonunda DRIA başlatıcısı çalışacak ve sizden cüzdan özel anahtarınızı (`wallet private key`) girmenizi ve model seçmenizi isteyecektir.
4.  **Model Seçimi:** Listeden **`gemma:4b`** modelini seçtiğinizden emin olun. Betik bu modeli zaten indirmiş olacaktır.

## ⚠️ Olası Sorunlar ve Çözümleri

-   **Hata: `Permission denied`**
    -   **Çözüm:** Bu betiği yukarıdaki tek satırlık `curl` komutuyla çalıştırdığınızda bu hatayı almazsınız. Eğer dosyayı manuel indirip çalıştırıyorsanız, `chmod +x dria_low.sh` komutuyla çalıştırma izni vermeniz gerekir.

-   **Hata: Gemma modeli indirilemedi.**
    -   **Çözüm:** Betik, DNS önbelleğini temizleyerek sorunu çözmeye çalışır. Eğer sorun devam ederse, betiğin de belirttiği gibi DNS sunucunuzu geçici olarak `8.8.8.8` (Google) veya `1.1.1.1` (Cloudflare) olarak değiştirip tekrar deneyin.

-   **Sorun: Kurulum bitti ama DRIA `gemma:4b` modelini görmüyor.**
    -   **Çözüm:** Betiğin sonundaki talimatları izleyin:
        1.  Önce modeli manuel olarak çekin:
            ```bash
            ollama pull gemma:4b
            ```
        2.  Ardından DRIA yapılandırmasını tekrar başlatın:
            ```bash
            dkn-compute-launcher setup
            ```

## 💬 İletişim

Kurulum sırasında bir sorunla karşılaşırsanız veya bir öneriniz varsa, aşağıdaki kanaldan iletişime geçebilirsiniz:

-   **X (Twitter):** [@sh3rly13](https://twitter.com/sh3rly13)
-   **GitHub Issues:** Projenin [Issues](https://github.com/sh3rly13/dria_node/issues) bölümünden yeni bir konu açabilirsiniz.
